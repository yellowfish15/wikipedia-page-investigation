# Data Input

data <- read.csv("C:\\Users\\ADA\\utcs\\wikipedia-page-investigation\\raw_data_backlinks.csv")

# ======== #
# Raw Data #
# ======== #

# Binary classification based on back links
data$group <- ifelse(data$back_links_count >= 100, ">= 100", "< 100")

over_100 <- data[data$group == ">= 100", ]
under_100 <- data[data$group == "< 100", ]

# Compute summary statistics for page views for each group
summary_stats_over <- c(
  mean = mean(over_100$page_views, na.rm = TRUE),
  median = median(over_100$page_views, na.rm = TRUE),
  min = min(over_100$page_views, na.rm = TRUE),
  max = max(over_100$page_views, na.rm = TRUE),
  sd = sd(over_100$page_views, na.rm = TRUE),
  count = nrow(over_100)
)

summary_stats_under <- c(
  mean = mean(under_100$page_views, na.rm = TRUE),
  median = median(under_100$page_views, na.rm = TRUE),
  min = min(under_100$page_views, na.rm = TRUE),
  max = max(under_100$page_views, na.rm = TRUE),
  sd = sd(under_100$page_views, na.rm = TRUE),
  count = nrow(under_100)
)

cat("Summary Statistics for '>= 100' Backlinks:\n")
print(summary_stats_over)

cat("\nSummary Statistics for '< 100' Backlinks:\n")
print(summary_stats_under)

# Mean by group
mean_over_100 <- mean(over_100$page_views, na.rm = TRUE)
mean_under_100 <- mean(under_100$page_views, na.rm = TRUE)

# Raw point estimate
point_estimate <- mean_over_100 - mean_under_100
cat("\nPoint Estimate (Difference in Means of Page Views):", point_estimate, "\n")

# Boxplot Raw
boxplot(page_views ~ group, data = data, 
        main = "Page Views by Backlink Group",
        xlab = "Backlink Group",
        ylab = "Page Views",
        col = c("lightblue", "lightgreen"),
        border = "black")

# Plot the means
barplot(
  height = c(mean_under_100, mean_over_100), 
  names.arg = c("< 100", ">= 100"),
  col = c("lightblue", "lightgreen"),
  main = "Mean Page Views by Backlink Group",
  xlab = "Backlink Group",
  ylab = "Mean Page Views",
  ylim = c(0, max(mean_over_100, mean_under_100) * 1.2)
)

# ======== #
# Log Data #
# ======== #

# Add a log-transformed column for page views
data$log_page_views <- log(data$page_views + 1)

# Recompute over and under with log 
over_100 <- data[data$group == ">= 100", ]
under_100 <- data[data$group == "< 100", ]

# Compute summary statistics for page views for each group log
summary_stats_over <- c(
  mean = mean(over_100$log_page_views, na.rm = TRUE),
  median = median(over_100$log_page_views, na.rm = TRUE),
  min = min(over_100$log_page_views, na.rm = TRUE),
  max = max(over_100$log_page_views, na.rm = TRUE),
  sd = sd(over_100$log_page_views, na.rm = TRUE),
  count = nrow(over_100)
)

summary_stats_under <- c(
  mean = mean(under_100$log_page_views, na.rm = TRUE),
  median = median(under_100$log_page_views, na.rm = TRUE),
  min = min(under_100$log_page_views, na.rm = TRUE),
  max = max(under_100$log_page_views, na.rm = TRUE),
  sd = sd(under_100$log_page_views, na.rm = TRUE),
  count = nrow(under_100)
)

cat("Summary Statistics for '>= 100' Backlinks:\n")
print(summary_stats_over)

cat("\nSummary Statistics for '< 100' Backlinks:\n")
print(summary_stats_under)

# Compute means for each group
mean_over_100_log <- mean(over_100$log_page_views, na.rm = TRUE)
mean_under_100_log <- mean(under_100$log_page_views, na.rm = TRUE)

# Raw point estimate
point_estimate_log <- mean_over_100_log - mean_under_100_log
cat("\nPoint Estimate (Difference in Means of Log(Page Views)):", point_estimate_log, "\n")


# Create the boxplot using the log-transformed data
boxplot(log_page_views ~ group, data = data,
        main = "Log-Transformed Page Views by Backlink Group",
        xlab = "Backlink Group",
        ylab = "Log(Page Views)",
        col = c("lightblue", "lightgreen"),
        border = "black")

# Plot the means
barplot(
  height = c(mean_under_100_log, mean_over_100_log), 
  names.arg = c("< 100", ">= 100"),
  col = c("lightblue", "lightgreen"),
  main = "Mean Log-Transformed Page Views by Backlink Group",
  xlab = "Backlink Group",
  ylab = "Mean Log(Page Views)"
)

# =============== #
# Two Sample Test #
#  (on Log Data)  #
# =============== #

# Two-sample t-test on log-transformed page views between the two groups
t_test_result <- t.test(over_100$log_page_views, under_100$log_page_views)

# Print the t-test result
print(t_test_result)

