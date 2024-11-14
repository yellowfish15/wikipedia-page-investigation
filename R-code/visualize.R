# Load required libraries
library(ggplot2)

# Read the data from the CSV file
setwd("C:/Users/conta/Downloads/Intro to Statistics/wikipedia-page-investigation/")
data <- read.csv("raw_data.csv")

# Create the scatter plot of links_count vs page_views with log scale on y-axis
ggplot(data, aes(x = links_count, y = page_views)) +
  geom_point(color = "blue", alpha = 0.6) +  # Scatter plot with blue points
  labs(title = "Scatter Plot of Links Count vs Page Views",
       x = "Links Count",
       y = "Page Views (Log Scale)") +  # Update y-axis label
  scale_y_log10() +  # Apply log scale to y-axis
  theme_minimal() +  # Use a clean theme
  theme(
    plot.title = element_text(hjust = 0.5),  # Center the title
    axis.title = element_text(size = 12),    # Adjust axis title size
    axis.text = element_text(size = 10)      # Adjust axis text size
  )
