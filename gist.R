# PACKAGES NEEDED ####

list.of.packages <- c('WDI', 'ggthemes', 'knitr', 'kableExtra', 'rnaturalearth', 
                      'tidyverse', 'ggrepel', 'gganimate', 'transformr')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, library, character.only = T, quietly = T)

# Life expectancy at birth, female (years) ####

indicator <- c("Life expectancy at birth, female (years)" = 'SP.DYN.LE00.FE.IN')

Data_info <- WDI_data

datWM6 <- WDI(indicator, country="all",start = '1960', end = '2018')

name_life <- as.data.frame(Data_info$series) %>%
  filter(indicator == "SP.DYN.LE00.FE.IN") %>%
  select(name)

source_life <- as.data.frame(Data_info$series) %>%
  filter(indicator == "SP.DYN.LE00.FE.IN") %>%
  select(sourceOrganization)

ne_countries(returnclass = "sf") %>%
  left_join(datWM6, c("iso_a2" = "iso2c")) %>%
  filter(iso_a2 != "ATA") %>% # remove Antarctica
  ggplot() +
  geom_sf(aes(fill = `Life expectancy at birth, female (years)`)) +
  scale_fill_viridis_c(labels = scales::number_format(scale = 1)) +
  theme(legend.position="bottom") +
  labs(
    title = paste0(name_life, " in {closest_state}"),
    fill = NULL,
    caption = paste("Source:", source_life)
  ) +
  transition_states(year) -> test_gif

#animate(test_gif, height = 4, width = 6, units = "in", res = 150)

magick::image_write(
  animate(test_gif, width = 1000, height = 1000), 
  "test.gif"
)
