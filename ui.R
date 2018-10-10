library(DT)
library(shiny)
library(shinydashboard)


shinyUI(dashboardPage(
    dashboardHeader(title = 'Dating Dashboard'),
    dashboardSidebar(
        sidebarMenu(
            selectInput("sex", h5("Select Your Sexual Preference"), 
                        choices = list("Female" = 'Female', "Male" = 'Male')), 
            menuItem("Favorite Activities", tabName = "activity", icon = icon("soccer-ball-o")),
            menuItem("Dating Calculator", tabName = "calculator", icon = icon("calculator"))
        )
    ),
    dashboardBody(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
      ),
      tabItems(
        tabItem(tabName = "activity",
                fluidRow(infoBoxOutput("rank1Box"),
                         infoBoxOutput("rank2Box"),
                         infoBoxOutput("rank3Box")),
                fluidRow(box(plotOutput("activ_bar"), height = 400, width = 300))
        ),
        tabItem(tabName = "calculator",
                fluidRow(h3(strong('Calculate Your Percentage of Landing a Date!'), align = 'center'), 
                         br()),
                fluidRow(box(title = "Please rate yourself on the following attributes:",
                             selectInput('attr', "Attractiveness", 
                                            choices = 10:1),
                             selectInput('sinc', "Sincerity", 
                                            choices = 10:1),
                             selectInput('intel', "Intellect", 
                                            choices = 10:1),
                             selectInput('fun', "Fun", 
                                            choices = 10:1),
                             selectInput('amb', "Ambitious", 
                                            choices = 10:1),
                             selectInput('shar', "Shared Interest/Hobbies", 
                                            choices = 10:1), 
                             actionButton('calc', label = 'Calculate'), height = 600),
                         
                          box(title = h3("Your percentage of landing a date is: ",align='center'),
                              br(),br(), br(), 
                              h1(strong(textOutput("date_prob")), align = 'center'),
                              br(),br(), br(), 
                              img(src="Menu_photo.JPG"),
                              height = 600
                              )))
      )
    )
))
