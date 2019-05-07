library(shiny)
library(shinydashboard, warn.conflicts = FALSE)
library(rsconnect, warn.conflicts = FALSE)
library(googlesheets)
library(googledrive)
library(shinyWidgets)

#rsconnect::showLogs() -> pour verifier pb sur web
#gs_auth(token = "shiny_app_token.rds")

ui <- (
  dashboardPage(skin = "green",
                dashboardHeader(title = "MakeMailDay", titleWidth = 230),
                
                dashboardSidebar(
                  
                  sidebarMenu(
                    menuItem(text = "About", tabName = "about", icon=icon("clipboard")),
                    menuItem("Contribute", tabName = "Contribute", icon=icon("ad")),
                    menuItem("Stay informed", icon = icon("bar-chart-o"), startExpanded = F,
                             menuSubItem("First floor", tabName = "First_floor"),
                             menuSubItem("Second floor", tabName = "Second_floor")),
                    menuItem("Ranking", tabName = "Ranking", icon=icon("arrow-alt-circle-down")),
                    menuItem(""),
                    menuItem(""),
                    menuItem(""),
                    menuItem("More", icon = icon("plus"), startExpanded = F,
                             menuSubItem("Find documents",  href = "https://www.unige.ch/biblio/fr/trouver-des-documents/"),
                             menuSubItem("Work booths",  href = "https://rdm.unige.ch/cabine/unimail-groupe/SitePages/Cabines%20de%20groupe.aspx")),
                    menuItem("Available on Android",  href = "https://mega.nz/#!XOJk1IDR!pzJkRwJKIrkDIzRemmF3fh3LRVV9LZfq4Y9RftFgo3M", icon = icon("android"), badgeLabel = "β", badgeColor = "green"),
                    # https://fontawesome.com/icons?d=gallery
                  )
                ),
                #----------------------------------------------------------------------------------
                #----------------------------------------------------------------------------------
                
                dashboardBody(
                  # within tabitems(), define the pages for sidebar menu items
                  tabItems(
                    tabItem(tabName = "about",h3("Welcome to MakeMailDay"),
                            column(width=6 ,p("MakeMailDay is a contributive and a data access platform dedicated to Uni Mail students. It allows everyone to share their impressions on each section of the library. You can also use MakeMailDay to make daily efficient decisions. MakeMailDay is a place to share and a tool to understand the distribution and habits of individuals within the library. In a second step, MakeMailDay plays an optimizing role in the sense that it tends to homogenize the dispersion of the users, to the great pleasure of each one.")),
                            column(width=6 ,htmlOutput("video"))),
                    tabItem(
                      
                      tabName = "Contribute",
                      column(width=6 ,
                             selectInput("section", label = h3("Where are you ?"), list(
                               "First floor" = c("Droit" = "1st floor Droit - 1st",
                                                 "Sciences économiques et sociales" = "1st floor Sciences économiques et sociales - 1st",
                                                 "Psychologie et science de l'éducation" = "1st floor Psychologie et science de l'éducation - 1st",
                                                 "Espace presse" = "1st floor Espace presse - 1st"),
                               "Second floor" = c("Droit" = "2nd floor Droit - 2nd",
                                                  "Relation internationales" = "2nd floor Relation internationales - 2nd",
                                                  "Sciences sociales" = "2nd floor Sciences sociales - 2nd",
                                                  "Economie, Finance et management" = "2nd floor Economie, Finance et management - 2nd",
                                                  "Espace audiovisuel" = "2nd floor Espace audiovisuel - 2nd",
                                                  "Traduction" = "2nd floor Traduction - 2nd")
                             )),
                             
                             h3("How is it ?"),
                             #“Shiny”, “Flat”, “Modern”, “Nice”, “Simple”, “HTML5”, “Round”, “Square”
                             chooseSliderSkin("Flat"),
                             setSliderColor(c("#00a65a"), c(1)),
                             sliderInput(inputId = 'integer', 
                                         label = div(style='width:300px;', 
                                                     div(style='float:left;', 'Desert'), 
                                                     div(style='float:right;', 'Full')),
                                         min = 1, max = 4,
                                         value = 2.5, step = 0.1, width = '300px'),
                             
                             actionButton("submit", "MakeOurDay",icon = icon("paper-plane"))
                             
                      ),
                      
                      
                      column(width=6 , plotOutput("map"))
                      
                    ),
                    #----------------------------------------------------------------------------------
                    #----------------------------------------------------------------------------------
                    
                    tabItem(
                      
                      tabName = "First_floor",
                      h1("The sections of the first floor", style="color:#008d4c;"),
                      tabsetPanel(
                        tabPanel(actionButton("submit2a", "Droit", icon=icon("balance-scale")), plotOutput("hist1"), plotOutput("hist1hist")),
                        tabPanel(actionButton("submit2b", "Sciences économiques et sociales", icon=icon("share-alt")), plotOutput("hist2"), plotOutput("hist2hist")),
                        tabPanel(actionButton("submit2c", "Psychologie et science de l'éducation", icon=icon("brain")), plotOutput("hist3"), plotOutput("hist3hist")),
                        tabPanel(actionButton("submit2d", "Espace presse", icon=icon("newspaper")), plotOutput("hist4"), plotOutput("hist4hist"))
                      )
                      
                    ),
                    #----------------------------------------------------------------------------------
                    #----------------------------------------------------------------------------------
                    
                    tabItem(
                      
                      tabName = "Second_floor",
                      h1("The sections of the second floor", style="color:#008d4c;"),
                      tabsetPanel(
                        tabPanel(actionButton("submit2e", "Droit", icon=icon("balance-scale")), plotOutput("hist5"), plotOutput("hist5hist")),
                        tabPanel(actionButton("submit2f", "Relation internationales", icon=icon("globe")), plotOutput("hist6"), plotOutput("hist6hist")),
                        tabPanel(actionButton("submit2g", "Sciences sociales", icon=icon("users")), plotOutput("hist7"), plotOutput("hist7hist")),
                        tabPanel(actionButton("submit2h", "Economie, Finance et management", icon=icon("chart-line")), plotOutput("hist8"), plotOutput("hist8hist")),
                        tabPanel(actionButton("submit2i", "Espace audiovisuel", icon=icon("headphones-alt")), plotOutput("hist9"), plotOutput("hist9hist")),
                        tabPanel(actionButton("submit2j", "Traduction", icon=icon("language ")), plotOutput("hist10"), plotOutput("hist10hist"))
                      )
                      
                    ),
                    
                    #----------------------------------------------------------------------------------
                    #----------------------------------------------------------------------------------
                    
                    tabItem(
                      
                      tabName = "Ranking",
                      
                      div(style="display:inline-block;width:100%;text-align: center;",actionButton("submit3", h3("Rank-it !", style="color:#000000;"), icon = icon("arrow-alt-circle-down"))),
                      valueBoxOutput("top1"),
                      valueBoxOutput("top2"),
                      valueBoxOutput("top3"),
                      tableOutput("ranking")
        )
      )
    )
  )
)