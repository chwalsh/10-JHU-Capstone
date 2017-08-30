
shinyServer(function(input, output) {

  output$k_control <- renderUI({
    
    
    if (input$model_type == "kb"){
    sliderInput("k", 
                "Adjust the absolute discount:", 
                min = 0,
                max = 1, 
                value = 0.5)
    }
    })
  
  out <- reactive({
    if(input$text != "Enter text..."){
      print("thinking..")
    if (input$model_type == "kb"){
    nextWord <- katz_quad(input$text, input$k)
    }
    else if (input$model_type == "kbgt"){
      nextWord <- katzgt_quad(input$text)
    }}
  })
  

    
  output$text_in <- renderText(input$text)
  output$sentence <- renderText(paste(input$text, out()$word[1], sep = " "))
  output$nextWord <- renderText(out()$word[1:3])


  output$plot <- renderPlot({
    if(input$text != "Enter text..."){
    wordcloud(out()$word, out()$prob, max.words = 100, random.order = FALSE,
              colors=brewer.pal(8, "Dark2"))
    }
  }, res = 130)
    
  
})