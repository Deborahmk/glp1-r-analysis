# 📊 GLP-1 Treatment Data Analysis & Visualization in R

**Author:** Deborah Musuamba  
**GitHub:** [github.com/Deborahmk](https://github.com/Deborahmk)  
**Language:** R  
**Packages:** tidyverse, ggplot2, dplyr, scales, lubridate

---

## 📌 Overview

Statistical analysis and data visualization of GLP-1 medication treatment outcomes using R. This project is the analytical companion to the [GLP-1 SQL Database](https://github.com/Deborahmk/glp1-treatment-database), demonstrating end-to-end healthcare data analysis skills.

---

## 📈 Visualizations Generated

| Plot | Description |
|------|-------------|
| `plot1_weight_loss_by_medication.png` | Weight lost per patient by GLP-1 medication |
| `plot2_bmi_before_after.png` | BMI comparison before vs after treatment |
| `plot3_hba1c_improvement.png` | HbA1c reduction in diabetic patients |
| `plot4_insurance_claims.png` | Insurance billed vs paid by claim status |
| `plot5_monthly_weight_loss.png` | Monthly weight loss rate by patient |

---

## 🧠 R Skills Demonstrated

- Data frame creation and manipulation
- `tidyverse` pipeline (`%>%`)
- `dplyr` — mutate, filter, group_by, summarise, arrange
- `ggplot2` — bar charts, line charts, grouped bars, coord_flip
- `pivot_longer` for data reshaping
- `scale_fill_manual` for custom color palettes
- `geom_hline` for reference lines (BMI thresholds, HbA1c targets)
- `annotate` for chart annotations
- `ggsave` for exporting high-resolution plots
- Statistical summaries (mean, sum, percentage calculations)

---

## ▶️ How to Run

### Requirements
```r
install.packages(c("tidyverse", "ggplot2", "dplyr", "scales", "lubridate"))
```

### Run the analysis
```r
source("glp1_analysis.R")
```

---

## 📊 Sample Output

```
==============================================
  GLP-1 TREATMENT ANALYSIS SUMMARY
==============================================

📊 OVERALL TREATMENT OUTCOMES:
  Total patients analyzed   : 8
  Average weight lost       : 26.1 lbs
  Average % weight lost     : 9.3 %
  Average BMI reduction     : 3
  Average monthly weight loss: 6.9 lbs/month

🩸 HbA1c IMPROVEMENT (Diabetic Patients):
  Patients with diabetes    : 5
  Average HbA1c reduction   : 0.84 %
  Achieved target (<7.0)    : 1 patients

💰 INSURANCE CLAIMS ANALYSIS:
  Total billed              : $ 8,070
  Total paid                : $ 6,450
  Overall approval rate     : 79.9 %
```

---

## 🔗 Related Projects

- [GLP-1 SQL Database](https://github.com/Deborahmk/glp1-treatment-database) — The relational database this analysis is built on
- [AI Healthcare Symptom Checker](https://github.com/Deborahmk/healthcare-symptom-checker) — AI-powered healthcare tool

---

## 🔭 Future Enhancements

- [ ] Add linear regression to predict weight loss outcomes
- [ ] Build interactive visualizations with Shiny
- [ ] Connect directly to MySQL database using RMySQL
- [ ] Add survival analysis for treatment duration
- [ ] Compare GLP-1 efficacy with other diabetes medications

---

## ⚠️ Disclaimer

All patient data is **fictional and created for educational purposes only**.

---

## 📄 License

MIT License — Copyright 2026 Deborah Musuamba
