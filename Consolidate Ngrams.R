

source("On Load.R")

consolidate_ngram <- function(x){
  
  if (x == 1){
    
    UniGram <- list()
    
    for (i in 1:16){
      
      UniGram[[i]] <- readRDS(paste("NGrams/UniGram",i,".rds", sep = ""))

      }
    
    UniGram <- rbindlist(UniGram)
    UniGram <- UniGram[, j = list(freq = sum(freq)),by = word]
    UniGram <- UniGram[, j = list(hashword = spooky.32(word), freq),by = list(word)]
    saveRDS(UniGram, "NGrams/Final_Unigram.rds")
    UniGram <- UniGram[order(freq)]
    Uni <- hashmap(UniGram$hashword, UniGram$word)
    save_hashmap(Uni, "NGrams/Uni")

  }
  
  if (x == 2){ 
    
    BiGram <- list()  
    
    for (i in 1:16){
    
      BiGram[[i]] <- readRDS(paste("NGrams/BiGram",i,".rds", sep = ""))

      }
    
    BiGram <- rbindlist(BiGram)
    BiGram <- BiGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    BiGram <- BiGram[, j = list(hashword = spooky.32(nmin1.gram), freq), list(nmin1.gram, word)]
    BiGram <- BiGram[,1:4] 
    saveRDS(BiGram, "NGrams/Final_Bigram.rds")
    BiGram <- BiGram[order(freq)]
    Bi <- hashmap(BiGram$hashword, BiGram$word)
    save_hashmap(Bi, "NGrams/Bi")

    

  }
  
  if (x == 3){
    
    TriGram <- list()
    
    for (i in 1:16){
    
      TriGram[[i]] <- readRDS(paste("NGrams/TriGram",i,".rds", sep = ""))

      }
    
    TriGram <- rbindlist(TriGram)
    TriGram <- TriGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    TriGram <- TriGram[, j = list(hashword = spooky.32(nmin1.gram), freq), list(nmin1.gram, word)]
    TriGram <- TriGram[,1:4]
    saveRDS(TriGram, "NGrams/Final_Trigram.rds")
    TriGram <- TriGram[order(freq)]
    Tri <- hashmap(TriGram$hashword, TriGram$word)
    save_hashmap(Tri, "NGrams/Tri")
    
  }
  
  if (x == 4){
    
    QuadGram <- list()
    
    for (i in 1:16){
      
      QuadGram[[i]] <- readRDS(paste("NGrams/QuadGram",i,".rds", sep = ""))

      }
    
    QuadGram <- rbindlist(QuadGram)
    QuadGram <- QuadGram[, j = list(freq = sum(freq)),by = list(nmin1.gram, word)]
    QuadGram <- QuadGram[, j = list(hashword = spooky.32(nmin1.gram), freq), list(nmin1.gram, word)]
    QuadGram <- QuadGram[,1:4]
    saveRDS(QuadGram, "NGrams/Final_Quadgram.rds")
    QuadGram <- QuadGram[order(freq)]
    Quad <- hashmap(QuadGram$hashword, QuadGram$word)
    save_hashmap(Quad, "NGrams/Quad")
    
    
  }
  
}
  

consolidate_ngram(1)
consolidate_ngram(2)
consolidate_ngram(3)
consolidate_ngram(4)

  
# UniGram <- readRDS("NGrams/Final_UniGram.rds")
# BiGram <- readRDS("NGrams/Final_BiGram.rds")
# TriGram <- readRDS("NGrams/Final_TriGram.rds")
# QuadGram <- readRDS("NGrams/Final_QuadGram.rds")


