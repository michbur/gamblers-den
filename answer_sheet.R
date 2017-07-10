ans <- expand.grid(test_accuracy = c(0.900, 0.950, 0.990, 0.999),
                   disease_rarity = seq(2e4, 3e5, 2e4),
                   population_size = seq(2e6, 120e6, 2e6)) %>% 
  mutate(should_worry = apply(., 1, function(i) {
    # true positive
    disease_rarity <- i["disease_rarity"]/i["population_size"]
    TP <- disease_rarity * i["population_size"] * i["test_accuracy"]
    
    # false positive
    FP <- (1 - disease_rarity) * i["population_size"] * (1 - i["test_accuracy"])
    
    FP/TP
  }),
  should_worry_bin = should_worry < 1)

ggplot(ans, aes(x = factor(population_size), 
                y = factor(disease_rarity), 
                fill = should_worry_bin)) +
  geom_tile(color = "black") +
  facet_wrap(~ test_accuracy) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90))

filter(ans, test_accuracy == 0.99, disease_rarity == 20000, population_size == 38e6)
