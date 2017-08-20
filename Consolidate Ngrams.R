

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
    saveRDS(QuadGram, "NGrams/Final_Quadgram.rds")
    return(QuadGram)

  }
  
}
  

UniGram <- consolidate_ngram(1)
BiGram <- consolidate_ngram(2)
TriGram <- consolidate_ngram(3)
QuadGram <- consolidate_ngram(4)

# BiGram <- BiGram[j = list(freq_grp = as.factor(freq)), by = list(nmin1.gram, word, freq)]
# BiFreqCount <- BiGram[j = list(count = count(freq_char)), by = freq_grp]
