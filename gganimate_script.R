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

world <- ggplot() + borders("world", colour = "black", fill = "gray80") + theme_map()

world_map <- map_data("world") %>% 
             left_join(average_wages, by = "region")

map <- world + geom_polygon(data = world_map, 
                            aes(x = long, y = lat, group = group, fill = gender_wage), 
                            alpha = 0.5) + 
       scale_fill_gradient(name="gender wage", low = "whitesmoke", high = "red") # darkred       
# http://www.rpubs.com/knm6/mapsI

map

