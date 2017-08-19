
########
##
##  JHU Data Science Capstone
##  Create Corpus and N-Grams
##
########
#
# Author: Chris Walsh
# Date: 7/30/2017


source("On Load.R")

# read text data

twitter.con <- file("raw_data/final/en_US/en_US.twitter.txt", "r") 
blogs.con <- file("raw_data/final/en_US/en_US.blogs.txt", "r") 
news.con <- file("raw_data/final/en_US/en_US.news.txt", "rb") 

US.twitter <- readLines(twitter.con, skipNul = TRUE) 
US.blogs <- readLines(blogs.con, skipNul = TRUE) 
US.news <- readLines(news.con, skipNul = TRUE) 

set.seed(522)
US.twitter <- sample(US.twitter)
US.blogs <- sample(US.blogs)
US.news <- sample(US.news)

## insert clean

US.twitter.chunk <- split(US.twitter, cut(seq_along(US.twitter), 20, labels = FALSE)) 
US.blogs.chunk <- split(US.blogs, cut(seq_along(US.blogs), 20, labels = FALSE)) 
US.news.chunk <- split(US.news, cut(seq_along(US.news), 20, labels = FALSE)) 

close(twitter.con)
close(blogs.con)
close(news.con)
rm(twitter.con)
rm(blogs.con)
rm(news.con)
rm(US.twitter)
rm(US.blogs)
rm(US.news)

## Tokenize functions

BiTokens <- function(x) {NGramTokenizer(x, Weka_control(min = 2, max = 2))}
TriTokens <- function(x) {NGramTokenizer(x, Weka_control(min = 3, max = 3))}
QuadTokens <- function(x) {NGramTokenizer(x,Weka_control(min = 4, max = 4))}

for (i in 1:20){

doc.list <- list(blog = US.blogs.chunk[[i]], twitter = US.twitter.chunk[[i]], 
                                       news = US.news.chunk[[i]])


## Clean Text

docs <- VCorpus(VectorSource(doc.list))

docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs,content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, stripWhitespace)


tdm <- TermDocumentMatrix(docs)
tdm <- removeSparseTerms(tdm, 0.9999)
tdm.freq <- sort(row_sums(tdm, na.rm = T), decreasing=TRUE)
rm(tdm)
tdm.freq <- data.table(word=names(tdm.freq), freq=tdm.freq)
saveRDS(tdm.freq, paste("NGrams/UniGram",i,".rds", sep = ""))
rm(tdm.freq)


tdm2 <- TermDocumentMatrix(docs, control=list(tokenize=BiTokens))
tdm2 <- removeSparseTerms(tdm2, 0.9999)
tdm2.freq <- sort(row_sums(tdm2, na.rm = T), decreasing=TRUE)
rm(tdm2)
tdm2.freq <- data.table(word=names(tdm2.freq), freq=tdm2.freq)
tdm2.freq <- tdm2.freq %>% separate(word, c("nmin1.gram", "word"), " ")
tdm2.freq <- na.omit(tdm2.freq)
saveRDS(tdm2.freq, paste("NGrams/BiGram",i,".rds", sep = ""))
rm(tdm2.freq)

tdm3 <- TermDocumentMatrix(docs, control=list(tokenize=TriTokens))
tdm3 <- removeSparseTerms(tdm3, 0.9999)
tdm3.freq <- sort(row_sums(tdm3, na.rm = T), decreasing=TRUE)
rm(tdm3)
tdm3.freq <- data.table(word=names(tdm3.freq), freq=tdm3.freq)
tdm3.freq <- tdm3.freq %>% separate(word, c("one", "two", "word"), " ") %>%
  unite(nmin1.gram, one:two, sep =" ")
tdm3.freq <- na.omit(tdm3.freq)
saveRDS(tdm3.freq, paste("NGrams/TriGram",i,".rds", sep = ""))
rm(tdm3.freq)

tdm4 <- TermDocumentMatrix(docs, control=list(tokenize=QuadTokens))
tdm4 <- removeSparseTerms(tdm4, 0.9999)
tdm4.freq <- sort(row_sums(tdm4, na.rm = T), decreasing=TRUE)
rm(tdm4)
tdm4.freq <- data.table(word=names(tdm4.freq), freq=tdm4.freq)
tdm4.freq <- tdm4.freq %>% separate(word, c("one", "two", "three", "word"), " ") %>%
  unite(nmin1.gram, one:three, sep =" ")
tdm4.freq <- na.omit(tdm4.freq)
saveRDS(tdm4.freq, paste("NGrams/QuadGram",i,".rds", sep = ""))
rm(tdm4.freq)

}
