shinyServer(function(input, output, session){
  
    #show activities horizontal bar chart
    activities_reactive <- reactive({
      activities_df %>% 
        filter(gender == input$sex)
    })
    
    
    output$activ_bar <- renderPlot({
      activities_reactive() %>% 
        ggplot(aes(x=reorder(activities, average_score), y=average_score, fill = fill_color)) +
        geom_bar(position = 'dodge', stat = 'identity') + coord_flip() + 
        theme(plot.subtitle = element_text(vjust = 1), 
              plot.caption = element_text(vjust = 1), 
              axis.title = element_text(size = 13, face = 'bold', colour = 'gray36'),
              panel.background = element_rect(fill = "azure2"),
              plot.title = element_text(size = 16, 
                                        face = "bold", hjust = 0.5, colour = "gray38"),
              axis.text.x = element_text(size = 11), 
              axis.text.y = element_text(size = 11)) +
        labs(title = "Average Score of Activities", 
             x = "Activities", y = "Average Score") +
        scale_fill_identity()
    })

    # show statistics using infoBox
    output$rank1Box <- renderInfoBox({
      act1 <- activities_reactive()[order(desc(activities_reactive()$average_score)),][1,2]
      act_value1 <- round(activities_reactive()[order(desc(activities_reactive()$average_score)),][1,3],2)
      infoBox('Rank 1', act1, paste('Average score:',act_value1), color = 'green', fill = T)
    }) 
    output$rank2Box <- renderInfoBox({
      act2 <- activities_reactive()[order(desc(activities_reactive()$average_score)),][2,2]
      act_value2 <- round(activities_reactive()[order(desc(activities_reactive()$average_score)),][2,3],2)
      infoBox('Rank 2', act2, paste('Average score:',act_value2), color = 'yellow', fill = T)
    })
    
    output$rank3Box <- renderInfoBox({
      act3 <- activities_reactive()[order(desc(activities_reactive()$average_score)),][3,2]
      act_value3 <- round(activities_reactive()[order(desc(activities_reactive()$average_score)),][3,3],2)
      infoBox('Rank 3', act3, paste('Average score:',act_value3), color = 'purple', fill = T)
    })
    
    
    #Frequency Stats by Career
    career_gender <- reactive({
      career_df %>% 
        filter(gender == input$sex) %>% 
        filter(career == input$career)
    })
    
    observe({
       career_observe<- unique(career_df %>% 
                               filter(gender == input$sex) %>% 
                               .$career)
      updateSelectInput(
        session, "career",
        choices = career_observe,
        selected = career_observe[1])
    })
    
    output$facet_freqplot <- renderPlot({
      datingFreq_facet
    })
    
    output$freqPlot <- renderPlot({
      temp <- ggplot(career_gender(),aes(go_out, date)) +
        geom_jitter(color = career_gender()$fill_color ) +
        theme(plot.subtitle = element_text(vjust = 1), 
              plot.caption = element_text(vjust = 1), 
              axis.title = element_text(colour = "gray28", size = 13),
              axis.text = element_text(size = 11),
              plot.title = element_text(face = "bold", 
                                        colour = "gray28",
                                        hjust = 0.5)) +
        labs(x = "Outdoor Activity Frequency", y = "Dating Frequency",
             title = paste("Dating vs Outdoor Activities \n Frequencies by Career")) + 
        scale_x_continuous(breaks=seq(1,7,1)) + 
        scale_y_continuous(breaks=seq(1,7,1))
      
      ggExtra::ggMarginal(
        p = temp,
        type = 'density',
        margins = 'both',
        size = 5,
        colour = '#A69191',
        fill = 'gray'
      )
    })
    
    # Logistic Regression
    
    ML_data <- reactive({
      SD_df[SD_df$gender == input$sex,]
    })
    
    train <- reactive({
      ML_data() %>% 
      select(dec:shar) %>% 
      slice(1:(nrow(ML_data())/2))
    })
    
    test <- reactive({
      ML_data() %>% 
      select(dec:shar) %>% 
      slice((nrow(ML_data())/2+1):nrow(ML_data()))
    })
    
    user_df <- eventReactive(input$calc, {
      data.frame(attr = as.integer(input$attr), sinc = as.integer(input$sinc),  
                 intel = as.integer(input$intel), fun = as.integer(input$fun), 
                 amb = as.integer(input$amb), shar = as.integer(input$shar))
    })
    
    pred <- eventReactive(input$calc, {
      model <- glm(dec ~ ., family = binomial(link = "logit"), data = train())
      paste(round((predict(model, user_df(), type='response') * 100), 2), '%')
    })

    #render SpiderChart
    output$spiderchart <- renderPlot({
      
      user_df_initial <- data.frame(attr = 0, sinc = 0, 
                                    intel = 0, fun = 0, 
                                    amb = 0, shar = 0)
      
      #adding upper/lower bounds to radarchart
      user_df_bounds <- if(input$calc == 0) {
                               rbind(rep(10,6) , rep(0,6) , user_df_initial)
                               } else (rbind(rep(10,6) , rep(0,6) , user_df()))
      
      #renaming columns to better match descriptions for final chart
      colnames(user_df_bounds) <- c('Sincerity','Attractiveness','Intellect',
                                    'Fun','Ambitious','Shared Interest')
      
      radarchart(user_df_bounds, axistype = 1,
                 #custom the grid
                 cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,10,2.5),
                 #custom polygon
                 pcol=rgb(0.2,0.8,0,0.9), pfcol=rgb(0.2,0.8,0,0.4) , plwd=2 , plty=1)
    })
    
    output$date_prob <-  renderText({
                              if (input$calc == 0) {
                                as.character('?')
                              } else (pred()) 
      })
    
})