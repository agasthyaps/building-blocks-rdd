
  fluidPage(
    titlePanel("Binning and Comparing Means"),
    sidebarLayout(
      sidebarPanel(
        p("We've already seen that dividing the data into two groups - those who got the scholarship and those who didn't - doesn't help."),
        p("Play with the slider to see how dividing the data into more groups - or 'bins' - changes the means. What do you notice? Which group of means should we compare?"),
        chooseSliderSkin("Modern"),
        sliderInput("bins",
                    "number of bins:",
                    min = 3,
                    max=25,
                    value = 3)
      ),
      mainPanel(
        imageOutput("gif")
      )
    )

  )