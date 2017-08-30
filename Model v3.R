
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

UniGram <- readRDS("NGrams/Final_UniGram.rds")
BiGram <- readRDS("NGrams/Final_BiGram.rds")
TriGram <- readRDS("NGrams/Final_TriGram.rds")
QuadGram <- readRDS("NGrams/Final_QuadGram.rds")

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
  
  return(Quad_out[1:100,])

}

out <- katzgt_quad("groceries in each")

out$word[1:3]
out[1:50,]


set.seed(522)
sample <- QuadGram_test[sample(.N,5000)]

predict <- sapply(sample$nmin1.gram, katzgt_quad)
sample$predict <- predict
sample$match <- sample$word == sample$predict
sum(sample$match)/length(sample$match)

predict2 <- sapply(sample$nmin1.gram, katz_quad, k=0.5)
sample$predict2 <- predict2
sample$match2 <- sample$word == sample$predict2
sum(sample$match2)/length(sample$match2)

predict3 <- sapply(sample$nmin1.gram, katz_quad, k=0.25)
sample$predict3 <- predict3
sample$match3 <- sample$word == sample$predict3
sum(sample$match3)/length(sample$match3)

predict4 <- sapply(sample$nmin1.gram, katz_quad, k=0.7)
sample$predict4 <- predict4
sample$match4 <- sample$word == sample$predict4
sum(sample$match4)/length(sample$match4)

