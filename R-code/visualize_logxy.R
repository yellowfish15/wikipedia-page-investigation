# Load required libraries
library(ggplot2)

# Read the data from the CSV file
setwd("C:/Users/conta/Downloads/Intro to Statistics/wikipedia-page-investigation/")
data <- read.csv("raw_data.csv")

# Replace 0 values with a small value (e.g., 1) to avoid issues with log(0)
data$back_links_count[data$back_links_count == 0] <- 1
data$page_views[data$page_views == 0] <- 1

# Fit a linear model to the log-transformed data
model <- lm(log(page_views) ~ log(back_links_count), data = data)

# Create the scatter plot of log(back_links_count) vs page_views
ggplot(data, aes(x = log(back_links_count), y = log(page_views))) +
  geom_point(color = "blue", alpha = 0.6) +  # Scatter plot with blue points
  geom_smooth(method = "lm", formula = y ~ x, color = "red", se = FALSE) +  # Linear regression line
  labs(title = "Scatter Plot Log(X) vs Page Views",
       x = "Log(X)",
       y = "Page Views") +  # Update y-axis label to reflect the log transformation
  theme_minimal() +  # Use a clean theme
  theme(
    plot.title = element_text(hjust = 0.5),  # Center the title
    axis.title = element_text(size = 12),    # Adjust axis title size
    axis.text = element_text(size = 10)      # Adjust axis text size
  ) +
  # Add the regression equation and R-squared value to the plot
  annotate("text", x = max(log(data$back_links_count))*0.7, y = max(log(data$page_views))*0.7, 
           label = paste("y =", round(coef(model)[1], 2), "+", 
                         round(coef(model)[2], 2), "* x\nR^2 =", 
                         round(summary(model)$r.squared, 6)), 
           color = "red", size = 5, hjust = 0)