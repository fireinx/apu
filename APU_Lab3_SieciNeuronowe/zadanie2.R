# Ładowanie niezbędnych pakietów
library(neuralnet)
library(caret) # do normalizacji danych

# Przygotowanie danych
nazwa <- c("aparat1", "aparat2", "aparat3", "aparat4", "aparat5", "aparat6", "aparat7", "aparat8", "aparat9", "aparat10", "aparat11", "aparat12")
rozdzielczosc <- c(20, 24, 18, 26, 30, 20, 22, 24, 26, 28, 32, 34)
zakres_czulosci <- c(100, 200, 100, 300, 200, 400, 100, 200, 300, 100, 200, 300)
cena <- c(5000, 6000, 5500, 7000, 7500, 8000, 8500, 9000, 6500, 6000, 7000, 8000)
liczba_opinii <- c(100, 200, 150, 300, 250, 400, 350, 450, 300, 200, 100, 150)
ocena_klientow <- c(4.5, 4.7, 4.2, 4.8, 4.9, 4.3, 4.6, 4.7, 4.1, 4.4, 4.6, 4.5)

aparaty <- data.frame(nazwa, rozdzielczosc, zakres_czulosci, cena, liczba_opinii, ocena_klientow)

# Normalizacja danych
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

aparaty_norm <- as.data.frame(lapply(aparaty[2:6], normalize))

# Podział danych na zbiór treningowy i testowy (80% trening, 20% test)
set.seed(123)
trainIndex <- sample(seq_len(nrow(aparaty_norm)), size = 0.8 * nrow(aparaty_norm))
trainData <- aparaty_norm[trainIndex, ]
testData <- aparaty_norm[-trainIndex, ]

# Sprawdzenie rozmiarów zbiorów danych
print(paste("Rozmiar zbioru treningowego:", nrow(trainData)))
print(paste("Rozmiar zbioru testowego:", nrow(testData)))

# Zbudowanie modelu sieci neuronowej z większą liczbą neuronów w warstwach ukrytych
set.seed(123)
nn <- neuralnet(cena ~ rozdzielczosc + zakres_czulosci + liczba_opinii + ocena_klientow, 
                data = trainData, hidden = c(10, 5), linear.output = TRUE, stepmax = 1e7)

# Wizualizacja sieci neuronowej
plot(nn)

# Prognozowanie cen na podstawie danych testowych
predicted <- compute(nn, testData[, -4])$net.result

# Denormalizacja prognozowanych wartości
denormalize <- function(x, orig) {
  return (x * (max(orig) - min(orig)) + min(orig))
}

predicted_prices <- denormalize(predicted, aparaty$cena)
actual_prices <- denormalize(testData$cena, aparaty$cena)

# Obliczenie błędu prognozy
error <- abs(predicted_prices - actual_prices)

# Wyniki
results <- data.frame(actual = actual_prices, predicted = predicted_prices, error = error)
print(results)

# Sprawdzenie, czy błąd prognozy jest mniejszy niż 100zł
mean_error <- mean(error)
print(paste("Średni błąd prognozy: ", mean_error, "zł"))

if (mean_error <= 100) {
  print("Błąd prognozy jest mniejszy lub równy 100zł.")
} else {
  print("Błąd prognozy jest większy niż 100zł.")
}
