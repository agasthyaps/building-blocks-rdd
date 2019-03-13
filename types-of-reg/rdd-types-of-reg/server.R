shinyServer(function(input, output) {
  
  # data frames
  poly_data <- data.frame(x=runif(100)*10) %>% 
    mutate(y=ifelse(x<5,(x-2.5)^2+5,-(x-7.75)^2+25)+rnorm(100,0,1.09),
           state = 0)
  
  means <- poly_data %>% 
    mutate(x = ifelse(x > 4 & x < 6, x, NA)) %>% 
    mutate(mean_group = case_when(
      x < 5 ~ 0,
      x > 5 ~ 1,
      TRUE ~ NA_real_
    ),
    state = 1) %>% group_by(mean_group) %>% 
    mutate(y = mean(y)) %>% 
    ungroup()
  
  # for effects
  poly_low <- predict(lm(formula = y~poly(x,2),poly_data[poly_data$x <5,]),
                      data.frame(x=5))[[1]]
  poly_hi <- predict(lm(formula = y~poly(x,2),poly_data[poly_data$x >5,]),
                     data.frame(x=5))[[1]]
  
  lin_low <- predict(lm(formula = y~x,poly_data[poly_data$x <5,]),
                     data.frame(x=5))[[1]]
  lin_hi <- predict(lm(formula = y~x,poly_data[poly_data$x >5,]),
                    data.frame(x=5))[[1]]
  
  avg_hi <- means[complete.cases(means) & means$mean_group==1,]$y[1]
  avg_low <- means[complete.cases(means) & means$mean_group==0,]$y[1]
  
  # store effects
  two_dig <- function(x) format(round(x,2),nsmall = 2)
  est_effs <- list(avg = two_dig(avg_hi-avg_low),
                   lin = two_dig(lin_hi-lin_low),
                   poly = two_dig(poly_hi-poly_low),
                   reg = " ")
  
  # plots
  regular <- ggplot(poly_data[poly_data$state == 0,],
                    aes(x=x,y=y))+
              geom_point()+
              xlim(0,10)+
              ylim(0,25)+
              geom_vline(aes(xintercept=5),linetype='dashed')+
              theme_fivethirtyeight()+
              theme(plot.background = element_rect(fill="#F7F7F7"),
                    panel.background = element_rect(fill="#F7F7F7"),
                    panel.grid.major = element_line(colour="#F7F7F7"),
                    legend.position = "none")
  
  poly_plot <- ggplot(poly_data[poly_data$state == 0,],
                      aes(x=x,y=y))+
                geom_point()+
                xlim(0,10)+
                ylim(0,25)+
                geom_vline(aes(xintercept=5),linetype='dashed')+
                geom_smooth(data = poly_data[poly_data$x <5,],method='lm',formula = y~poly(x,2),se=F)+
                geom_smooth(data = poly_data[poly_data$x >5,],method='lm',formula = y~poly(x,2),se=F)+
                theme_fivethirtyeight()+
                theme(plot.background = element_rect(fill="#F7F7F7"),
                      panel.background = element_rect(fill="#F7F7F7"),
                      panel.grid.major = element_line(colour="#F7F7F7"),
                      legend.position = "none")
  
  lin_plot <- ggplot(poly_data[poly_data$state == 0,],
                     aes(x=x,y=y))+
                geom_point()+
                xlim(0,10)+
                ylim(0,25)+
                geom_vline(aes(xintercept=5),linetype='dashed')+
                geom_smooth(data = poly_data[poly_data$x <5,],method='lm',formula = y~x,se=F)+
                geom_smooth(data = poly_data[poly_data$x >5,],method='lm',formula = y~x,se=F)+
                theme_fivethirtyeight()+
                theme(plot.background = element_rect(fill="#F7F7F7"),
                      panel.background = element_rect(fill="#F7F7F7"),
                      panel.grid.major = element_line(colour="#F7F7F7"),
                      legend.position = "none")
  
  avg_plot <- ggplot(means,
                     aes(x=x,y=y))+
                geom_point()+
                xlim(0,10)+
                ylim(0,25)+
                geom_vline(aes(xintercept=5),linetype='dashed')+
                theme_fivethirtyeight()+
                theme(plot.background = element_rect(fill="#F7F7F7"),
                      panel.background = element_rect(fill="#F7F7F7"),
                      panel.grid.major = element_line(colour="#F7F7F7"),
                      legend.position = "none")
  
  # store plots
  plots <- list(avg = avg_plot,
                lin = lin_plot,
                poly = poly_plot,
                reg = regular)
  
  # output
  output$plot <- renderPlot({
    plots[input$type]
  })
  
  output$explanation <- renderText({
    paste("Regression discontinuity doesn't always refer to a discontinuous straight line - sometimes it can be a discontinuous curve (or 'polynomial regression').<br>",
          "<br>Watch how the estimated effect changes as you change the method of analysis. Which method is best? Why?<br><br>")
  })
  
  output$esteffect <- renderText({
    paste("<h3>Estimated effect:",est_effs[input$type],"<h3>")
  })
})
