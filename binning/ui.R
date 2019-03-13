
  fluidPage(
    titlePanel("Bandwidth and Effect Size"),
    sidebarLayout(
      sidebarPanel(
        # p("We've already seen that dividing the data into two large groups - those who got the scholarship and those who didn't - doesn't help."),
        # p("Play with the slider to see how dividing the data into more groups - or 'bins' - changes the means. What do you notice? Which group of means should we compare?"),
        htmlOutput("explanation"),
        chooseSliderSkin("Modern"),
        tags$head(tags$style(HTML('.irs-from, .irs-to, .irs-min, .irs-max, .irs-single {
            visibility: hidden !important;
                                  }'))),
        sliderInput("bins",
                    label= NULL,
                    min = 0,
                    max=9,
                    value = 0,
                    ticks = FALSE),
        htmlOutput("effect")
      ),
      mainPanel(
        imageOutput("gif")
      )
    )

  )