#'---
#' author: Gabriel Cabrera G.
#' title: gganimate
#' subtitle: Los mapas tambien cuentan historias 
#' date: "08/09/2018 `r Sys.Date()`"
#'---

# instalar gganimate
# devtools::install_github("dgrtwo/gganimate", ref = "v0.1.1")

# cargamos librerias
if(!require("pacman")) install.packages("pacman")
p_load("tidyverse", "gganimate", "maps", "ggthemes", "leaflet", "DT", "lubridate", "magick")

# cargamos data 
average_wages <- read_delim("dataset/gender-gap-in-average-wages-ilo.csv", delim = ",") %>% 
                 rename(region = Entity, gender_wage = `Gender wage gap (%) (%)`)

# muestra la base en html 
datatable(average_wages, rownames = FALSE,
          options = list(pageLength = 5))

# Usando maps  ------------------------------------------------------------

world <- ggplot() + borders("world", colour = "black", fill = "gray80") + theme_map()

world_map <- map_data("world") %>% 
             left_join(average_wages, by = "region")

map <- world + geom_polygon(data = world_map, 
                            aes(x = long, y = lat, group = group, fill = gender_wage), 
                            alpha = 0.5) + 
       scale_fill_gradient(name="gender wage", low = "whitesmoke", high = "red") # darkred       
# http://www.rpubs.com/knm6/mapsI

map

# gganimate ---------------------------------------------------------------

world_map_animate <- world_map %>% 
                     select(long, lat, group, Year, gender_wage, region) %>% 
                     na.omit() %>% 
                     arrange(Year)

init <- tibble(
  Year = 1981,
  gender_wage = 0, long = 0, lat = 0
)

fin <- tibble(
  Year = 2016,
  gender_wage = 0, long = 0, lat = 0
)

map_animate <- world + 
               geom_polygon(data = world_map_animate, 
                            aes(x = long, y = lat, group = group, fill = gender_wage,
                                frame = Year,
                                cumulative = TRUE), 
                            alpha = 0.5) + 
               geom_polygon(data = init, 
                            aes(x = long, y = lat, fill = gender_wage,
                                frame = Year,
                                cumulative = TRUE), 
                            alpha = 0) +
               geom_polygon(data = fin, 
                            aes(x = long, y = lat, fill = gender_wage,
                                frame = Year,
                                cumulative = TRUE), 
                            alpha = 0)


gganimate(map_animate, interval = 0.2, ani.width = 1500, ani.height = 750, "average_wage.gif")


# Usando leaflet ----------------------------------------------------------


