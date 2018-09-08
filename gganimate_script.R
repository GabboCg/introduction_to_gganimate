#'---
#' author: Gabriel Cabrera G.
#' title: gganimate
#' subtitle: Los mapas tambien cuentan historias 
#' date: "08/09/2018 `r Sys.Date()`"
#'---

# cargamos librerias
if(!require("pacman")) install.packages("pacman")
p_load("tidyverse", "gganimate", "maps", "ggthemes")

# cargamos data 
average_wages <- read_delim("dataset/gender-gap-in-average-wages-ilo.csv", delim = ",") %>% 
                 rename(region = Entity, gender_wage = `Gender wage gap (%) (%)`)

world <- ggplot() + borders("world", colour = "gray85", fill = "gray80") + theme_map()

long_lat <- map_data("world")

world_map <- left_join(average_wages, long_lat, by = "region")

map <- world + geom_point( data = world_map, aes(x = long, y = lat, size = gender_wage), colour = 'purple', alpha = .3) +
               scale_size_continuous(range = c(1, 5), breaks = c(-35, 0, 10, 20, 35)) + labs(size = 'Gender Wage')
map

