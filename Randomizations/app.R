"
Title: Randomization Schema
Author: Matt Quinn
Date: August 2nd 2020
Finished on: August 6th 2020
Class: STA 635 Consulting and Programming
"

setwd("C:/Users/miqui/OneDrive/Consulting/Randomizations")


################################################################################
###                           Necessary Libraries                            ###
################################################################################

library(shiny)
library(DT)
library(tidyverse)
library(shinythemes)

################################################################################
###                         Creating the Design Schema   
###
################################################################################
schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL, NFactors){
    
    ### Error-checking: ###
    # Unique site codes:
    test1 = any(duplicated(Sites))
    if (test1 == TRUE){
        stop("Error: Please enter unique site codes")
    }
    # Non-positive number of subjects:
    test2 <- any(NSubjects <= 0)
    if (test2 == TRUE){
        stop("Error: Please enter a positive integer for the number of subjects per site")
    }
    # Improper Randomization Ratio:
    if (is.character(RRatio) == TRUE){
        stop("Error: The randomization ratio must be a numeric data type")
    }
    
    test3 <- NSubjects*(RRatio/(RRatio+1))%%1 == 0
    if (test3 == TRUE){
        stop("Error: The randomization ratio must adhere to NSubjects*(RRatio/RRatio+1)")
    }
    
    # Improper number of factors:
    if (NFactors < 0){
        stop("Error: The number of factors must be greater than or equal to 0")
    }
    # Missing number of factors:
    if (is.null(NFactors)){
        stop("Please enter a numeric integer for the number of integers")
    }
    
    # Start with 2 empty data matrices:
    matt = matrix(NA, nrow = length(Sites), ncol = NSubjects)
    final = matrix(NA, nrow = length(Sites)*NSubjects, ncol = NFactors+1)
    
    # Assign names to each column, otherwise you'll get an error:
    dimnames(matt) = list(Sites)
    
    # Assign letters to each subject @ each site:
    for (i in Sites){
        for (j in NSubjects){
            matt[i, ] = rep(i, times = NSubjects) # Row-wise
        }
    }
    
    # Return the transpose of the matrix:
    matt = as.data.frame(t(matt)) # Turn into a dataframe as well
    
    # Adding the numbers to the end via a simple if-then-else statement
    for (column in matt){
        matt[column, ] = if_else(row_number(column) < 10,
                                 true = paste(column, "0", row_number(column), sep = ""),
                                 false = paste(column, row_number(column), sep = ""))
    }
    row.names(matt) = NULL # Just for aesthetics, no functional purpose
    
    #Select the first column & rows between [nrow(data) -> NSubjects]:
    matt = matt[NSubjects+1:(nrow(matt)-NSubjects), 1]
    
    # Calculating the number of T's and C's:
    for (i in (NSubjects+1)){ # +1 because it will drop off at NSubjects otherwise
        timesT = NSubjects*(RRatio/(RRatio+1))
        timesC = (NSubjects - timesT)
        TLC = data.frame(TorC = sample(t(rep(c("T", "C"), times = c(timesT, timesC)))))
    }
    # Repeat the process above for each site
    TLC = data.frame(TorC = rep(TLC$TorC, times = length(Sites)))
    
    # Shuffle the data randomly:
    matt = sample(matt)
    
    # Turn the data matrix into a data.frame:
    matt = as.data.frame(matt)
    
    # Concatenate both objects into a single dataframe
    result = data.frame(c(TLC, matt))
    
    # Use the "unite" function to concatenate both columns into a single column
    result = result %>% # using the pipe operator from the dplyr syntax
        unite(Codes, c("matt", "TorC"), sep = "")
    
    # For each column, append the result to the previously empty matrix above
    for(column in 0:1){
        final[, column] <- result[ , 1] # Copy only the first column 
    }
    
    # Turn into a dataframe:
    final <- as.data.frame(final)
    
    # Return the end result:
    return(final)
}
################################################################################
###                         Creating the User Interface                      ###
################################################################################

# Define UI for the data set viewer app ----
ui <- fluidPage(
    
    # Application theme --->
    theme = shinytheme("united"),
        
    # App title --->
    titlePanel(h1("Project: Randomization Schema")),
    
    # Sidebar layout with input and output definitions --->
    sidebarLayout(position = "left",
                  fluid = TRUE, # For mobile use
        
        # Sidebar panel for inputs --->
        sidebarPanel(
            
            # Input: Text for providing a caption --->
            # Note: Changes made to the caption in the textInput control
            # are updated in the output area immediately as you type
            textInput(inputId = "caption",
                      label = "Title:",
                      value = "Randomization Schema"),
            
            # Input: Check-box group for choosing site codes --->
            checkboxGroupInput(inputId = "Sites",
                               label = "Please select the sites you would like:",
                               choices = list("AAA", "BBB", "CCC", "DDD", "EEE"),
                               selected = "AAA"),
            
            # Input: Numeric entry for choosing the number of subjects per site --->
            numericInput(inputId = "NSubjects",
                         label = "Please input the number of subjects at each site:",
                         value = 10),
            
            # Input: Selector for choosing the randomization ratio --->
            numericInput(inputId = "RRatio",
                        label = "Choose a randomization ratio:",
                        value = 1),
            
            # Input: Numeric entry for choosing the block size ---> 
            numericInput(inputId = "BlockSize",
                         label = "Please input the block size:",
                         value = 0),
            
            # Input: Numeric entry for the number of factors --->
            numericInput(inputId = "NFactors",
                         label = "Please enter the number of factors:",
                         value = 0),
            
            tags$strong("Author: Matt Quinn",
                        tags$br(),
                        "Class: STA 635",
                        tags$br(),
                        "Date: 9/2/2020")
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Formatted text for caption ----
            h2(textOutput(outputId = "caption",
                          container = span)),
            
            # Output: HTML table with requested number of observations ----
            DT::dataTableOutput("table")

        )
    )
)

################################################################################
###                           Creating the Server Side                       ###
################################################################################

# Define server logic to summarize and view selected data set ----
server <- function(input, output, session){
    
    # Create caption ----
    # The output$caption is computed based on a reactive expression
    # that returns input$caption. When the user changes the
    # "caption" field:
    #
    # 1. This function is automatically called to recompute the output
    # 2. New caption is pushed back to the browser for re-display
    #
    # Note that because the data-oriented reactive expressions
    # below don't depend on input$caption, those expressions are
    # NOT called when input$caption changes
    output$caption <- renderText({
        input$caption
    })
    
    # Using the above inputs, put into a reactive environment the 
    # elements that you created above in the user interface
    
    FINAL <- reactive({schema(
        Sites = input$Sites,
        NSubjects = input$NSubjects,
        RRatio = input$RRatio,
        BlockSize = input$BlockSize,
        NFactors = input$NFactors)})
    
    # Output the table
    output$table <- DT::renderDataTable({
            FINAL()})
}



"Wrapping it all together:"
shinyApp(ui, server)
