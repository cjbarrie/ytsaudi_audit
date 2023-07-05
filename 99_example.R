library(tidyverse)

# set seed for reproducibility
set.seed(123)

# number of data points
n <- 100

# simulate initial bias: uniformly distributed from -10 to 10
initial_bias <- runif(n, min = -10, max = 10)

# matrix to hold subsequent bias scores
bias_scores <- matrix(nrow = n, ncol = 5)

# function to adjust bias scores
adjust_bias <- function(bias) {
  if(bias == 0) {
    # if initial bias is neutral, keep subsequent biases the same
    return(rep(bias, 5))
  } else {
    # if initial bias is not neutral, increase bias over time
    return(bias + c(0, 1, 2, 3, 4))
  }
}

# generate bias scores for each initial bias
for(i in 1:n) {
  bias_scores[i, ] <- adjust_bias(initial_bias[i])
}

# create dataframe
df <- data.frame(cbind(initial_bias, bias_scores))
names(df) <- c("initial_bias", paste0("bias_score_", 1:5))

# print out first few rows
head(df)

# reshape data
df_long <- df %>% 
  gather(key = "time", value = "bias_score", -initial_bias)

# convert the time variable to numeric
df_long$time <- as.numeric(gsub("bias_score_", "", df_long$time))

# categorize initial_bias
df_long$initial_bias_category <- cut(df_long$initial_bias, breaks = c(-Inf, -1, 1, Inf), 
                                     labels = c("Negative Bias", "Neutral", "Positive Bias"), 
                                     include.lowest = TRUE)

# jitter plot
ggplot(df_long, aes(x = time, y = bias_score, color = initial_bias_category)) +
  geom_jitter(alpha = 0.6, width = 0.2, height = 0.2) +
  labs(title = "Bias Scores Over Time",
       x = "Time",
       y = "Bias Score",
       color = "Initial Bias\nCategory") +
  theme_minimal() +
  scale_color_manual(values = c("blue", "grey", "red"), 
                     labels = c("Negative Bias", "Neutral", "Positive Bias"))


ggsave("plots/exampleplot.png")
