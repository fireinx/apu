# Instalacja i załadowanie potrzebnych pakietów
install.packages("mlr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("randomForest")
install.packages("e1071")
install.packages("nnet")
install.packages("kernlab")

library(mlr)
library(dplyr)
library(ggplot2)
library(randomForest)
library(e1071)
library(nnet)
library(kernlab)

# Przygotowanie danych
nazwa <- c("aparat1", "aparat2", "aparat3", "aparat4", "aparat5", "aparat6", "aparat7", "aparat8", "aparat9", "aparat10", "aparat11", "aparat12")
rozdzielczosc <- c(20, 24, 18, 26, 30, 20, 22, 24, 26, 28, 32, 34)
zakres_czulosci <- c(100, 200, 100, 300, 200, 400, 100, 200, 300, 100, 200, 300)
cena <- c(5000, 6000, 5500, 7000, 7500, 8000, 8500, 9000, 6500, 6000, 7000, 8000)
liczba_opinii <- c(100, 200, 150, 300, 250, 400, 350, 450, 300, 200, 100, 150)
ocena_klientow <- c(4.5, 4.7, 4.2, 4.8, 4.9, 4.3, 4.6, 4.7, 4.1, 4.4, 4.6, 4.5)

data <- data.frame(rozdzielczosc, zakres_czulosci, cena, liczba_opinii, ocena_klientow)

# Zdefiniowanie zadania
regr_task <- makeRegrTask(id = "RTV_AGD_Prediction", data = data, target = "ocena_klientow")

# Wybór learnerów
learners <- list(
  makeLearner("regr.lm"),
  makeLearner("regr.randomForest"),
  makeLearner("regr.ksvm"),
  makeLearner("regr.nnet")
)

# Wykonanie benchmarkingu
rdesc <- makeResampleDesc("CV", iters = 5)
bmr <- benchmark(learners, regr_task, rdesc, measures = list(rmse))

# Wizualizacja wyników
# Boxplot
plotBMRBoxplots(bmr, style = "box") + ggtitle("Porównanie metod pod względem RMSE") + theme_bw(base_size = 16)

# Violin plot
plotBMRBoxplots(bmr, style = "violin") + ggtitle("Porównanie metod pod względem RMSE") + theme_bw(base_size = 16)

# Ranking
plotBMRRanksAsBarChart(bmr, pos = "stack") + ggtitle("Ranking metod") + theme_bw(base_size = 16)

# Uzyskanie wyników benchmarkingu
getBMRAggrPerformances(bmr)

# Użycie wyników dla wizualizacji i analizy
perf <- getBMRPerformances(bmr, as.df = TRUE)
ggplot(perf, aes(x = learner.id, y = rmse, color = learner.id)) +
  geom_boxplot() +
  ggtitle("Porównanie RMSE różnych metod") +
  theme_bw(base_size = 16)
