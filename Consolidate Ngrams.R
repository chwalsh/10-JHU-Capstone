

source("On Load.R")

consolidate_ngram <- function(gram, start, stop, x = 5){
  
  if (gram == 1){
    
    UniGram <- list()
    
    for (i in start:stop){
      
      UniGram[[i]] <- readRDS(paste("NGrams/UniGram",i,".rds", sep = ""))

      }
    
    UniGram <- rbindlist(UniGram)
    UniGram <- UniGram[, j = list(freq = sum(freq)),by = word]
    # UniGram <- UniGram[, j = list(freq),by = list(word)]
    
    # saveRDS(UniGram, paste("NGrams/Final_Unigram ",start,"-",stop,".rds", sep = ""))
    return(UniGram)

  }
  
  if (gram == 2){ 
    
    BiGram <- list()  
    
    for (i in start:stop){
    
      BiGram[[i]] <- readRDS(paste("NGrams/BiGram",i,".rds", sep = ""))

      }
    
    BiGram <- rbindlist(BiGram)
    BiGram <- BiGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    # BiGram <- BiGram[, j = list(freq), by = list(nmin1.gram, word)]
    
    BiFreqCount <- BiGram[j = list(count = .N), by = freq]
    BiFreqCount <- BiFreqCount[j = list(freq, count, freq_1 = freq + 1)]
    BiFreqCount <- merge(BiFreqCount, BiFreqCount, by.x = "freq_1", by.y = "freq")[j = list(freq, count.x, count.y)]
    BiFreqCount <- BiFreqCount[i = freq <= x, j = list(count.x, count.y, freq_adj = (freq + 1)*(count.y/count.x)), by = freq]
    BiFreqCount <- BiFreqCount[key = "freq"]
    
    BiGram <- BiGram[BiFreqCount, freq_adj:= freq_adj, on ="freq"]
    BiGram[is.na(BiGram$freq_adj)]$freq_adj <- BiGram[is.na(BiGram$freq_adj)]$freq
    BiGram$wght_diff <- BiGram$freq_adj*(log(BiGram$freq/sum(BiGram$freq))-log(BiGram$freq_adj/sum(BiGram$freq)))
    
    # saveRDS(BiGram, paste("NGrams/Final_Bigram ",start,"-",stop,".rds", sep = ""))
    return(BiGram)

  }
  
  if (gram == 3){
    
    TriGram <- list()
    
    for (i in start:stop){
    
      TriGram[[i]] <- readRDS(paste("NGrams/TriGram",i,".rds", sep = ""))

      }
    
    TriGram <- rbindlist(TriGram)
    TriGram <- TriGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    # TriGram <- TriGram[, j = list(freq), by = list(nmin1.gram, word)]
    
    TriFreqCount <- TriGram[j = list(count = .N), by = freq]
    TriFreqCount <- TriFreqCount[j = list(freq, count, freq_1 = freq + 1)]
    TriFreqCount <- merge(TriFreqCount, TriFreqCount, by.x = "freq_1", by.y = "freq")[j = list(freq, count.x, count.y)]
    TriFreqCount <- TriFreqCount[i = freq <= x, j = list(count.x, count.y, freq_adj = (freq + 1)*(count.y/count.x)), by = freq]
    TriFreqCount <- TriFreqCount[key = "freq"]
    
    TriGram <- TriGram[TriFreqCount, freq_adj:= freq_adj, on ="freq"]
    TriGram[is.na(TriGram$freq_adj)]$freq_adj <- TriGram[is.na(TriGram$freq_adj)]$freq
    TriGram$wght_diff <- TriGram$freq_adj*(log(TriGram$freq/sum(TriGram$freq))-log(TriGram$freq_adj/sum(TriGram$freq)))
    
    # saveRDS(TriGram, paste("NGrams/Final_Trigram ",start,"-",stop,".rds", sep = ""))
    return(TriGram)

  }
  
  if (gram == 4){
    
    QuadGram <- list()
    
    for (i in start:stop){
      
      QuadGram[[i]] <- readRDS(paste("NGrams/QuadGram",i,".rds", sep = ""))

      }
    
    QuadGram <- rbindlist(QuadGram)
    QuadGram <- QuadGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    # QuadGram <- QuadGram[, j = list(freq), by = list(nmin1.gram, word)]
    
    QuadFreqCount <- QuadGram[j = list(count = .N), by = freq]
    QuadFreqCount <- QuadFreqCount[j = list(freq, count, freq_1 = freq + 1)]
    QuadFreqCount <- merge(QuadFreqCount, QuadFreqCount, by.x = "freq_1", by.y = "freq")[j = list(freq, count.x, count.y)]
    QuadFreqCount <- QuadFreqCount[i = freq <= x, j = list(count.x, count.y, freq_adj = (freq + 1)*(count.y/count.x)), by = freq]
    QuadFreqCount <- QuadFreqCount[key = "freq"]
    
    QuadGram <- QuadGram[QuadFreqCount, freq_adj:= freq_adj, on ="freq"]
    QuadGram[is.na(QuadGram$freq_adj)]$freq_adj <- QuadGram[is.na(QuadGram$freq_adj)]$freq
    QuadGram$wght_diff <- QuadGram$freq_adj*(log(QuadGram$freq/sum(QuadGram$freq))-log(QuadGram$freq_adj/sum(QuadGram$freq)))
    
    # saveRDS(QuadGram, paste("NGrams/Final_Quadgram ",start,"-",stop,".rds", sep = ""))
    return(QuadGram)

  }
  
}
  

UniGram <- consolidate_ngram(1,1,16)
BiGram <- consolidate_ngram(2,1,16, 150)
TriGram <- consolidate_ngram(3,1,16, 150)
QuadGram <- consolidate_ngram(4,1,16, 150)


# UniGram_test <- consolidate_ngram(1,17,20)
# BiGram_test <- consolidate_ngram(2,17,20, 150)
# TriGram_test <- consolidate_ngram(3,17,20, 150)
QuadGram_test <- consolidate_ngram(4,17,20, 150)
saveRDS(QuadGram_test, "NGrams/QuadGrams_test.rds")


## Prune N-grams

BiGram_Cutoff <- BiGram[BiGram$freq > 15, 1:4]
saveRDS(BiGram_Cutoff, "NGrams/BiGram_Cutoff.rds")

BiGram_WghtDiff <- BiGram[BiGram$wght_diff == 0 | BiGram$wght_diff > .75, 1:4]
saveRDS(BiGram_WghtDiff, "NGrams/BiGram_WghtDiff.rds") 


TriGram_Cutoff <- TriGram[TriGram$freq > 14, 1:4]
saveRDS(TriGram_Cutoff, "NGrams/TriGram_Cutoff.rds")

TriGram_WghtDiff <- TriGram[TriGram$wght_diff == 0 | TriGram$wght_diff > .96, 1:4]
saveRDS(TriGram_WghtDiff, "NGrams/TriGram_WghtDiff.rds") 


QuadGram_Cutoff <- QuadGram[QuadGram$freq > 7, 1:4]
saveRDS(QuadGram_Cutoff, "NGrams/QuadGram_Cutoff.rds")

QuadGram_WghtDiff <- QuadGram[QuadGram$wght_diff == 0 | QuadGram$wght_diff > 1.10625, 1:4]
saveRDS(QuadGram_WghtDiff, "NGrams/QuadGram_WghtDiff.rds") 

