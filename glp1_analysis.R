# ============================================================
# GLP-1 Treatment Data Analysis & Visualization
# Author: Deborah Musuamba
# GitHub: github.com/Deborahmk
# Description: Statistical analysis and visualization of GLP-1
#              medication treatment outcomes using R, tidyverse,
#              and ggplot2. Companion to the GLP-1 SQL database.
# ============================================================

# ─── Load Libraries ──────────────────────────────────────────
library(tidyverse)
library(ggplot2)
library(dplyr)
library(scales)
library(lubridate)

# ─── Sample Dataset ──────────────────────────────────────────
# Simulated GLP-1 patient treatment data
# In a real scenario, this would be loaded from the SQL database

patients <- data.frame(
  patient_id   = 1:8,
  name         = c("James Miller", "Maria Rodriguez", "David Johnson",
                   "Jennifer Smith", "Michael Brown", "Ashley Davis",
                   "Robert Wilson", "Sarah Taylor"),
  gender       = c("Male","Female","Male","Female","Male","Female","Male","Female"),
  age          = c(49, 42, 56, 34, 52, 39, 59, 46),
  medication   = c("Ozempic","Wegovy","Mounjaro","Wegovy","Ozempic",
                   "Zepbound","Victoza","Rybelsus"),
  indication   = c("T2D","Obesity","T2D","Obesity","T2D",
                   "Obesity","T2D","T2D"),
  start_weight = c(245, 280, 310, 262, 267, 295, 285, 240),
  end_weight   = c(218, 244, 288, 238, 248, 268, 285, 228),
  start_bmi    = c(35.1, 46.6, 42.0, 42.3, 40.6, 47.7, 38.6, 36.5),
  end_bmi      = c(31.3, 40.6, 39.0, 38.4, 37.7, 43.3, 38.6, 34.7),
  start_hba1c  = c(8.2, NA,   9.1, NA,   8.8, NA,   9.4, 8.5),
  end_hba1c    = c(6.9, NA,   7.8, NA,   7.6, NA,   8.9, 7.4),
  months       = c(6,   6,    3,   6,    3,   4,    3,   3),
  insurance    = c("BCBS","Aetna","UHC","Cigna","BCBS","Humana","Medicare","Medicaid"),
  claim_status = c("Approved","Approved","Approved","Denied","Approved",
                   "Partial","Approved","Approved"),
  amount_billed= c(935, 1350, 1100, 1350, 935, 1200, 750, 450),
  amount_paid  = c(800, 1200,  950,    0, 700,  600, 750, 450)
)

# ─── Data Cleaning & Feature Engineering ─────────────────────
patients <- patients %>%
  mutate(
    weight_lost     = start_weight - end_weight,
    pct_weight_lost = round((weight_lost / start_weight) * 100, 1),
    bmi_reduction   = round(start_bmi - end_bmi, 1),
    hba1c_reduction = round(start_hba1c - end_hba1c, 1),
    monthly_loss    = round(weight_lost / months, 1),
    diabetes_target = ifelse(!is.na(end_hba1c), 
                             ifelse(end_hba1c < 7.0, "Target Achieved", 
                                    ifelse(end_hba1c < 8.0, "Near Target", "Needs Adjustment")),
                             "N/A - Obesity Only"),
    coverage_pct    = round((amount_paid / amount_billed) * 100, 1)
  )

cat("==============================================\n")
cat("  GLP-1 TREATMENT ANALYSIS SUMMARY\n")
cat("  Author: Deborah Musuamba\n")
cat("==============================================\n\n")

# ─── Summary Statistics ───────────────────────────────────────
cat("📊 OVERALL TREATMENT OUTCOMES:\n")
cat("  Total patients analyzed   :", nrow(patients), "\n")
cat("  Average weight lost       :", round(mean(patients$weight_lost), 1), "lbs\n")
cat("  Average % weight lost     :", round(mean(patients$pct_weight_lost), 1), "%\n")
cat("  Average BMI reduction     :", round(mean(patients$bmi_reduction), 1), "\n")
cat("  Average monthly weight loss:", round(mean(patients$monthly_loss), 1), "lbs/month\n\n")

