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

library(tidyverse)    # For the row_number and unite functions
library(shiny)        # For the UI and server-side app
library(shinythemes)  # For aesthetics
library(shinyWidgets) # For aesthetics
library(DT)           # For displaying the final output

################################################################################
###                           NOTES:                                         ###
################################################################################

# INPUT:
# A list of site codes (character)
# The number of subjects per site (integer)
# The randomization ratio (>= 1)
# Number of factors in your experiment (>= 0)

# OUTPUT:
# A sequential list of N codes inside a dataframe object
# An empty data vector for each factor

# For each site do the following:
# Store site in dataframe N times each
# Add numbers (1-K) to end of each site code in dataframe
# Randomly assign (T/C) to end of each site code in dataframe

# Assigning the numbers:
# Based on your row number for each site
# If less than 10, assign a "0" between the code and the number
# Otherwise, assign no space between the code and the number

# Randomization Ratio:
# Number of Treatment subjects == (N/(N+D))*NSubjects:
# Number of Control subjects == (NSubjects - TSubjects)
# (1, 1/2) , (2, 2/3), (3, 3/4), (4, 4/5), etc. = (n, n/n+1)

# If a negative number is input, it will take the absolute value of the input


# Sources:
"https://stackoverflow.com/questions/44504759/shiny-r-download-the-result-of-a-table"
"https://rdrr.io/cran/shinyWidgets/man/prettyCheckboxGroup.html"
"https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/"
"https://bookdown.org/rdpeng/RProgDA/error-handling-and-generation.html"
"https://www.datamentor.io/r-programming/for-loop/"

################################################################################
###                         Creating the Design Schema   
###
################################################################################

schema <- function(Sites = NULL, NSubjects, BlockSize = NULL, RRatio = NULL){
    
    ### Error-checking: ###
    # Unique site codes:
    test1 = any(duplicated(Sites)) # Test for duplicate sites
    if (test1 == TRUE){
        stop("Error: Please enter unique site codes")
    }
    # Non-positive number of subjects:
    test2 <- any(NSubjects <= 0)
    if (test2 == TRUE){
        stop("Error: Please enter a positive integer for the number of subjects per site")
    }
    # Improper Randomization Ratio:
    if (is.character(RRatio) == TRUE){ # Tests if RRatio is input as a string
        stop("Error: The randomization ratio must be a numeric data type")
    }
    
    test3 <- NSubjects*(RRatio/(RRatio+1))%%1 == 0 # Test if RRatio makes sense
    if (test3 == TRUE){
        stop("Error: The randomization ratio must adhere to NSubjects*(RRatio/RRatio+1)")
    }
    
    # Start with 2 empty data matrices:
    matt = matrix(NA, nrow = length(Sites), ncol = NSubjects) # [Sites.length, NSubjects]
    final = matrix(NA, nrow = length(Sites)*NSubjects, ncol = 1) # [Sites.length, 1]
    
    # Assign names to each column, otherwise you'll get an error:
    dimnames(matt) = list(Sites)
    
    # Assign letters to each subject @ each site:
    for (i in Sites){
        for (j in NSubjects){
            matt[i, ] = rep(i, times = NSubjects) # Row-wise assignment
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
    
    # Extracting different parts of the codes for easier reading:
    final["Code"] = final[,1]
    final["Site"] =  substr(final[, 1], 1, 3) # extract first three letters from code
    final["Subject"] =  gsub("[a-zA-Z]+", "", final[, 1]) # remove letters with regex
    final["Group"] = substr(final[, 1], nchar(final[, 1]), nchar(final[, 1]))
    
    # Remove the repeated column:
    final = final %>% select(Code, Site, Subject, Group)
    
    # Return the end result:
    return(final)
}
################################################################################
###                         Creating the User Interface                      ###
################################################################################

# Define UI for the data set viewer app --->
ui <- fluidPage(
    
    # Application theme --->
    theme = shinytheme("cerulean"),
        
    # App title --->
    titlePanel(title = "Project: Randomization Schema"),
    
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
            prettyCheckboxGroup(inputId = "Sites",
                               label = "Please select the sites you would like:",
                               choices = list("AAA", "BBB", "CCC", "DDD", "EEE", "FFF"),
                               selected = "AAA",
                               inline = TRUE,
                               icon = icon("check-square"),
                               animation = "pulse"),
            
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
                         label = "Please input the number of subjects per block",
                         value = 0),
            
            # Ownership
            tags$strong("Author: Matt Quinn",
                        tags$br(),
                        "Class: STA 635",
                        tags$br(),
                        "Date: 8/24/2020"),
            
            br(),
            
            # Instructions
            actionButton(
                inputId = "Instructions",
                label = "Instructions",
                icon = icon("cog"))
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Formatted text for caption ----
            h2(textOutput(outputId = "caption",
                          container = span)),
            
            # Output: HTML table with requested number of observations ----
            DT::dataTableOutput("table"),
            
            # Sources:
                # Written in HTML format
                # a() is for hyperlinks
            
            h2("References"),
                a("1. Table Options",
                  href = "https://stackoverflow.com/questions/44504759/shiny-r-download-the-result-of-a-table"),
            br(),
                a("2. Pretty Options",
                  href = "https://rdrr.io/cran/shinyWidgets/man/prettyCheckboxGroup.html"),
            br(),
                a("3. Shiny Tutorial",
                  href = "https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/"),
            br(),
                a("4. Error Handling in R",
                  href = "https://bookdown.org/rdpeng/RProgDA/error-handling-and-generation.html"),
            br(),
                a("5. FOR Loops in R",
                  href = "https://www.datamentor.io/r-programming/for-loop/"),
            br(),
                a("6. Substrings in R",
                  href = "https://statisticsglobe.com/r-extract-first-or-last-n-characters-from-string")

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
        BlockSize = input$BlockSize)})
    
    # Output the table
    output$table <- DT::renderDataTable({
            FINAL()}
    )

    # Instructions:
    observeEvent(input$Instructions, {
        show_alert(
            title = "Instructions",
            text =  p("1. Choose the sites you would like",
                      br(),
                      "2. Input the number of subjects per site",
                      br(),
                      "3. Input the randomization ratio in the form of a floating-point number",
                      br(),
                      "4. Input the number of subjects per block",
                      br(),
                      "Note: The program will update after each change you make automatically")
        )
    })
    
}

"Wrapping it all together:"
shinyApp(ui, server)
