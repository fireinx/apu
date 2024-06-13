rm(list = ls())

# Instalacja potrzebnych pakietów, jeœli nie s¹ ju¿ zainstalowane
install.packages(c("mlr", "C50", "rpart", "party", "readr", "dplyr", "magrittr"))

# Za³adowanie potrzebnych bibliotek
library(mlr)
library(C50)
library(rpart)
library(party)
library(readr)
library(dplyr)
library(magrittr)
library(rpart.plot)

# Za³adowanie zestawu danych mtcars
data("mtcars")

# Utworzenie nowej zmiennej binarnej 'fast' na podstawie mediany mpg
mtcars$fast <- ifelse(mtcars$mpg >= median(mtcars$mpg), 1, 0)
mtcars$fast <- factor(mtcars$fast, levels = c(0, 1), labels = c("slow", "fast"))

# Ustawienie ziarna dla reprodukowalnoœci wyników
set.seed(123)
trainIndex <- sample(1:nrow(mtcars), 0.7 * nrow(mtcars))
trainData <- mtcars[trainIndex, ]
testData <- mtcars[-trainIndex, ]

# Definicja zadania klasyfikacji
task <- makeClassifTask(data = trainData, target = "fast")

# Trenowanie modelu drzewa decyzyjnego C5.0
learner <- makeLearner("classif.C50", predict.type = "response")
model <- train(learner, task)

# Predykcja na zestawie testowym
pred <- predict(model, newdata = testData)

# Ocena modelu
performance <- performance(pred, measures = list(acc, mmce))
print(performance)

# Definicja ucz¹cych
learners <- list(
  makeLearner("classif.rpart"),
  makeLearner("classif.C50"),
  makeLearner("classif.randomForest")
)

# Benchmarking
resampling <- makeResampleDesc("CV", iters = 5)
benchmark_result <- benchmark(learners, tasks = task, resampling = resampling)
print(benchmark_result)

# Trenowanie modelu rpart
rpart_model <- rpart(fast ~ ., data = trainData)
rpart.plot(rpart_model)

# Zapisanie wytrenowanego modelu
save(model, file = "decision_tree_model.RData")

# Zapisanie wyników benchmarkingu
save(benchmark_result, file = "benchmark_results.RData")

# Zapisanie wyników oceny
write.csv(as.data.frame(performance), "performance_results.csv")

