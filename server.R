# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # the dataframe
  df2 <- data.frame(psat = floor(runif(200,min=0,max=1190)),
                    name = rep("",200),
                    color="black") %>% 
    mutate(salary = 16*psat+4000*(psat>1200)-.004*psat*(psat>1000)+rnorm(200)*1500+35000)
  
  df3 <- data.frame(psat=floor(runif(100,min=1250,max=1600)),
                    name = rep("",100),
                    color="black") %>% 
    mutate(salary = 12*psat+4000*(psat>1200)-psat*(psat>1000)+rnorm(100)*1500+55000)
  
  taj <- data.frame(psat=c(850,1200,1250),name=c("Taylor","Alex","Jamie"),color="red",salary=c(45000,50000,75000))
  
  df4 <- rbind(df2,df3)
  df4 <- rbind(df4,taj)
  df4 <- df4[order(df4$psat),]
  df4 <- df4 %>% mutate(psatGroup = 0,mean_state = 0)
  
  data_with_means <- reactive({
    x <- bins()
    data <- df4
    if(input$bins == 0){return(data %>% mutate(mean_state=1))}
    
    # update means based on bins
    diff <- ifelse(length(x) > 1, x[2]-x[1],x)
    group <- 1
    
    for(i in x){
      data[data$psat >= (i-diff) & data$psat < i,]$psatGroup <- group
      group <- group+1
    }
    
    means <- data %>% group_by(psatGroup) %>% 
      mutate(salary = mean(salary),
             mean_state=1) %>% 
      ungroup()
    
    df4_with_means <- rbind(data,means)
    df4_with_means
  })
  
  # bins
  bins <- reactive({
    if(input$bins>=2){
      x <- 1:(input$bins - 1)
      x <- (x*floor(1600/input$bins))
    }
    else{x <- 1800}
    x
  })
  
  # Live plot
  output$distPlot <- renderPlot({
    nbins <- data.frame(bins=bins())
    
    plot <- ggplot(
      # data_with_means(),
      data_with_means()[data_with_means()$mean_state==1,],
                    aes(x=psat,
                        y=salary))+
      geom_point(aes(color=color))+
      geom_vline(aes(xintercept=1225),color='red')+
      geom_vline(data=nbins,aes(xintercept=bins),linetype='dashed')+
      scale_color_fivethirtyeight()+
      theme_fivethirtyeight()+
      geom_text(aes(label=name),vjust=2)+
      guides(size=FALSE,color=FALSE)+
      ylim(35000,80000)+
      xlim(100,1590)+
      ggtitle("PSAT Scores vs Starting Salary")
      # transition_states(states=mean_state)+
      # ease_aes('sine-in-out')+
      # exit_fade()+
      # enter_fade()
      # theme(axis.ticks.y = element_blank(),
      #       axis.title.y = element_blank(),
      #       axis.text.y = element_blank())
    
    plot
  })
  
  # .gif plot
  output$gif <- renderImage({
    list(src = paste("gifs/bin",input$bins,".gif",sep=""),
         contentType = 'image/gif'
         ,width = 720
         ,height = 480
         # alt = "This is alternate text"
    )
  },deleteFile = FALSE)
  
})
