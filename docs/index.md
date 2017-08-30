---
title: 'Data Science Capstone'
subtitle    : 'Next Word Prediction with the SwiftKey Corpus'
author      : "Chris Walsh"
job         : "August 31, 2017"
framework   : revealjs      # {io2012, html5slides, shower, dzslides, ...}
revealjs    :
  theme: night
  transition: convex
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
.reveal p {
    font-size: .75em;
}

.reveal small {
    width: 500px;
}

.reveal .slides {
    text-align: left;
}

.reveal .roll {
    vertical-align: text-bottom;
}

code {
    color: red;
}

.reveal pre code { 
     height: 250px;
}

.reveal section img { 
  background:none; 
  border:none; 
  box-shadow:none; 
  }
  
</style>







## The Use Case

In today's mobile world, Natural Langague Processing (NLP) is all around us. This Data Science Capstone, administered in concert with **SwiftKey**, is focused on the development of an NLP model capable of predicting the next word in a text string based on the provided SwiftKey [English language corpus](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). 
<br>
<br>
 
### The Links

Several products were developed to support this Capstone. They can be found below:

1. The Milestone Report: [link here](http://rpubs.com/cwalsh/300582)

2. The Next Word Prediction Shiny application: [link here](https://cwalsh.shinyapps.io/data_science_capstone_next_word_prediction/)

3. The Presentation: [link here](https://cwalsh.shinyapps.io/data_science_capstone_next_word_prediction/)

4. The Code: [link here](https://github.com/chwalsh/10-JHU-Capstone)


---


## The Algorithm



Several steps were taken in order to develop the underlying NLP model:

* The Corpus was ingested and cleansed using `tm` and `stringi`; this process included: converting characters to a standard encoding;  transforming to lowercase; and stripping punctuation, numbers, and excess whitespace 

* The Corpus was tokenized into N-Grams using `RWeka`; for the purpose of this model, UniGrams, BiGrams, TriGrams, and 4-Grams were developed

* The **Good-Turing discount** was calculated based on N-Gram frequencies to smooth the eventual model[^1](http://www.cs.cornell.edu/courses/cs4740/2014sp/lectures/smoothing+backoff.pdf)

* A simple **Katz Backoff model** was developed based on these adjusted N-Gram frequencies to estimate the probability of each potential next word[^2](http://www.cs.cornell.edu/courses/cs4740/2014sp/lectures/smoothing+backoff.pdf)

* To optimize for performance on the Shiny server, the underlying N-Gram frequency tables were pruned; both **cutoff** and **weighted difference** methods were tested, with better model performance (12.53% accuracy) at the desired frequency `data.table` size observed via the **cutoff** method[^3](https://pdfs.semanticscholar.org/6c8c/dff44ef74915a0276a7e1aba939eae7eefa7.pdf)


---

## The App


This algorithm was then deployed via a [Shiny app](https://cwalsh.shinyapps.io/data_science_capstone_next_word_prediction/). When text is input into the box, the Model Output tab provides three unique ways to interact with the model output:

1. The next word with the highest probability is appended directly onto the input text to display the full expected text string

2. The three next words with the highest probabilities are displayed; think of this as the three predictions typically provided during text input on a mobile device

3. A WordCloud is displayed based on the probabilities of the top 100 most likely next words

<img src="figures/NLP.png" title="plot of chunk image" alt="plot of chunk image" height="400px" style="display: block; margin: auto;" />


---


## Next Steps

* As the intial exploratory analysis shows, *context matters*; N-Gram frequencies differ across blog, twitter, and news corpora. While all three sources are consolidated in the underlying model, greater accuracy could potentially be gained by dynamically selecting corpora sources based on application.

* 80% of the overall corpus was initially used to train the model, however this resulted in final frequency tables of approximately **800 MB**. Memory considerations required pruning down to approximately **12 MB** to deploy at the desired speed on a Shiny server. While some testing was performed to select a pruning method, additional techniques can be explored to further minimize accuracy loss.

* Good-Turing discounting was implemented to help smooth the model as it outperformed a simple absolute discount initially used; additional methods, including Kneser-Key, could potentially be explored to further refine model accuracy.

* The app could be updated to dynamically update the underlying frequency tables based on user input; this would allow the model to "learn" from repeated use.


