"Toggle Instructions:"

ui <- fluidPage(
        actionButton(
          inputId = "Instructions",
          label = "Instructions",
          icon = icon("cog"))
        )

server <- function(input, output, session) {
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
  
shinyApp(ui, server)
