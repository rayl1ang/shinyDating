library(DT)
library(shiny)
library(googleVis)

shinyServer(function(input, output){
  
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
      infoBox('Rank 1', act1, paste('Average score:',act_value1), color = 'green')
    }) 
    output$rank2Box <- renderInfoBox({
      act2 <- activities_reactive()[order(desc(activities_reactive()$average_score)),][2,2]
      act_value2 <- round(activities_reactive()[order(desc(activities_reactive()$average_score)),][2,3],2)
      infoBox('Rank 2', act2, paste('Average score:',act_value2), color = 'yellow')
    })
    
    output$rank3Box <- renderInfoBox({
      act3 <- activities_reactive()[order(desc(activities_reactive()$average_score)),][3,2]
      act_value3 <- round(activities_reactive()[order(desc(activities_reactive()$average_score)),][3,3],2)
      infoBox('Rank 3', act3, paste('Average score:',act_value3), color = 'purple')
    })
    
    # Logistic Regression
    
    ML_data <- reactive({
      SD_df[SD_df$gender == input$sex,]
    })
    
    train <- reactive({
      ML_data() %>% 
      select(26:32) %>% 
      slice(1:(nrow(ML_data())/2))
    })
    
    test <- reactive({
      ML_data() %>% 
      select(26:32) %>% 
      slice((nrow(ML_data())/2+1):nrow(ML_data()))
    })
    
    pred <- eventReactive(input$calc, {
      model <- glm(dec ~ ., family = binomial(link = "logit"), data = train())
      user_df <- data.frame(attr = as.integer(input$attr), sinc = as.integer(input$sinc),  
                            intel = as.integer(input$intel), fun = as.integer(input$fun), 
                            amb = as.integer(input$amb), shar = as.integer(input$shar))
      paste(round((predict(model, user_df, type='response') * 100), 2), '%')
    })
    
    output$date_prob <-  renderText(pred())
    
})