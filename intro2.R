library(dplyr)
library(ggplot2)

detriple_number <- function(x) {
  triplets_start <- nchar(x) %% 3 + 1
  nchar_x <- nchar(x)
  
  first_part <- substring(x, 1, triplets_start - 1) 
  second_part <- substring(x, seq(triplets_start, nchar_x, 3), seq(triplets_start + 2, nchar_x, 3))
  vector_to_paste <- if(triplets_start == 1) {
    second_part
  } else {
    c(first_part, second_part)
  }
  paste0(vector_to_paste, collapse = " ")
}


test_accuracy <- 0.99
disease_rarity <- 20000/38e6
population_size <- 38e6

# true positive
TP <- disease_rarity * population_size * test_accuracy

# false positive
FP <- (1 - disease_rarity) * population_size * (1 - test_accuracy)

FP/TP

dat[dat[["infection"]] == "nie" & dat[["diagnosis"]] == "tak", "value"]/
dat[dat[["infection"]] == "tak" & dat[["diagnosis"]] == "tak", "value"]

dat <- data.frame(infection = c(TRUE, TRUE, FALSE, FALSE),
                  diagnosis = c(TRUE, FALSE, TRUE, FALSE),
                  value = c(disease_rarity * population_size * test_accuracy,
                            disease_rarity * population_size * (1 - test_accuracy),
                            (1 - disease_rarity) * population_size * (1 - test_accuracy),
                            (1 - disease_rarity) * population_size * test_accuracy)) %>% 
  mutate(diagnosis = ifelse(diagnosis, "tak", "nie"),
         infection = ifelse(infection, "tak", "nie"))

ggplot(dat, aes(x = infection, y = log(value, 10), fill = diagnosis, 
                label = paste0(sapply(value, detriple_number), " badanych"))) +
  geom_col() +
  geom_text(position = position_stack(vjust=0.5)) +
  theme_bw() +
  scale_y_continuous("Liczba badanych (skala logarytmiczna)") +
  scale_x_discrete("Infekcja") +
  scale_fill_manual("Diagnoza", values = c("blue", "red"))
