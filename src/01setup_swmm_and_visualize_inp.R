#install.packages("swmmr")
#initiate swmm
#remotes::install_github("dleutnant/swmmr")
#install.packages("stringi")
library(stringi)
library(swmmr)
library(purrr)
library(vctrs)
# to conveniently work with list objects
# set path to inp
inp_path <-setwd(swmmdir_input)

# glance model structure, the result is a list of data.frames with SWMM sections
inp <- read_inp("NPlesantCreek.inp")
# show swmm model summary
summary(inp)
# for example, inspect section subcatchments
inp$subcatchments
# to the inp, rpt and out-file, respectively.
files <- run_swmm("NPlesantCreek.inp")
# we can now read model results from the binary output:
# here, we focus on the system variable (iType = 3) from which we pull
# total rainfall (in/hr or mm/hr) and total runoff (flow units) (vIndex = c(1,4)).
results <- read_out(files$out, iType = 3, vIndex = c(1, 4))
# results is a list object containing two time series 
str(results, max.level = 2)
# basic summary
results[[1]] %>% invoke(merge, .) %>% summary
# basic plotting
results[[1]] %>% imap( ~ plot(.x, main = .y))
# use read_rpt to get is a list of data.frames with SWMM summary sections
report <- read_rpt(files$rpt)

# glance available summaries
summary(report)
#Visualisation of model structure

library(ggplot2)
# initially, we convert the objects to be plotted as sf objects:
# here: subcatchments, links, junctions, raingages
sub_sf <- subcatchments_to_sf(inp)
lin_sf <- links_to_sf(inp)
jun_sf <- junctions_to_sf(inp)
rg_sf <- raingages_to_sf(inp)

# calculate coordinates (centroid of subcatchment) for label position
lab_coord <- sub_sf %>% 
  sf::st_centroid() %>%
  sf::st_coordinates() %>% 
  tibble::as_tibble()
#> Warning in st_centroid.sf(.): st_centroid assumes attributes are constant
#> over geometries of x

# raingage label
lab_rg_coord <- rg_sf %>% 
{sf::st_coordinates(.) + 500} %>% # add offset
  tibble::as_tibble()

# add coordinates to sf tbl
sub_sf <- dplyr::bind_cols(sub_sf, lab_coord)
rg_sf <- dplyr::bind_cols(rg_sf, lab_rg_coord)

# create the plot
ggplot() + 
  # first plot the subcatchment and colour continously by Area
  geom_sf(data = sub_sf, aes(fill = Area)) + 
  # label by subcatchments by name
  geom_label(data = sub_sf, aes(X, Y, label = Name), alpha = 0.5, size = 3) +
  # add links and highlight Geom1
  geom_sf(data = lin_sf, aes(colour = Geom1), size = 2) +
  # add junctions
  geom_sf(data = jun_sf, aes(size = Elevation), colour = "darkgrey") + 
  # finally show location of raingage
  geom_sf(data = rg_sf, shape = 10) + 
  # label raingage
  geom_label(data = rg_sf, aes(X, Y, label = Name), alpha = 0.5, size = 3) +
  # change scales
  scale_fill_viridis_c() +
  scale_colour_viridis_c(direction = -1) +
  # change theme
  theme_linedraw() +
  theme(panel.grid.major = element_line(colour = "white")) +
  # add labels
  labs(title = "Pleasant SWMM model", 
       subtitle = "customized visualization")