# ─── HbA1c Analysis (Diabetic Patients Only) ─────────────────
diabetic <- patients %>% filter(!is.na(hba1c_reduction))
cat("🩸 HbA1c IMPROVEMENT (Diabetic Patients):\n")
cat("  Patients with diabetes    :", nrow(diabetic), "\n")
cat("  Average HbA1c reduction   :", round(mean(diabetic$hba1c_reduction), 2), "%\n")
cat("  Achieved target (<7.0)    :", sum(diabetic$end_hba1c < 7.0, na.rm=TRUE), "patients\n\n")

# ─── Insurance Analysis ───────────────────────────────────────
cat("💰 INSURANCE CLAIMS ANALYSIS:\n")
cat("  Total billed              : $", format(sum(patients$amount_billed), big.mark=","), "\n")
cat("  Total paid                : $", format(sum(patients$amount_paid), big.mark=","), "\n")
cat("  Overall approval rate     :", round(sum(patients$amount_paid)/sum(patients$amount_billed)*100,1), "%\n\n")

# ─── Medication Performance ───────────────────────────────────
med_summary <- patients %>%
  group_by(medication) %>%
  summarise(
    patients       = n(),
    avg_weight_lost = round(mean(weight_lost), 1),
    avg_pct_lost   = round(mean(pct_weight_lost), 1),
    avg_bmi_drop   = round(mean(bmi_reduction), 1),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_weight_lost))

cat("💊 MEDICATION PERFORMANCE:\n")
print(med_summary)
cat("\n")


# ============================================================
# VISUALIZATIONS
# ============================================================

# ─── Plot 1: Weight Loss by Medication ───────────────────────
p1 <- ggplot(patients, aes(x = reorder(medication, -weight_lost),
                            y = weight_lost, fill = medication)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_text(aes(label = paste0("-", weight_lost, " lbs")),
            vjust = -0.5, size = 3.5, fontface = "bold") +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title    = "Weight Loss by GLP-1 Medication",
    subtitle = "Total pounds lost per patient by medication type",
    x        = "Medication",
    y        = "Weight Lost (lbs)",
    caption  = "Author: Deborah Musuamba | github.com/Deborahmk"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray50", size = 11),
    axis.text.x   = element_text(angle = 30, hjust = 1)
  )

ggsave("plot1_weight_loss_by_medication.png", p1, width=10, height=6, dpi=150)
cat("✅ Saved: plot1_weight_loss_by_medication.png\n")

# ─── Plot 2: BMI Before vs After Treatment ───────────────────
bmi_data <- patients %>%
  select(name, start_bmi, end_bmi) %>%
  pivot_longer(cols = c(start_bmi, end_bmi),
               names_to = "period",
               values_to = "bmi") %>%
  mutate(period = ifelse(period == "start_bmi", "Before Treatment", "After Treatment"))

p2 <- ggplot(bmi_data, aes(x = reorder(name, -bmi), y = bmi,
                             fill = period)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_hline(yintercept = 30, linetype = "dashed", color = "red", linewidth = 0.8) +
  geom_hline(yintercept = 25, linetype = "dashed", color = "orange", linewidth = 0.8) +
  annotate("text", x = 8.5, y = 30.5, label = "Obese threshold (BMI 30)",
           color = "red", size = 3, hjust = 1) +
  annotate("text", x = 8.5, y = 25.5, label = "Overweight threshold (BMI 25)",
           color = "orange", size = 3, hjust = 1) +
  scale_fill_manual(values = c("Before Treatment" = "#E74C3C",
                                "After Treatment"  = "#27AE60")) +
  labs(
    title    = "BMI Before vs After GLP-1 Treatment",
    subtitle = "Red dashed line = Obesity threshold (BMI 30)",
    x        = "Patient",
    y        = "BMI",
    fill     = "Treatment Period",
    caption  = "Author: Deborah Musuamba | github.com/Deborahmk"
  ) +
  theme_minimal() +
  theme(
    plot.title  = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 35, hjust = 1)
  )

