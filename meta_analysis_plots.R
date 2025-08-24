# ===================================================================
    # 온라인 심리 중재 효과 메타분석 시각화 통합 스크립트
    # -------------------------------------------------------------------
    # 실행 안내:
    # 1. 이 스크립트를 실행하기 전에 'meta' 패키지가 설치되어 있는지 확인하세요.
    #    설치 명령어: install.packages("meta")
    # 2. 스크립트를 실행하면 작업 디렉토리에 'plots' 폴더가 생성되고,
    #    모든 숲 그림(forest plot) 이미지 파일이 해당 폴더 안에 저장됩니다.
    # ===================================================================

    # 필요 패키지 로드
    library(meta)

    # 결과물(플롯)을 저장할 폴더 생성 (폴더가 이미 있어도 오류 없음)
    dir.create("plots", showWarnings = FALSE)


    # -------------------------------------------------------------------
    # 1. Zhong et al. (2024): AI 챗봇의 효과
    # -------------------------------------------------------------------

    # 1.1 우울증에 대한 효과 (Figure 3A)
    depression_data_zhong <- data.frame(
        studlab = c("Burton C (2016)", "Fitzpatrick, K. K (2017)", "Greer, S (2019)",
                    "Oh, J. (2020)", "Matsumoto, A (2021)", "Jang, S (2021)",
                    "Hunt, M. (2021)", "Liu, H (2022)", "He, Y. H. (2022)",
                    "Danieli, M. (2022)", "Sabour, S. et al (2023)", "Kleinau, E. F (2023)",
                    "Karkosz (2024)", "Ulrich, S (2024)", "Vereschagin (2024)"),
        g = c(-0.18, -0.66, -0.07, -0.21, -0.30, -0.03, -0.39, -0.62,
              -0.40, -0.14, -0.43, -0.22, 0.08, -0.45, -0.15),
        ci_lower = c(-1.08, -1.20, -0.66, -0.82, -0.91, -0.61, -0.83, -1.06,
                     -0.78, -1.07, -0.69, -0.40, -0.35, -0.75, -0.25),
        ci_upper = c(0.68, -1.20, 0.52, 0.40, 0.30, 0.55, 0.05, -0.18,
                     -0.01, 0.79, -0.18, -0.04, 0.52, -0.16, -0.05)
    )
    depression_data_zhong$se <- (depression_data_zhong$ci_upper - depression_data_zhong$ci_lower) / (2 * 1.96)
    meta_depression_zhong <- metagen(TE = g, seTE = se, studlab = studlab, data = depression_data_zhong, sm = "SMD", random = TRUE)

    png("plots/forest_plot_zhong_depression.png", width = 1200, height = 900, res = 150)
    forest(meta_depression_zhong,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "Hedges' g", "95% CI"),
           xlab = "Effect Size (Hedges' g)",
           smlab = "AI Chatbots for Depression",
           col.square = "navy", col.diamond = "maroon")
    dev.off()
    print("Saved plot to: plots/forest_plot_zhong_depression.png")


    # 1.2 불안에 대한 효과 (Figure 3C)
    anxiety_data_zhong <- data.frame(
        studlab = c("Sabour, S. et al (2023)", "Kleinau, E. F (2023)", "Liu, H (2022)",
                    "Danieli, M. (2022)", "Prochaska, J.J (2021)", "Matsumoto, A (2021)",
                    "Klos, M. C (2021)", "Jang, S (2021)", "Hunt, M. (2021)",
                    "Oh, J. (2020)", "Greer, S (2019)", "Fitzpatrick, K. K. (2017)",
                    "Karkosz, S (2024)", "Ulrich, S (2024)", "Vereschagin, M (2024)"),
        g = c(-0.17, -0.12, 0.11, -1.05, -0.13, -0.37, -0.56, 0.12, -0.38,
              -0.02, -0.46, 0.32, 0.09, -0.41, -0.22),
        ci_lower = c(-0.42, -0.30, -0.32, -2.06, -0.46, -0.98, -1.03, -0.46, -0.82,
                     -0.63, -1.06, -0.21, -0.34, -0.70, -0.32),
        ci_upper = c(0.08, 0.05, 0.54, -0.04, 0.19, 0.23, -0.09, 0.70, 0.07,
                     0.59, 0.14, 0.85, 0.53, -0.12, -0.12)
    )
    anxiety_data_zhong$se <- (anxiety_data_zhong$ci_upper - anxiety_data_zhong$ci_lower) / (2 * 1.96)
    meta_anxiety_zhong <- metagen(TE = g, seTE = se, studlab = studlab, data = anxiety_data_zhong, sm = "SMD", random = TRUE)

    png("plots/forest_plot_zhong_anxiety.png", width = 1200, height = 900, res = 150)
    forest(meta_anxiety_zhong,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "Hedges' g", "95% CI"),
           xlab = "Effect Size (Hedges' g)",
           smlab = "AI Chatbots for Anxiety",
           col.square = "darkgreen", col.diamond = "orange")
    dev.off()
    print("Saved plot to: plots/forest_plot_zhong_anxiety.png")


    # -------------------------------------------------------------------
    # 2. Lim et al. (2022): 챗봇 심리치료 효과
    # -------------------------------------------------------------------
    lim_data <- data.frame(
        studlab = c("Berger et al (2011)", "Berger et al (2017)", "Burton et al (2016)",
                    "Cartreine et al (2012)", "Fitzpatrick et al (2017)", "Meyer et al (2009)",
                    "Meyer et al (2015)", "Moritz et al (2012)", "Sandoval et al (2016)",
                    "Schroder et al (2014)", "Zwerenz et al (2017)"),
        g = c(-0.65, -0.56, -0.47, -1.24, -0.62, -0.64, -0.57, -0.43, -0.98, -0.22, -0.44),
        z_value = c(-2.31, -3.05, -1.09, -2.25, -2.30, -4.06, -3.22, -2.78, -3.14, -0.82, -3.20)
    )
    lim_data$se <- abs(lim_data$g / lim_data$z_value)
    meta_lim <- metagen(TE = g, seTE = se, studlab = studlab, data = lim_data, sm = "SMD", random = TRUE)

    png("plots/forest_plot_lim_depression.png", width = 1200, height = 800, res = 150)
    forest(meta_lim,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "Hedges' g", "95% CI"),
           xlab = "Effect Size (Hedges' g)",
           smlab = "Chatbot Psychotherapy vs. Control",
           col.square = "purple", col.diamond = "darkorange")
    dev.off()
    print("Saved plot to: plots/forest_plot_lim_depression.png")


    # -------------------------------------------------------------------
    # 3. Saddichha et al. (2014): 치료사 개입 없는 온라인 중재
    # -------------------------------------------------------------------
    saddichha_no_therapist_data <- data.frame(
        studlab = c("De Graaf et al. (2009)", "Andersson et al. (2005)", "Bolier et al. (2013)",
                    "Clarke et al. (2009)", "O'Kearney et al. (2006)", "Lintvedt et al. (2011)",
                    "Meyer et al. (2009)", "Christensen et al. (2004)", "Ünlü Ince et al. (2013)"),
        d = c(0.04, 0.94, 0.36, 0.00, 0.15, 0.57, 0.36, 0.40, 0.37),
        se = c(0.15, 0.24, 0.18, 0.15, 0.20, 0.21, 0.16, 0.14, 0.21) # SE는 시각화를 위해 가정된 값
    )
    meta_saddichha_no_therapist <- metagen(TE = d, seTE = se, studlab = studlab, data = saddichha_no_therapist_data, sm = "SMD", random = TRUE)

    png("plots/forest_plot_saddichha_no_therapist.png", width = 1200, height = 750, res = 150)
    forest(
        meta_saddichha_no_therapist,
        leftcols = c("studlab", "effect", "ci"),
        leftlabs = c("연구 (연도)", "효과 크기 (d)", "95% CI"),
        xlab = "효과 크기 (Cohen's d)",
        smlab = "우울증에 대한 온라인 중재 (치료사 개입 없음)",
        col.square = "#E69F00",
        col.diamond = "#56B4E9"
    )
    dev.off()
    print("Saved plot to: plots/forest_plot_saddichha_no_therapist.png")


    # -------------------------------------------------------------------
    # 4. Davies et al. (2014): 웹 기반 중재 효과
    # -------------------------------------------------------------------

    # 4.1 불안에 대한 효과
    davies_anxiety_data <- data.frame(
        studlab = c("Kenardy 2003", "Arpin-Cribbie 2012", "Radhu 2012",
                    "Day 2013", "Ellis 2011", "Sethi 2010", "Botella 2010"),
        smd = c(-0.30, -0.53, -0.43, -0.66, -0.96, -1.26, -0.56),
        ci_lower = c(-0.76, -1.10, -1.02, -1.15, -1.78, -2.27, -1.01),
        ci_upper = c(0.16, 0.03, 0.15, -0.16, -0.14, -0.25, -0.11)
    )
    davies_anxiety_data$se <- (davies_anxiety_data$ci_upper - davies_anxiety_data$ci_lower) / (2 * 1.96)
    meta_davies_anxiety <- metagen(TE = smd, seTE = se, studlab = studlab, data = davies_anxiety_data, sm = "SMD", random = TRUE)

    png("plots/forest_plot_davies_anxiety.png", width = 1200, height = 700, res = 150)
    forest(meta_davies_anxiety,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "SMD", "95% CI"),
           xlab = "Standardized Mean Difference (SMD)",
           smlab = "Intervention vs. Inactive Control for Anxiety",
           col.square = "#0072B2", col.diamond = "#D55E00")
    dev.off()
    print("Saved plot to: plots/forest_plot_davies_anxiety.png")


    # 4.2 우울증에 대한 효과
    davies_depression_data <- data.frame(
        studlab = c("Botella 2010", "Taitz 2011", "Arpin-Cribbie 2012", "Kenardy 2003",
                    "Lintvedt 2011", "Radhu 2012", "Day 2013", "Ellis 2011", "Sethi 2010"),
        smd = c(-0.43, -0.06, -0.84, -0.89, -0.31, -0.52, -0.55, -0.44, 0.06),
        ci_lower = c(-0.87, -0.35, -1.42, -1.37, -0.62, -1.10, -1.05, -1.22, -0.84),
        ci_upper = c(0.02, 0.24, -0.26, -0.41, 0.00, 0.06, -0.06, 0.34, 0.96)
    )
    davies_depression_data$se <- (davies_depression_data$ci_upper - davies_depression_data$ci_lower) / (2 * 1.96)
    meta_davies_depression <- metagen(TE = smd, seTE = se, studlab = studlab, data = davies_depression_data, sm = "SMD", random = TRUE)

    png("plots/forest_plot_davies_depression.png", width = 1200, height = 750, res = 150)
    forest(meta_davies_depression,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "SMD", "95% CI"),
           xlab = "Standardized Mean Difference (SMD)",
           smlab = "Intervention vs. Inactive Control for Depression",
           col.square = "#009E73", col.diamond = "#CC79A7")
    dev.off()
    print("Saved plot to: plots/forest_plot_davies_depression.png")


    # -------------------------------------------------------------------
    # 5. Ye et al. (2014): 아동/청소년 대상 인터넷 중재 효과
    # -------------------------------------------------------------------

    # 5.1 불안에 대한 효과
    ye_anxiety_data <- data.frame(
        studlab = c("Keller 2010", "March 2009", "Reid 2011",
                    "Sethi 2010", "Spence 2011", "Storch 2011"),
        smd = c(-0.93, -0.55, -0.06, -1.26, -0.82, 0.18),
        ci_lower = c(-1.62, -1.02, -0.50, -2.27, -1.25, -0.53),
        ci_upper = c(-0.23, -0.08, 0.37, -0.25, -0.38, 0.88)
    )
    ye_anxiety_data$se <- (ye_anxiety_data$ci_upper - ye_anxiety_data$ci_lower) / (2 * 1.96)
    meta_ye_anxiety <- metagen(TE = smd, seTE = se, studlab = studlab, data = ye_anxiety_data, sm = "SMD", random = TRUE)

    png("plots/forest_plot_ye_anxiety.png", width = 1200, height = 650, res = 150)
    forest(meta_ye_anxiety,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "SMD", "95% CI"),
           xlab = "Standardized Mean Difference",
           smlab = "Internet-based vs. Waitlist Control for Anxiety in Youth",
           col.square = "firebrick", col.diamond = "dodgerblue")
    dev.off()
    print("Saved plot to: plots/forest_plot_ye_anxiety.png")


    # 5.2 우울증에 대한 효과
    ye_depression_data <- data.frame(
        studlab = c("Keller 2010", "March 2009", "O'Kearney 2009", "Reid 2011",
                    "Sethi 2010", "Spence 2011", "Storch 2011"),
        smd = c(-1.30, -0.08, -0.18, 0.09, 0.06, -0.18, 0.29),
        ci_lower = c(-2.03, -0.54, -0.50, -0.34, -0.84, -0.60, -0.42),
        ci_upper = c(-0.57, 0.38, 0.14, 0.52, 0.96, 0.24, 1.00)
    )
    ye_depression_data$se <- (ye_depression_data$ci_upper - ye_depression_data$ci_lower) / (2 * 1.96)
    meta_ye_depression <- metagen(TE = smd, seTE = se, studlab = studlab, data = ye_depression_data, sm = "SMD", random = TRUE)

    png("plots/forest_plot_ye_depression.png", width = 1200, height = 700, res = 150)
    forest(meta_ye_depression,
           leftcols = c("studlab", "effect", "ci"),
           leftlabs = c("Study", "SMD", "95% CI"),
           xlab = "Standardized Mean Difference",
           smlab = "Internet-based vs. Waitlist Control for Depression in Youth",
           col.square = "darkviolet", col.diamond = "springgreen")
    dev.off()
    print("Saved plot to: plots/forest_plot_ye_depression.png")

    print("--- 모든 플롯 생성이 완료되었습니다. ---")
    
