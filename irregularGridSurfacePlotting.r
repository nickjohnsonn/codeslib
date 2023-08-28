# Import your dataset (if possible at CSV format with headers)
# Install and load library "ggplot2"
install.packages("ggplot2")
library(ggplot2)

# If the name of your dataset is not df, which is normally the case. Duplicate your dataset to a new dataset "df"
df = <Name of your dataset>

# Let's assume "df" is your data set that contains elevation at certain coordinates
# Store your column values in separate variables
long = df$x
lat = df$y
elevation = df$z

# Install and load library "akima" and "reshape2" for data interpolation
install.packages("akima")
install.packages("reshape2")
library(akima)
library(reshape2)

# Interpolate your dataset 
interp_df = with(df,interp(x = long, y = lat, z = elevation))

# Note that "interp_df" has column headers x,y,z from the above command.
final_df = melt(interp_df$z,na.rm = TRUE)

# Change the header names
# Note that the first two columns are not the original dataset, it is because of the melt() function that interpolated the elevation.
names(final_df) <- c("x", "y", "elevation")

# Add the columns to the data set through matrix manipulation
final_df$long <- interp_df$x[final_df$x]
final_df$lat <- interp_df$y[final_df$y]

# Plotting using geo_tile and stat_contour
# In this plot, I will use the latitude and longitude at x and y-axes, respectively
# Store the 2D map in a variable named mapPlot2D
mapPlot2D = ggplot(data = final_df, aes(x = lat, y = long, z = elevation)) + geom_tile(aes(fill=elevation)) + stat_contour(color="white")

# We stored the command above in a variable to easily navigate through the aesthetics of the graph such as titles, labels, legends, etc.
# We will add all other necessary details
mapPlot2D + ggtitle("Title Here") + xlab("Lattitude") + ylab("Longitude") + scale_fill_continuous(name = "Elevation (m)", low = "black", high = "blue") + coord_fixed()

# You can reverse the plot by adding trans = "reverse" treating the elevation as depth
# Store it to another variable named final_mapPlot2D
final_mapPlot2D = mapPlot2D + ggtitle("Title Here") + xlab("Lattitude") + ylab("Longitude") + scale_fill_continuous(name = "Elevation (m)", low = "black", high = "blue", trans = "reverse") + coord_fixed()

# To plot in 3D we will install and load a package called "rayshader", "viridis" and "tidyr"
install.packages("rayshader")
install.packages("tidyr")
install.packages("viridis")
library(rayshader)
library(tidyr)
require(viridisLite)
library(viridis)

# Improving the aesthetics by removing the white contour line
mapPlot2D = ggplot(data = final_df, aes(x = lat, y = long, z = elevation)) + geom_tile(aes(fill=elevation))

# Updating the variable value and changing the color palette
final_mapPlot2D = mapPlot2D + xlab("Latitude") + ylab("Longitude") + scale_fill_continuous(name = "Elevation (m)", low = "blue", high = "gray", trans = "reverse") + coord_fixed() + theme(plot.title = element_text(size = 25, face = "bold"), legend.title = element_text(size = 10), axis.text = element_text(size = 10), axis.title.x = element_text(size = 10, vjust = -0.5), axis.text.x = element_text(angle = 90), axis.title.y = element_text(size = 10, vjust = 0.2), legend.text = element_text(size = 10)) + scale_y_continuous(breaks = seq(18.37, 18.40, len = 30)) + scale_x_continuous(breaks = seq(122.11, 122.1230, len = 13))

# Plotting in 3D raytrace
plot_gg(final_mapPlot2D, multicore = TRUE, raytrace = TRUE, width = 7, height = 4, scale = 300, windowsize = c(1400, 866), zoom = 0.6, phi = 30, theta = 30)

# We could use a different ggplot mapping tool with interpolation and then update "final_mapPlot2D" and re-plot in 3D
mapPlot2D = ggplot(data = final_df, aes(x = lat, y = long, z = elevation)) + geom_raster(aes(fill=elevation),interpolate=TRUE)
