library(shiny)

# Define UI for application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("NLP Next Word Prediction Based on Swiftkey Corpus"),
  
  # Sidebar with a slider input for filtering observations on field1
  sidebarPanel(
    selectInput("model_type", "Select Model to Employ:",
                list("Katz Backoff with Absolute Discount" = "kb",
                     "Katz Backoff with Good-Turing Discount" = "kbgt"
                     ), selected = "kb"),

      uiOutput("k_control"),
    # sliderInput("k", 
    #             "Adjust the absolute discount:", 
    #             min = 0,
    #             max = 1, 
    #             value = 0.5),
    
    textInput("text", "Type your text here:", 
              value = "Enter text..."),
    "Please type your text into the box above. Predictions are made as you type to 
    mimic the type of deployment typically seen on mobile devices."
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("About", 
               h4('Background:'),
               HTML('<p>This next word prediction application was developed as part of the capstone program for the <b>Johns Hopkins University Data Science Specialization.</b> The application leverages the English language elements of the SwiftKey corpus provided through Coursera.</p>'),
               
               br(),
               h4('The Algorithm:'),
               HTML('<p>To support the prediction, the Corpus was ingested, cleansed, and tokenized into Uni-Grams, Bi-Grams, Tri-Grams, and 4-Grams. The resulting dataset was far too large to support timely word prediction, so the resulting N-Gram tables were pruned based on the cutoff method. For this corpus, predictions made via these cutoff N-Gram tables actually outperformed predictions made using the Weighted-Difference method as elaborated <a href="https://pdfs.semanticscholar.org/6c8c/dff44ef74915a0276a7e1aba939eae7eefa7.pdf">here</a>.</p>'),
               HTML('<p>The underlying prediction algorithm is based on the <a href="http://www.cs.cornell.edu/courses/cs4740/2014sp/lectures/smoothing+backoff.pdf">Katz Backoff Model</a>. Users have the ability to choose between two smoothing implementations: an Absolute Discount (where k is adjustable) or the Good-Turing Discount. The algorithm itself returns a dataframe of the top 100 most likely words and their calculated probabilities based on the selected model parameters.</p>'),
               br(),
               h4('The Output:'),
               HTML('<p>When text is input into the box at left, the <b>Model Output</b> tab provides three unique ways to see the prediction.</p>'),
               HTML('<ol>'),
               HTML('<li>The next word with the highest probability in the output dataframe is appended directly onto the input text to display the full expected text string. </li>'),
               HTML('<li>The three next words with the highest probabilities in the output dataframe are each provided directly; think of this as the three predictions typically provided during text input on a modern smartphone. </li>'),
               HTML('<li>Finally, a WordCloud is provided to help visualize the predictions. The WordCloud will display all 100 most likely words from the output dataframe with the relative size of the words dependent on their predicted probability. This can be used to better understand the relative confidence of the algorithm in the predictions. </li>'),
               HTML('</ol>')
               
               ), 
    tabPanel(
      "Prediction Output",
      br(),
      h4('Your next word is:'),
      h4(verbatimTextOutput("sentence")),
      br(),
      h4('The three most likely next words are:'),
      h5(verbatimTextOutput("nextWord", placeholder = TRUE)),
      br(),
      h4('A visual representation of the most likely next word:'),
      plotOutput("plot")

    ))
)))