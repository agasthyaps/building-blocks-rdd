shinyUI(fluidPage(
  
  # Application title
  titlePanel("Methods of Estimating Effect"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      htmlOutput("explanation"),
      selectInput("type", "Select Estimation Method",
                  choices = c(" " = "reg",
                              "Compare means" = "avg",
                              "Linear Regression" = "lin",
                              "Polynomial Regression" ="poly")),
      htmlOutput("esteffect")

    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("plot")
    )
  )
))
