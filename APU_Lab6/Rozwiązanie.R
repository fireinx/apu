# Ładowanie niezbędnych paczek
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library("tidytext")
library("igraph")
library("ggraph")
library("rvest")
library("dplyr")
library("tidyr")

# Pobranie tekstu z URL
url <- 'https://en.wikipedia.org/wiki/Poetry'
webpage <- read_html(url)
text <- webpage %>%
  html_nodes("p") %>%
  html_text() %>%
  paste(collapse = " ")

# Przekształcenie tekstu do obiektu Corpus
TextDoc <- VCorpus(VectorSource(text))

# "Wyczyszczanie" tekstu
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
TextDoc <- tm_map(TextDoc, toSpace, "/")
TextDoc <- tm_map(TextDoc, toSpace, "@")
TextDoc <- tm_map(TextDoc, toSpace, "\\|")
TextDoc <- tm_map(TextDoc, content_transformer(tolower))
TextDoc <- tm_map(TextDoc, removeNumbers)
TextDoc <- tm_map(TextDoc, removeWords, stopwords("english"))
TextDoc <- tm_map(TextDoc, removePunctuation)
TextDoc <- tm_map(TextDoc, stripWhitespace)
TextDoc <- tm_map(TextDoc, stemDocument)

# Budowanie macierzy dokumentu
TextDoc_dtm <- TermDocumentMatrix(TextDoc)
dtm_m <- as.matrix(TextDoc_dtm)
dtm_v <- sort(rowSums(dtm_m), decreasing = TRUE)
dtm_d <- data.frame(word = names(dtm_v), freq = dtm_v)

# Wyświetlanie 5 najczęstszych słów
head(dtm_d, 5)

# Wykres słupkowy najczęstszych słów
barplot(dtm_d[1:20,]$freq, las = 2, names.arg = dtm_d[1:20,]$word,
        col ="lightgreen",
        main ="Top 20 najczęściej używanych słów w artykule",
        ylab = "Word frequencies")

# Generowanie chmury słów
set.seed(1234)
wordcloud(words = dtm_d$word, freq = dtm_d$freq, scale=c(5,0.5),
          min.freq = 1, max.words=100, random.order=FALSE,
          rot.per=0.40, colors=brewer.pal(8, "Dark2"))

# Kojarzenia słów
findAssocs(TextDoc_dtm, terms = c("poetry","form","literary","work"), corlimit = 0.5)

# Analiza sentymentu
syuzhet_vector <- get_sentiment(text, method="syuzhet")
summary(syuzhet_vector)

bing_vector <- get_sentiment(text, method="bing")
summary(bing_vector)

afinn_vector <- get_sentiment(text, method="afinn")
summary(afinn_vector)

# Analiza emocji
d <- get_nrc_sentiment(as.vector(dtm_d$word))
td <- data.frame(t(d))
td_new <- data.frame(rowSums(td[1:56]))
names(td_new)[1] <- "count"
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new2 <- td_new[1:8,]

# Wykres liczby słów związanych z każdym uczuciem
ggplot(td_new2, aes(x = sentiment, y = count, fill = sentiment)) + 
  geom_bar(stat = "identity") + 
  ggtitle("Survey sentiments") +
  ylab("count")

# Bigramy
text_df <- tibble(line = 1, text = text)
tidy_text <- text_df %>%
  unnest_tokens(word, text)

data(stop_words)
tidy_text <- tidy_text %>%
  anti_join(stop_words, by = "word")

# Lista częstotliwości słów
tidy_text %>%
  count(word, sort = TRUE)

# Bigramy
text_bigrams <- text_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

text_bigrams %>%
  count(bigram, sort = TRUE)

bigrams_separated <- text_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

bigram_counts <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)

bigrams_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")

# Konstruowanie grafów
bigram_graph <- bigram_counts %>%
  filter(word1 == "poetry" | word2 == "poetry") %>%
  graph_from_data_frame()

# Wyświetlanie grafów
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = TRUE, arrow = arrow(type = "closed", length = unit(.15, "inches")), end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), position = "identity") +
  theme_void()

