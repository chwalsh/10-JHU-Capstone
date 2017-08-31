
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

# UniGram <- readRDS("NGrams/Final_UniGram 1-16.rds")
# BiGram <- readRDS("NGrams/Final_BiGram 1-16.rds")
# TriGram <- readRDS("NGrams/Final_TriGram 1-16.rds")
# QuadGram <- readRDS("NGrams/Final_QuadGram 1-16.rds")

UniGram <- readRDS("NGrams/Final_UniGram 1-16.rds")
BiGram <- readRDS("NGrams/BiGram_Cutoff.rds")
TriGram <- readRDS("NGrams/TriGram_Cutoff.rds")
QuadGram <- readRDS("NGrams/QuadGram_Cutoff.rds")


# katzgt_bi <- function(x){
# 
#   x <- VCorpus(VectorSource(x))
#   x <- tm_map(x, removePunctuation)
#   x <- tm_map(x,content_transformer(tolower))
#   x <- tm_map(x, removeNumbers)
#   x <- tm_map(x, stripWhitespace)
# 
#   x <- unlist(x)[1]
# 
#   x <- unlist(strsplit(x, split = " "))
#   last.one <- x[length(x)]
# 
#   BiGram_rel <- BiGram[nmin1.gram == last.one, j = list(nmin1.gram, word, freq, prob = (freq_adj)/sum(freq))]
# 
#   UniGram_rel <- UniGram[!(word %in% BiGram_rel$word), j = list(word, freq,
#                                                                 prob = (1 - sum(BiGram_rel$prob)) * freq/sum(freq))]
# 
#   Bi_out <- rbindlist(list(BiGram_rel[j = list(word, prob)],UniGram_rel[j = list(word, prob)]))
#   Bi_out <- Bi_out[order(-prob)]
# 
#   return(Bi_out$word[1:3])
# 
# }


# katzgt_tri <- function(x){
# 
#   x <- VCorpus(VectorSource(x))
#   x <- tm_map(x, removePunctuation)
#   x <- tm_map(x,content_transformer(tolower))
#   x <- tm_map(x, removeNumbers)
#   x <- tm_map(x, stripWhitespace)
# 
#   x <- unlist(x)[1]
# 
#   x <- unlist(strsplit(x, split = " "))
#   last.one <- x[length(x)]
#   last.two <- paste(x[length(x)-1],last.one)
# 
#   TriGram_rel <- TriGram[nmin1.gram == last.two, j = list(nmin1.gram, word, freq, prob = (freq_adj)/sum(freq))]
# 
#   BiGram_rel <- BiGram[nmin1.gram == last.one & !(word %in% TriGram_rel$word),
#                        j = list(nmin1.gram, word, freq, prob = (1 - sum(TriGram_rel$prob)) * (freq_adj)/sum(freq))]
# 
#   UniGram_rel <- UniGram[!(word %in% TriGram_rel$word) & !(word %in% BiGram_rel$word),
#                          j = list(word, freq, prob = (1 - sum(TriGram_rel$prob) - sum(BiGram_rel$prob)) * freq/sum(freq))]
# 
#   Tri_out <- rbindlist(list(TriGram_rel[j = list(word, prob)], BiGram_rel[j = list(word, prob)],
#                             UniGram_rel[j = list(word, prob)]))
#   Tri_out <- Tri_out[order(-prob)]
# 
#   return(Tri_out$word[1:3])
# 
# }

katzgt_quad <- function(x){
  
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
  
  QuadGram_rel <- QuadGram[nmin1.gram == last.three, j = list(nmin1.gram, word, freq, prob = (freq_adj)/sum(freq))]
  
  TriGram_rel <- TriGram[nmin1.gram == last.two & !(word %in% QuadGram_rel$word), 
                         j = list(nmin1.gram, word, freq, prob = (1 - sum(QuadGram_rel$prob)) * (freq_adj)/sum(freq))]
  
  BiGram_rel <- BiGram[nmin1.gram == last.one & !(word %in% QuadGram_rel$word) & !(word %in% TriGram_rel$word), j
                       = list(nmin1.gram, word, freq, 
                              prob = (1 - sum(QuadGram_rel$prob) - sum(TriGram_rel$prob)) * (freq_adj)/sum(freq))]
  
  UniGram_rel <- UniGram[!(word %in% QuadGram_rel$word) & !(word %in% TriGram_rel$word) & !(word %in% BiGram_rel$word), 
                         j = list(word, freq, 
                                  prob = (1 - sum(QuadGram_rel$prob) - sum(TriGram_rel$prob) - sum(BiGram_rel$prob)) * freq/sum(freq))]
  
  Quad_out <- rbindlist(list(QuadGram_rel[j = list(word, prob)], TriGram_rel[j = list(word, prob)], 
                             BiGram_rel[j = list(word, prob)],UniGram_rel[j = list(word, prob)]))
  Quad_out <- Quad_out[order(-prob)]
  
  # return(Quad_out[1:100,])
  return(Quad_out[1,1])
  
}

out <- katzgt_quad("My favorite food is")

display <- out$word[1:3]
wordcloud(out$word, out$prob, max.words = 100, random.order = FALSE, colors=brewer.pal(8, "Dark2"))

# out[1:50,]


###############################
###############################

QuadGram_test <- readRDS("NGrams/QuadGrams_test.rds")


UniGram <- readRDS("NGrams/Final_UniGram 1-16.rds")
BiGram <- readRDS("NGrams/BiGram_Cutoff.rds")
TriGram <- readRDS("NGrams/TriGram_Cutoff.rds")
QuadGram <- readRDS("NGrams/QuadGram_Cutoff.rds")

set.seed(522)
sample <- QuadGram_test[sample(.N,1000)]

predict <- sapply(sample$nmin1.gram, katzgt_quad)
sample$predict <- predict
sample$match <- sample$word == sample$predict
sum(sample$match)/length(sample$match)