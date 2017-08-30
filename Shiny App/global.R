
source("Shiny Load.R")

# load dataset
dataLoadComplete=FALSE
print("loading data")

UniGram <- readRDS("UniGram_Cutoff.rds")
BiGram <- readRDS("BiGram_Cutoff.rds")
TriGram <- readRDS("TriGram_Cutoff.rds")
QuadGram <- readRDS("QuadGram_Cutoff.rds")

dataLoadComplete=TRUE
print("N-Grams loaded")