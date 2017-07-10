library(ggplot2)
library(grid)
library(gridExtra)

size_mod <- 1

my_theme <- theme(
  axis.text = element_text(size=13 + size_mod),
  axis.title.x = element_text(size=14 + size_mod, vjust = -1),
  axis.title.y = element_text(size=14 + size_mod, vjust = 1),
  
  legend.background = element_rect(fill = "NA"),
  legend.key = element_rect(fill = "NA", color = "NA", size = 0.5),
  legend.position = "bottom",
  legend.key.size = unit(0.1, "inches"),
  legend.margin = unit(2.5, "lines"),
  legend.text = element_text(size=13 + size_mod), 
  legend.title = element_text(size=14 + size_mod),
  
  #panel.grid.major = element_line(color="grey", linetype = "dashed", size = 0.5),
  panel.grid.major = element_line(color="lightgrey", 
                                  linetype = "dashed", size = 0.5),
  panel.background = element_rect(fill = "transparent", color = "black"),
  
  plot.background=element_rect(fill = "transparent",
                               color = "transparent"),
  plot.margin = unit(rep(0.18, 4), "inches"),
  plot.title = element_text(size=20 + size_mod),
  
  strip.background = element_rect(fill = "NA", color = "NA"),
  strip.text = element_text(size=13 + size_mod, face = "bold")
)


get_legend<-function(my_ggplot) { 
  ggtable <- ggplot_gtable(ggplot_build(my_ggplot)) 
  ggtable[["grobs"]][[which(sapply(ggtable[["grobs"]], function(i) i[["name"]]) == "guide-box")]]
}