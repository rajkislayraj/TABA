
if(!require(shiny)) {install.packages("shiny")}
if(!require(tm)) {install.packages("tm")}
if(!require(wordcloud)) {install.packages("wordcloud")}
if(!require(memoise)) {install.packages("memoise")}
if(!require(textdata)) {install.packages("textdata")}
if(!require(sentimentr)) {install.packages("sentimentr")}
if(!require(dplyr)) {install.packages("dplyr")}
library("shiny")
library("tm")
library("wordcloud")
library("memoise")
library("udpipe")
library("tidytext")
library("RColorBrewer")

shinyServer(function(input, output){
  
  data1 <- reactive({
    if(is.null(input$file))
      {return(NULL)}
    else
    {
      infile <- input$file
      dfr <- as.data.frame(read.csv(infile$datapath, header=TRUE, sep = ','))
      
      colmn = colnames(dfr)
      
      if ('Review' %in% colmn) 
        return(dfr) 
      else
        {
          return("Please load the correct csv file")
        }
    }
  })
  
  
  key_words <- reactive({
    if(is.null(input$keyword)) 
      {return(NULL)} 
    else
    {
      keywords <- tolower((as.character(strsplit(input$keyword,',')[[1]])))
      return(keywords)
    }
  })
  
 ################################## Content filtered on keyword ####################################### 
  
  output$content <- renderTable({
    
    df = data.frame(Review = tolower(as.character(data1()$Review)))
 
    withProgress(message = "Sentiment scoring in progress ....", value = 0, {
      final_df = df %>% select(Review)
      keywords = as.character(key_words())
      
      for (x in keywords){
        final_df$keyword = ifelse(grepl(x, df$Review),x,'null')
      }
      final_df<- final_df %>% filter(final_df$keyword !="null")
    })
    
    return(final_df)
    
    

    
  })

######################################## Word Cloud filtered on keyword #############################  
  
  output$plot <- renderPlot({
    
    df = data.frame(Review = tolower(as.character(data1()$Review)))
    #df = df[!duplicated(df),]
    
    
    withProgress(message = "Word Cloud in progress ....", value = 0, {
      final_df = df %>% select(Review)
      keywords = as.character(key_words())
      
      for (x in keywords){
        final_df$keyword = ifelse(grepl(x, df$Review),x,'null')
      }
      final_df<- final_df %>% filter(final_df$keyword !="null")
      tokens = word_tokens(final_df)
    })
  
   pal <- brewer.pal(8,"Dark2")  
   return(wordcloud(tokens$word,tokens$n,colors = pal))

  })
  
############################################ Histogram ####################################  
  
  output$myhist <- renderPlot({
   
    df = data.frame(Review = tolower(as.character(data1()$Review)))
  
    withProgress(message = "Word Cloud in progress ....", value = 0, {
      final_df = df %>% select(Review)
      keywords = as.character(key_words())
      
      for (x in keywords){
        final_df$keyword = ifelse(grepl(x, df$Review),x,'null')
      }
      final_df<- final_df %>% filter(final_df$keyword !="null")
      tokens = word_tokens(final_df)
    })
    
    return(bar_chart(tokens,"Top 20 words in this dataset"))
    
  },height = 800, width = 1000)
  
##############################################################################################  
  
  output$summ <- renderPrint({
    summary(input$file)
  })
  
  output$str <- renderPrint({
    str(input$file)
  })
  
 
  
}) 