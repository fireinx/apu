# Load necessary library
install.packages('neuralnet')
library(neuralnet)

# Generate training data
x <- seq(1, 16, by=0.1)
y <- exp(sqrt(x))

# Combine into a data frame
training_data <- data.frame(x = x, y = y)

# Normalize the data
maxs <- apply(training_data, 2, max)
mins <- apply(training_data, 2, min)
scaled_training_data <- as.data.frame(scale(training_data, center = mins, scale = maxs - mins))

# Train neural network
set.seed(123)
net <- neuralnet(y ~ x, data = scaled_training_data, hidden = c(3, 2), threshold = 0.01)

# Print the neural network model
print(net)

# Plot the neural network
plot(net)

# Test the neural network on training data
test_data <- as.data.frame(seq(1, 16, by=0.5))
colnames(test_data) <- c("x")
scaled_test_data <- as.data.frame(scale(test_data, center = mins[1], scale = maxs[1] - mins[1]))
net_results <- compute(net, scaled_test_data)
predicted <- net_results$net.result

# Denormalize the predictions
predicted <- predicted * (maxs[2] - mins[2]) + mins[2]

# Print the results
print(data.frame(x = seq(1, 16, by=0.5), predicted = predicted))
