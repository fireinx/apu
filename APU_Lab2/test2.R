# Przygotowanie danych
nazwa <- c("aparat1", "aparat2", "aparat3", "aparat4", "aparat5", "aparat6", "aparat7", "aparat8", "aparat9", "aparat10", "aparat11", "aparat12")
rozdzielczosc <- c(20, 24, 18, 26, 30, 20, 22, 24, 26, 28, 32, 34)
zakres_czulosci <- c(100, 200, 100, 300, 200, 400, 100, 200, 300, 100, 200, 300)
cena <- c(5000, 6000, 5500, 7000, 7500, 8000, 8500, 9000, 6500, 6000, 7000, 8000)
liczba_opinii <- c(100, 200, 150, 300, 250, 400, 350, 450, 300, 200, 100, 150)
ocena_klientow <- c(4.5, 4.7, 4.2, 4.8, 4.9, 4.3, 4.6, 4.7, 4.1, 4.4, 4.6, 4.5)

aparaty <- data.frame(nazwa, rozdzielczosc, zakres_czulosci, cena, liczba_opinii, ocena_klientow)

# Install and load ahp package
install.packages("ahp")
library(ahp)

# Create AHP model
ahp_model <- "
# This is a comment
# AHP model for selecting the best camera

Goal: Select the best camera
Criteria:
  - Performance
- Quality
- Price
Alternatives:
  - aparat1
- aparat2
- aparat3
- aparat4
- aparat5
- aparat6
- aparat7
- aparat8
- aparat9
- aparat10
- aparat11
- aparat12
"

# Save the model to a file
writeLines(ahp_model, "camera_selection.ahp")

# Load the model
model <- Load("camera_selection.ahp")

# Define the pairwise comparisons
model$Performance <- pairwiseMatrix(c(1, 1/3, 3, 1, 3, 3, 1/3, 1, 1, 1, 1/3, 1/3), nrow = 4)
model$Quality <- pairwiseMatrix(c(1, 3, 1/3, 1/3, 1, 3, 3, 1, 1, 3, 3, 1), nrow = 4)
model$Price <- pairwiseMatrix(c(1, 1, 1/3, 1/3, 3, 1, 3, 1, 1, 3, 3, 1), nrow = 4)

# Define the pairwise comparisons for alternatives
model$Alternatives <- pairwiseMatrix(c(1, 1/3, 1/3, 3, 1/3, 1, 3, 1, 1/3, 1/3, 3, 1), nrow = 12)

# Calculate the results
results <- Calculate(model)

# Print the results
print(results)
"