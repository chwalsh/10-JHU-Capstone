
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

# UniGram <- readRDS("Ngrams/Final_UniGram.rds")
# BiGram <- readRDS("Ngrams/Final_BiGram.rds")
# TriGram <- readRDS("Ngrams/Final_TriGram.rds")
# QuadGram <- readRDS("Ngrams/Final_QuadGram.rds")

UniGram <- readRDS("Ngrams/Final_UniGram.rds")
Uni <- readRDS("Ngrams/Uni.rds")
Bi <- readRDS("Ngrams/Bi.rds")
Tri <- readRDS("Ngrams/Tri.rds")
Quad <- readRDS("Ngrams/Quad.rds")



  predict_unigram <- function(x){
    UniGram[1,1]
    
  }

predict_bigram <- function(x){
  # BiGram[x == BiGram$hashword,2]
  Bi[[x]]
  
}

predict_trigram <- function(x){
  # TriGram[x == TriGram$hashword,2]
  Tri[[x]]
  
}


predict_quadgram <- function(x){
  # QuadGram[x == QuadGram$hashword,2]
  Quad[[x]]
  
}



predict_backoff <- function(x){
  
  x <- VCorpus(VectorSource(x))
  x <- tm_map(x, removePunctuation)
  x <- tm_map(x,content_transformer(tolower))
  x <- tm_map(x, removeNumbers)
  x <- tm_map(x, stripWhitespace)
  
  x <- unlist(x)[1]
  
  x <- unlist(strsplit(x, split = " "))
  last.one <- x[length(x)]
  last.two <- paste(x[length(x)-1],last.one)
  last.three <- paste(x[length(x)-2], last.two)

  last.one <- spooky.32(last.one)
  last.two <- spooky.32(last.two)
  last.three <- spooky.32(last.three)

  if (!is.na(predict_quadgram(last.three)[1])){
    predict_quadgram(last.three)[1]}
  else if (!is.na(predict_trigram(last.two)[1])){
    predict_trigram(last.two)[1]}
  else if (!is.na(predict_bigram(last.one)[1])){
    predict_bigram(last.one)[1]}
  else {
    predict_unigram(last.one)[1]
  }
}
