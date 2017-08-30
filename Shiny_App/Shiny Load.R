library(data.table)
library(tm)
library(wordcloud)

katz_quad <- function(x, k){
  
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
  
  QuadGram_rel <- QuadGram[nmin1.gram == last.three, j = list(nmin1.gram, word, freq, prob = (freq - k)/sum(freq))]
  
  TriGram_rel <- TriGram[nmin1.gram == last.two & !(word %in% QuadGram_rel$word), 
                         j = list(nmin1.gram, word, freq, prob = (1 - sum(QuadGram_rel$prob)) * (freq - k)/sum(freq))]
  
  BiGram_rel <- BiGram[nmin1.gram == last.one & !(word %in% QuadGram_rel$word) & !(word %in% TriGram_rel$word), j
                       = list(nmin1.gram, word, freq, 
                              prob = (1 - sum(QuadGram_rel$prob) - sum(TriGram_rel$prob)) * (freq - k)/sum(freq))]
  
  UniGram_rel <- UniGram[!(word %in% QuadGram_rel$word) & !(word %in% TriGram_rel$word) & !(word %in% BiGram_rel$word), 
                         j = list(word, freq, 
                                  prob = (1 - sum(QuadGram_rel$prob) - sum(TriGram_rel$prob) - sum(BiGram_rel$prob)) * freq/sum(freq))]
  
  Quad_out <- rbindlist(list(QuadGram_rel[j = list(word, prob)], TriGram_rel[j = list(word, prob)], 
                             BiGram_rel[j = list(word, prob)],UniGram_rel[j = list(word, prob)]))
  Quad_out <- Quad_out[order(-prob)]
  
  return(Quad_out[1:100,])
  
}

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