ggsave("plot2_bmi_before_after.png", p2, width=12, height=6, dpi=150)
cat("✅ Saved: plot2_bmi_before_after.png\n")

# ─── Plot 3: HbA1c Improvement (Diabetic Patients) ───────────
hba1c_data <- diabetic %>%
  select(name, start_hba1c, end_hba1c) %>%
  pivot_longer(cols = c(start_hba1c, end_hba1c),
               names_to = "period",
               values_to = "hba1c") %>%
  mutate(period = ifelse(period == "start_hba1c", "Baseline", "After Treatment"))

p3 <- ggplot(hba1c_data, aes(x = name, y = hba1c,
                               color = period, group = name)) +
  geom_line(color = "gray70", linewidth = 1) +
  geom_point(size = 5) +
  geom_hline(yintercept = 7.0, linetype = "dashed",
             color = "green4", linewidth = 0.8) +
  annotate("text", x = 0.6, y = 7.1,
           label = "Target HbA1c < 7.0%", color = "green4", size = 3.5) +
  scale_color_manual(values = c("Baseline" = "#E74C3C",
                                 "After Treatment" = "#27AE60")) +
  labs(
    title    = "HbA1c Improvement in Diabetic Patients",
    subtitle = "Green = After treatment | Red = Baseline | Dashed = Target",
    x        = "Patient",
    y        = "HbA1c (%)",
    color    = "Period",
    caption  = "Author: Deborah Musuamba | github.com/Deborahmk"
  ) +
  theme_minimal() +
  theme(
    plot.title  = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

ggsave("plot3_hba1c_improvement.png", p3, width=10, height=6, dpi=150)
cat("✅ Saved: plot3_hba1c_improvement.png\n")

# ─── Plot 4: Insurance Claims by Status ──────────────────────
claims_summary <- patients %>%
  group_by(claim_status) %>%
  summarise(
    count         = n(),
    total_billed  = sum(amount_billed),
    total_paid    = sum(amount_paid),
    .groups = "drop"
  )

p4 <- ggplot(claims_summary, aes(x = claim_status, y = total_billed,
                                   fill = claim_status)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_bar(aes(y = total_paid), stat = "identity",
           fill = "steelblue", alpha = 0.7, show.legend = FALSE) +
  geom_text(aes(label = paste0("$", format(total_billed, big.mark=","))),
            vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = c("Approved" = "#27AE60", "Denied" = "#E74C3C",
                                "Partial"  = "#F39C12")) +
  scale_y_continuous(labels = dollar_format()) +
  labs(
    title    = "Insurance Claims: Billed vs Paid by Status",
    subtitle = "Light bar = Amount billed | Dark bar = Amount paid",
    x        = "Claim Status",
    y        = "Amount ($)",
    caption  = "Author: Deborah Musuamba | github.com/Deborahmk"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

ggsave("plot4_insurance_claims.png", p4, width=9, height=6, dpi=150)
cat("✅ Saved: plot4_insurance_claims.png\n")

# ─── Plot 5: Monthly Weight Loss Rate ────────────────────────
p5 <- ggplot(patients, aes(x = reorder(name, -monthly_loss),
                             y = monthly_loss, fill = indication)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(monthly_loss, " lbs/mo")),
            hjust = -0.1, size = 3.5) +
  scale_fill_manual(values = c("T2D" = "#3498DB", "Obesity" = "#9B59B6")) +
  coord_flip() +
  labs(
    title    = "Monthly Weight Loss Rate by Patient",
    subtitle = "Pounds lost per month during treatment period",
    x        = "Patient",
    y        = "Avg Weight Loss (lbs/month)",
    fill     = "Indication",
    caption  = "Author: Deborah Musuamba | github.com/Deborahmk"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

ggsave("plot5_monthly_weight_loss.png", p5, width=10, height=7, dpi=150)
cat("✅ Saved: plot5_monthly_weight_loss.png\n")

cat("\n==============================================\n")
cat("  ANALYSIS COMPLETE!\n")
cat("  5 visualizations saved successfully.\n")
cat("  Author: Deborah Musuamba\n")
cat("  GitHub: github.com/Deborahmk\n")
cat("==============================================\n")
