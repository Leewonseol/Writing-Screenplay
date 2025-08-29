from flask import Flask, request, jsonify, render_template_string
from flask_cors import CORS
import google.generativeai as genai
import os
from dotenv import load_dotenv
import random

# 환경 변수 로드
load_dotenv()

app = Flask(__name__)
CORS(app)

# Gemini API 설정
GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
print(f"🔑 로드된 API 키: {GOOGLE_API_KEY[:10]}..." if GOOGLE_API_KEY else "❌ API 키 없음")
if GOOGLE_API_KEY:
    genai.configure(api_key=GOOGLE_API_KEY)
    # 최신 지원 모델 사용 및 폴백 구성
    try:
        model = genai.GenerativeModel('gemini-1.5-pro')
        # 더 일찍 오류 노출을 위해 no-op 호출 대신 모델 객체만 준비
    except Exception:
        # 구버전/권한 문제 시 경량 모델로 폴백
        model = genai.GenerativeModel('gemini-1.5-flash')
    print("✅ Gemini API가 설정되었습니다.")
else:
    print("⚠️  경고: GOOGLE_API_KEY가 설정되지 않았습니다.")
    print("📝 역할극 시연을 위해 모의 응답을 사용합니다.")
    model = None

# 역할극 시연을 위한 모의 응답들
MOCK_RESPONSES = {
    'situation_start': [
        "안녕하세요. 회복의 씨앗입니다. 지난 2주간 어떤 일 때문에 우울감에 3점을 부여하셨나요?",
        "안녕하세요. 회복의 씨앗입니다. 지난 2주간 어떤 일 때문에 불안감에 3점을 부여하셨나요?",],
    'empathy': [
        "그런 상황이 정말 힘드셨겠어요. 그때 어떤 감정을 느끼셨나요?",
        "그런 경험을 하셨다니 마음이 아프네요. 그 순간 가장 힘들었던 부분은 무엇이었나요?",
        "정말 어려운 상황이었겠어요. 그때 당신은 어떻게 대처하려고 하셨나요?"
    ],
    'socratic': [
        "그 상황에서 당신이 할 수 있는 다른 선택지가 있었다면 무엇이었을까요?",
        "만약 친한 친구가 같은 상황에 처했다면, 그 친구에게 어떤 조언을 해주고 싶으신가요?",
        "이 경험을 통해 당신이 배운 것이 있다면 무엇인가요?",
        "앞으로 비슷한 상황이 발생한다면, 이번 경험을 바탕으로 어떻게 다르게 대처하고 싶으신가요?"
    ],
    'encouragement': [
        "당신이 그 상황을 견뎌내고 있다는 것 자체가 이미 큰 용기입니다.",
        "어려운 시기를 지나고 있는 당신을 응원합니다. 이 상황은 영원하지 않을 거예요.",
        "당신의 내면에는 이미 해결책을 찾을 수 있는 힘이 있습니다. 천천히 찾아보세요."
    ]
}

def get_mock_response(user_message, context, chat_history):
    """사용자 메시지에 따라 적절한 모의 응답을 생성합니다."""
    message_lower = user_message.lower()
    
    # 상황 시작 (첫 응답)
    if any(word in message_lower for word in ['상사', '무시', '회사', '직장', '스트레스', '힘들', '짜증']):
        return random.choice(MOCK_RESPONSES['situation_start'])
    
    # 공감 응답
    elif any(word in message_lower for word in ['그래', '맞아', '그렇', '힘들', '어려워', '답답']):
        return random.choice(MOCK_RESPONSES['empathy'])
    
    # 소크라틱 질문
    elif any(word in message_lower for word in ['모르겠', '생각해보', '잘 모르', '그럴 수도']):
        return random.choice(MOCK_RESPONSES['socratic'])
    
    # 종료 명령
    elif '종료' in message_lower:
        return "오늘 대화를 마무리하겠습니다. 당신의 회복을 위한 한 걸음을 내딛으셨습니다. 내일도 힘내세요! 🌱"
    
    # 기본 응답 (소크라틱 질문)
    else:
        return random.choice(MOCK_RESPONSES['socratic'])

@app.route('/')
def index():
    return render_template_string('''
    <!DOCTYPE html>
    <html>
    <head>
        <title>시나리오 쓰기: 나의 이야기로 성장하기</title>
        <meta charset="UTF-8">
    </head>
    <body>
        <script>
            // HTML 파일로 리다이렉트
            window.location.href = '/자기자비 삭제.html';
        </script>
    </body>
    </html>
    ''')

@app.route('/api/gemini', methods=['POST'])
def gemini_api():
    try:
        data = request.get_json()
        user_message = data.get('message', '')
        context = data.get('context', '')
        chat_history = data.get('chatHistory', [])

        if not user_message:
            return jsonify({'error': '사용자 메시지가 없습니다.'}), 400

        # Gemini API가 설정된 경우 실제 API 호출
        if model:
            # 프롬프트 구성
            prompt_parts = []
            if context:
                prompt_parts.append(f"컨텍스트: {context}")
            if chat_history:
                chat_text = "\n".join([f"{'사용자' if msg['sender'] == 'user' else '챗봇'}: {msg['message']}" for msg in chat_history])
                prompt_parts.append(f"대화 기록:\n{chat_text}")
            prompt_parts.append(f"사용자 메시지: {user_message}")
            prompt_parts.append("위 상황에 대해 공감적이고 소크라틱한 질문으로 응답해주세요.")
            full_prompt = "\n\n".join(prompt_parts)

            # 모델 폴백: pro → flash 순서 시도 (쿼터/모델 오류 우회)
            candidate_models = ['gemini-1.5-pro', 'gemini-1.5-flash']
            for model_name in candidate_models:
                try:
                    temp_model = genai.GenerativeModel(model_name)
                    response = temp_model.generate_content(full_prompt)
                    if response and getattr(response, 'text', None):
                        return jsonify({'response': response.text})
                except Exception as e:
                    print(f"Gemini API 호출 오류({model_name}): {str(e)}")
                    # 429(쿼터) 또는 모델 미지원 시 다음 후보로 폴백
                    continue
            # 모든 시도가 실패한 경우에만 모의 응답 사용
            mock_response = get_mock_response(user_message, context, chat_history)
            return jsonify({'response': f"[API 오류로 인해 모의 응답입니다] {mock_response}"})

        # Gemini API가 설정되지 않은 경우 모의 응답 사용
        else:
            mock_response = get_mock_response(user_message, context, chat_history)
            return jsonify({'response': f"[모의 응답] {mock_response}"})

    except Exception as e:
        print(f"서버 오류: {str(e)}")
        return jsonify({
            'error': f'서버 오류가 발생했습니다: {str(e)}'
        }), 500

@app.route('/<filename>')
def serve_html(filename):
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
        return content
    except FileNotFoundError:
        return f"파일을 찾을 수 없습니다: {filename}", 404

if __name__ == '__main__':
    print("🚀 Flask 서버를 시작합니다...")
    print("🌐 HTML 파일을 보려면 브라우저에서 http://localhost:5000 을 방문하세요")
    
    if not GOOGLE_API_KEY:
        print("⚠️  Gemini API 키가 설정되지 않았습니다.")
        print("🎭 역할극 시연을 위해 모의 응답을 사용합니다.")
        print("🔑 실제 Gemini API를 사용하려면 .env 파일에 GOOGLE_API_KEY를 설정하세요")
    else:
        print("✅ Gemini API가 설정되었습니다.")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
