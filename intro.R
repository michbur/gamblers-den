library(dplyr)
library(ggplot2)

test_accuracy <- 0.99
disease_rarity <- 20000/38e6
population_size <- 38e6

# true positive
TP <- disease_rarity * population_size * test_accuracy

# false positive
FP <- (1 - disease_rarity) * population_size * (1 - test_accuracy)

FP/TP

dat <- data.frame(infection = c(TRUE, TRUE, FALSE, FALSE),
                  diagnosis = c(TRUE, FALSE, TRUE, FALSE),
                  value = c(disease_rarity * population_size * test_accuracy,
                            disease_rarity * population_size * (1 - test_accuracy),
                            (1 - disease_rarity) * population_size * (1 - test_accuracy),
                            (1 - disease_rarity) * population_size * test_accuracy))




  ggplot(dat, aes(y = log(value), x = status, label = round(value, 0))) +
  geom_col() +
  geom_text(vjust = "inward", color = "red") +
  theme_bw()
