# Podpunkt a)
a <- 5/4^3
b <- 2 * a
if (a < b) {
  print("a jest mniejsze")
} else {
  print("a jest większe lub równe")
}

# Podpunkt b)
?min

# Podpunkt c)
a <- 50:75
srednia_kwadratow <- mean(a^2)
print(srednia_kwadratow)

# Podpunkt d)
apropos("min")

# Podpunkt e)
setwd("G:/Mój dysk/InformatykaMGR 2024 2025/3. Lista Przedmiotów - 1 semestr/7. APU [E] Analiza procesów uczenia/1. Laboratoria/1. 23.02 - 1 sprawko/Sprawko1Gracjan/skrypt")
a <- "aparat z wymienna optyką"
save(a, file="SkryptPodpunktE.Rdata")
rm(a)
print(a)
load("SkryptPodpunktE.Rdata")
print(a)

# Podpunkt f)
install.packages("gridExtra")
library(gridExtra)
grid.table(head(Seatbelts, 10))

# Podpunkt g)
a <- seq(1000, 800, by=-5)

# Podpunkt h)
a <- 29:5
b <- 21:33
d <- c(b, a)
print(d)

# Podpunkt i)
nazwa <- c("aparat1", "aparat2", "aparat3", "aparat4", "aparat5", "aparat6", "aparat7", "aparat8", "aparat9", "aparat10")
rozdzielczosc <- c(1, 2, 3, 4, 5, 10, 15, 20, 25, 30)
zakres_czu_losci <- c(100, 150, 200, 250, 300, 10, 20, 30, 40, 50)
cena <- c(500, 600, 700, 800, 900, 1000, 100, 200, 300, 400)
liczba_opinii <- c(50, 60, 70, 80, 90, 100, 2, 3, 4, 5)
aparaty <- data.frame(nazwa, rozdzielczosc, zakres_czu_losci, cena, liczba_opinii)
mean(aparaty$cena)

# Podpunkt j)
nowy_aparat <- data.frame(nazwa = "nowy_aparat", rozdzielczosc = 10, zakres_czu_losci = 100, cena = 1000, liczba_opinii = 10000)
aparaty <- rbind(aparaty, nowy_aparat)
mean(aparaty$cena)

# Podpunkt k)
aparaty$ocena_klientow <- seq(0, 5, by=0.5)
aparaty$ocena_klientow <- as.factor(aparaty$ocena_klientow)
srednia_cena_ocena <- tapply(aparaty$cena, aparaty$ocena_klientow, mean)
print(srednia_cena_ocena)

# Podpunkt l)
nowe_aparaty <- data.frame(nazwa = c("aparat11", "aparat12", "aparat13", "aparat14"), 
                           rozdzielczosc = c(11, 12, 13, 14), 
                           zakres_czu_losci = c(100, 110, 120, 130), 
                           cena = c(600, 700, 800, 900), 
                           liczba_opinii = c(90, 100, 110, 120))
library(ggplot2)
ggplot(aparaty, aes(x=ocena_klientow)) +
  geom_bar(stat="count")


# Podpunkt m)
pie(table(aparaty$ocena_klientow))
plot(table(aparaty$ocena_klientow))

# Podpunkt n)
aparaty$status_opinii <- cut(aparaty$liczba_opinii, breaks = c(-Inf, 0, 50, 100, Inf), labels = c("nie ma", "mniej 50 opinii", "50-100 opinii", "więcej 100 opinii"))
aparaty$status_opinii <- as.factor(aparaty$status_opinii)
pie(table(aparaty$status_opinii))


# Podpunkt o)
wyniki <- paste(aparaty$nazwa, " ma ocenę klientów ", aparaty$ocena_klientow,
                " bo ma liczbę opinii ", aparaty$liczba_opinii)
print(wyniki)


# Podpunkt p)
write.csv(aparaty, file = "aparaty.csv", row.names = FALSE)
read.csv("aparaty.csv")

