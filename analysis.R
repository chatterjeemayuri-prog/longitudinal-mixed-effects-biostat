#############################################
# Longitudinal Data Analysis using Mixed Effects Models
# Author: Mayuri Chatterjee
# Objective: Model repeated measurements and compare
# naive regression vs mixed-effects model
#############################################

# -------------------------------
# 1. Load required library
# -------------------------------
library(nlme)   # for mixed effects models

# -------------------------------
# 2. Load dataset
# -------------------------------
data(Orthodont)

# View dataset
head(Orthodont)
str(Orthodont)
summary(Orthodont)

# -------------------------------
# 3. Understand data
# -------------------------------
# distance = response variable (measurement)
# age = time variable
# Subject = individual ID (repeated measures)
# Sex = grouping variable

# -------------------------------
# 4. Naive linear regression (WRONG approach)
# -------------------------------

lm_model <- lm(distance ~ age + Sex, data = Orthodont)

summary(lm_model)

# -------------------------------
# 5. Mixed Effects Model (CORRECT approach)
# -------------------------------

# Random intercept model
lme_model <- lme(distance ~ age + Sex,
                 random = ~1 | Subject,
                 data = Orthodont)

summary(lme_model)

# -------------------------------
# 6. Compare models
# -------------------------------

cat("\n--- Model Comparison ---\n")
cat("Naive LM AIC:", AIC(lm_model), "\n")
cat("Mixed Model AIC:", AIC(lme_model), "\n")

# -------------------------------
# 7. Add random slope model (stronger model)
# -------------------------------

lme_model2 <- lme(distance ~ age + Sex,
                  random = ~ age | Subject,
                  data = Orthodont)

summary(lme_model2)

cat("\nRandom Intercept vs Random Slope AIC:\n")
cat("Random Intercept:", AIC(lme_model), "\n")
cat("Random Slope:", AIC(lme_model2), "\n")

# -------------------------------
# 8. Visualization
# -------------------------------

library(ggplot2)

longitudinal_plot <- ggplot(
  Orthodont,
  aes(
    x = age,
    y = distance,
    group = Subject,
    color = Sex
  )
) +
  
  geom_line(alpha = 0.6) +
  
  geom_point(size = 2) +
  
  labs(
    title = "Longitudinal Dental Measurements by Subject",
    x = "Age",
    y = "Distance"
  ) +
  
  theme_minimal()

print(longitudinal_plot)

# -------------------------------
# 9. Save longitudinal plot
# -------------------------------

ggsave(
  filename = "longitudinal_plot.png",
  plot = longitudinal_plot,
  path = getwd(),
  width = 7,
  height = 5,
  dpi = 300
)

list.files()

#############################################
# END
#############################################