library("shiny")
library("tm")
library("wordcloud")
library("memoise")

shinyUI(fluidPage(
  
  titlePanel("TABA Assignment"),
  
  sidebarLayout(
    sidebarPanel("Enter the project information",
                 fileInput("file", "Upload data (csv file with header)"),
                 textInput("keyword", "Enter single keyword to extract","")
                 ),
    mainPanel("Text Analysis Project Information",
              tabsetPanel(type="tabs", 
                          tabPanel("App Overview", 
                                   h4(p("Please follow the steps below to run this application for text analysis over the car reviews")),
                                   p("To use this app you need a csv file with at least 2 columns with one column name as Review \n\n ", align = "justify"),
                                   
                                   p("First Step : upload the csv file using the Upload data in left-sidebar panel.\n\n", align = "justify"),
                                   p("Second Step: Enter the keyword or the feature for which you want the reviews to be filtered out. \n\n Please ensure that a single keyword is fed an an input everytime to run the app for the filetred keyword.\n\n ", align = "justify"),
                                   
                                   p("Once the csv and keyword is fed into the application, the shinyapp will produce - Filtered Reviews, Histogram and Word Cloud in the various tabs.", align = "justify")),
                          
                          
                          
                          tabPanel("Filtered Reviews with Keyword", tableOutput("content")),
                          tabPanel("Raw File Details", verbatimTextOutput("str")),
                          tabPanel("Histogram", plotOutput("myhist")),
                          tabPanel("Word Cloud", plotOutput("plot"))
                          
                          
                          )
              )
    
  )
)
)