

source("On Load.R")

consolidate_ngram <- function(x){
  
  if (x == 1){
    
    UniGram <- list()
    
    for (i in 1:16){
      
      UniGram[[i]] <- readRDS(paste("NGrams/UniGram",i,".rds", sep = ""))

      }
    
    UniGram <- rbindlist(UniGram)
    UniGram <- UniGram[, j = list(freq = sum(freq)),by = word]
    UniGram <- UniGram[, j = list(freq),by = list(word)]
    saveRDS(UniGram, "NGrams/Final_Unigram.rds")
    return(UniGram)

  }
  
  if (x == 2){ 
    
    BiGram <- list()  
    
    for (i in 1:16){
    
      BiGram[[i]] <- readRDS(paste("NGrams/BiGram",i,".rds", sep = ""))

      }
    
    BiGram <- rbindlist(BiGram)
    BiGram <- BiGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    BiGram <- BiGram[, j = list(freq), by = list(nmin1.gram, word)]
    
    BiFreqCount <- BiGram[j = list(count = .N), by = freq]
    BiFreqCount <- BiFreqCount[j = list(freq, count, freq_1 = freq + 1)]
    BiFreqCount <- merge(BiFreqCount, BiFreqCount, by.x = "freq_1", by.y = "freq")[j = list(freq, count.x, count.y)]
    BiFreqCount <- BiFreqCount[i = freq <= 5, j = list(count.x, count.y, freq_adj = (freq + 1)*(count.y/count.x)), by = freq]
    BiFreqCount <- BiFreqCount[key = "freq"]
    
    BiGram <- BiGram[BiFreqCount, freq_adj:= freq_adj, on ="freq"]
    BiGram[is.na(BiGram$freq_adj)]$freq_adj <- BiGram[is.na(BiGram$freq_adj)]$freq
    
    saveRDS(BiGram, "NGrams/Final_Bigram.rds")
    return(BiGram)

  }
  
  if (x == 3){
    
    TriGram <- list()
    
    for (i in 1:16){
    
      TriGram[[i]] <- readRDS(paste("NGrams/TriGram",i,".rds", sep = ""))

      }
    
    TriGram <- rbindlist(TriGram)
    TriGram <- TriGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    TriGram <- TriGram[, j = list(freq), by = list(nmin1.gram, word)]
    
    TriFreqCount <- TriGram[j = list(count = .N), by = freq]
    TriFreqCount <- TriFreqCount[j = list(freq, count, freq_1 = freq + 1)]
    TriFreqCount <- merge(TriFreqCount, TriFreqCount, by.x = "freq_1", by.y = "freq")[j = list(freq, count.x, count.y)]
    TriFreqCount <- TriFreqCount[i = freq <= 5, j = list(count.x, count.y, freq_adj = (freq + 1)*(count.y/count.x)), by = freq]
    TriFreqCount <- TriFreqCount[key = "freq"]
    
    TriGram <- TriGram[TriFreqCount, freq_adj:= freq_adj, on ="freq"]
    TriGram[is.na(TriGram$freq_adj)]$freq_adj <- TriGram[is.na(TriGram$freq_adj)]$freq
    
    saveRDS(TriGram, "NGrams/Final_Trigram.rds")
    return(TriGram)

  }
  
  if (x == 4){
    
    QuadGram <- list()
    
    for (i in 1:16){
      
      QuadGram[[i]] <- readRDS(paste("NGrams/QuadGram",i,".rds", sep = ""))

      }
    
    QuadGram <- rbindlist(QuadGram)
    QuadGram <- QuadGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    QuadGram <- QuadGram[, j = list(freq), by = list(nmin1.gram, word)]
    
    QuadFreqCount <- QuadGram[j = list(count = .N), by = freq]
    QuadFreqCount <- QuadFreqCount[j = list(freq, count, freq_1 = freq + 1)]
    QuadFreqCount <- merge(QuadFreqCount, QuadFreqCount, by.x = "freq_1", by.y = "freq")[j = list(freq, count.x, count.y)]
    QuadFreqCount <- QuadFreqCount[i = freq <= 5, j = list(count.x, count.y, freq_adj = (freq + 1)*(count.y/count.x)), by = freq]
    QuadFreqCount <- QuadFreqCount[key = "freq"]
    
    QuadGram <- QuadGram[QuadFreqCount, freq_adj:= freq_adj, on ="freq"]
    QuadGram[is.na(QuadGram$freq_adj)]$freq_adj <- QuadGram[is.na(QuadGram$freq_adj)]$freq
    
    saveRDS(QuadGram, "NGrams/Final_Quadgram.rds")
    return(QuadGram)

  }
  
}
  

UniGram <- consolidate_ngram(1)
BiGram <- consolidate_ngram(2)
TriGram <- consolidate_ngram(3)
QuadGram <- consolidate_ngram(4)

BiGram <- BiGram_bu





