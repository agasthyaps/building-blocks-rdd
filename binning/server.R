shinyServer(function(input, output) {
  
  #est_effect
  est_effects <- c("26,187.33","25,488.84", "24,533.01", "23,351.44", "22,586.52", "21,443.84", "20,615.70", "19,490.26", "18,173.32", "17,180.24")
  
  # .gif plot
  output$gif <- renderImage({
    list(src = paste("gifs/bin",input$bins,".gif",sep=""),
         contentType = 'image/gif'
         ,width = 720
         ,height = 480
         # alt = "This is alternate text"
    )
  },deleteFile = FALSE)
  
  # effect
  output$effect <- renderText({
    paste("<h4>Estimated effect (difference in means): $",est_effects[input$bins+1],"</h4>",sep="")
  })
  
  output$explanation <- renderText({
    paste("We've already seen that dividing the data into two large groups - <strong>all</strong> people who got the scholarship and <strong>all</strong> people who didn't - doesn't help.<br><br>",
          "Play with the slider to see how narrowing our comparison window (or bandwidth) changes both the means and the difference in means - also known as an <i>estimated effect</i>.<br><br>",
          "What do you notice? What do you think the optimal bandwidth is?")
  })
  
})
