library(shiny)
library(shinydashboard, warn.conflicts = FALSE)
library(rsconnect, warn.conflicts = FALSE)
library(googlesheets)
library(googledrive)
library(shinyWidgets)

#rsconnect::showLogs() -> pour verifier pb sur web
gs_auth(token = "shiny_app_token.rds")

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
                    menuItem("Available on Android",  href = "https://mega.nz/#!XOJk1IDR!pzJkRwJKIrkDIzRemmF3fh3LRVV9LZfq4Y9RftFgo3M", icon = icon("android"), badgeLabel = "β", badgeColor = "green")
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
#----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------


#----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------
server <- function(input, output, session){
  
  output$video <- renderUI({
    #tags$iframe(src = "https://www.youtube.com/embed/G9YHgGHyrlk", width = 350, height = 500)
    HTML(paste('<iframe width="300" height="530" src="https://www.youtube.com/embed/FM9I9nz_r_s?rel=0&controls=0&showinfo=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))
  })
  
  my_sheets <- gs_ls()
  my_sheets <- my_sheets$sheet_title
  
  initialization <- t(c(1,8))
  colnames(initialization) <- c("Note","Heure")
  initialization <- as.data.frame(initialization)
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Droit - 1st"))<1){
    
    showNotification("You are the first user of the day! So you have to wait for the initialization of the daily matrices.", duration = 10)
    showNotification("Wait for the end of the 10 steps", duration = 10)
    
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Droit - 1st"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 1/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Sciences économiques et sociales - 1st"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Sciences économiques et sociales - 1st"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 2/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Psychologie et science de l'éducation - 1st"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Psychologie et science de l'éducation - 1st"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 3/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Espace presse - 1st"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Espace presse - 1st"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 4/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Droit - 2nd"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Droit - 2nd"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 5/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Relation internationales - 2nd"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Relation internationales - 2nd"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 6/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Sciences sociales - 2nd"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Sciences sociales - 2nd"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 7/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Economie, Finance et management - 2nd"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Economie, Finance et management - 2nd"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 8/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Espace audiovisuel - 2nd"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Espace audiovisuel - 2nd"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 9/10 ✔ - Initialization")
  }
  
  if (sum(my_sheets == paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Traduction - 2nd"))<1){
    
    mat <- gs_new(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Traduction - 2nd"))
    gs_edit_cells(mat, input = initialization, trim = TRUE)
    
    showNotification("Step 10/10 ✔ - Initialization")
    showNotification("The matrices have been initialized, enjoy.")
    
  }
  
  observeEvent(input$submit, {                                                                 
    if (as.numeric(noquote(format(Sys.time(), tz = "Europe/Zurich", "%H")))>=8 && as.numeric(noquote(format(Sys.time(), tz = "Europe/Zurich", "%H")))<23){
      valeur <- t(c(input$integer, as.numeric(noquote(format(Sys.time(), tz = "Europe/Zurich", "%H")))))
      name <- paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),input$section)
      name2 <- paste(input$section)
      
      be <- gs_title(name)
      showNotification("Loading...")
      gs_add_row(be, ws = 1, input = valeur[1:2])
      be2 <- gs_title(name2)
      gs_add_row(be2, ws = 1, input = valeur[1:2])
      showNotification("Thank you ! Your contribution has been taken into account.",
                       action = a(href = "javascript:location.reload();", "Reload page"))
    }else{showNotification("To contribute, come back between 8:00 and 23:00. See you soon :)", duration = 10, closeButton = TRUE, type = "message")}
  })
  
  #----------------------------------------------------------------------------------
  #First floor
  #----------------------------------------------------------------------------------
  
  observeEvent(input$section, {
    if(input$section=="1st floor Droit - 1st"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),cex=0, ylab = "", axes=FALSE, xlab = "", main = "First floor")
        lines(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),col="black")
        text(c(1.37,1.37), c(1.01,2), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        #------couleur droit------#
        polygon(c(1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29),c(1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.94) , density = NULL, angle = 45,
                border = NULL, col = "#e83d38", lty = par("lty"), fillOddEven = FALSE)
        #-----patio bloc 0-----#
        lines(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.1825,1.68, "Block 0", cex=0.7, col="white" )
        #-----patio bloc 2-----#
        lines(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5525,1.68, "Block 2", cex=0.7, col="white" )
        #-----patio bloc 3-----#
        lines(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22))
        polygon(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5835,1.29, "Block 3", cex=0.7, col="white" )
        text(1.3675,1.9, "Baud-Bovy entrance", cex=0.7, col="Black")
        text(1.4,1.402, "Pont-D'arve entrance", cex=0.7, col="Black")
        points(1.37,1.86, col="red", pch=20, cex=1.5)
        points(1.47,1.37, col="red", pch=20, cex=1.5)},
        #height = 400, width = 400
        
      )}
    
    if(input$section=="1st floor Sciences économiques et sociales - 1st"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),cex=0, ylab = "", axes=FALSE, xlab = "", main = "First floor")
        lines(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),col="black")
        text(c(1.37,1.37), c(1.01,2), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        #-------couleur SES------#
        polygon(c(1.445,1.445,1.50,1.53,1.55,1.64,1.64,1.69,1.69,1.69,1.65,1.65,1.445),c(1.86,1.65,1.55,1.55,1.55,1.55,1.695,1.695,1.805,1.825,1.89,1.94,1.94) , density = NULL, angle = 45,
                border = NULL, col = "#f6b002", lty = par("lty"), fillOddEven = FALSE)
        #-----patio bloc 0-----#
        lines(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.1825,1.68, "Block 0", cex=0.7, col="white" )
        #-----patio bloc 2-----#
        lines(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5525,1.68, "Block 2", cex=0.7, col="white" )
        #-----patio bloc 3-----#
        lines(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22))
        polygon(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5835,1.29, "Block 3", cex=0.7, col="white" )
        text(1.3675,1.9, "Baud-Bovy entrance", cex=0.7, col="Black")
        text(1.4,1.402, "Pont-D'arve entrance", cex=0.7, col="Black")
        points(1.37,1.86, col="red", pch=20, cex=1.5)
        points(1.47,1.37, col="red", pch=20, cex=1.5)},
        #height = 400, width = 400
        
      )}
    
    if(input$section=="1st floor Psychologie et science de l'éducation - 1st"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),cex=0, ylab = "", axes=FALSE, xlab = "", main = "First floor")
        lines(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),col="black")
        text(c(1.37,1.37), c(1.01,2), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        #-------couleur Science de l'éduc psycho------#
        polygon(c(1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.53),c(1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.43) , density = NULL, angle = 45,
                border = NULL, col = "#c29705", lty = par("lty"), fillOddEven = FALSE)
        #-----patio bloc 0-----#
        lines(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.1825,1.68, "Block 0", cex=0.7, col="white" )
        #-----patio bloc 2-----#
        lines(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5525,1.68, "Block 2", cex=0.7, col="white" )
        #-----patio bloc 3-----#
        lines(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22))
        polygon(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5835,1.29, "Block 3", cex=0.7, col="white" )
        text(1.3675,1.9, "Baud-Bovy entrance", cex=0.7, col="Black")
        text(1.4,1.402, "Pont-D'arve entrance", cex=0.7, col="Black")
        points(1.37,1.86, col="red", pch=20, cex=1.5)
        points(1.47,1.37, col="red", pch=20, cex=1.5)},
        #height = 400, width = 400
        
      )}  
    if(input$section=="1st floor Espace presse - 1st"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),cex=0, ylab = "", axes=FALSE, xlab = "", main = "First floor")
        lines(c(1.3675,1.32875,1.29,1.01,1.01,1.06,1.06,1.095,1.095,1.225,1.29,1.29,1.445,1.445,1.50,1.53,1.53,1.50,1.455,1.41,1.41,1.725,1.725,1.68,1.68,1.55,1.55,1.64,1.64,1.69,1.69,1.725,1.725,1.705,1.685,1.685,1.445,1.40625,1.3675),c(1.98,1.97,1.94,1.94,1.77,1.77,1.70,1.70,1.559,1.559,1.65,1.86,1.86,1.65,1.55,1.55,1.43,1.43,1.34,1.34,1.03,1.03,1.14,1.14,1.43,1.43,1.55,1.55,1.695,1.695,1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.97,1.98),col="black")
        text(c(1.37,1.37), c(1.01,2), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        #-----espace presse-----#
        lines(c(1.69,1.725,1.725,1.705,1.685,1.685,1.65,1.65,1.69,1.69),c(1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.89,1.825,1.805))
        polygon(c(1.69,1.725,1.725,1.705,1.685,1.685,1.65,1.65,1.69,1.69),c(1.805,1.805,1.89,1.89,1.915,1.94,1.94,1.89,1.825,1.805) , density = NULL, angle = 45,
                border = NULL, col = "#d16d85", lty = par("lty"), fillOddEven = FALSE)
        #-----patio bloc 0-----#
        lines(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.13,1.235,1.235,1.13,1.13),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.1825,1.68, "Block 0", cex=0.7, col="white" )
        #-----patio bloc 2-----#
        lines(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61))
        polygon(c(1.50,1.605,1.605,1.50,1.50),c(1.61,1.61,1.75,1.75,1.61), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5525,1.68, "Block 2", cex=0.7, col="white" )
        #-----patio bloc 3-----#
        lines(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22))
        polygon(c(1.537,1.63,1.63,1.537,1.537),c(1.22,1.22,1.36,1.36,1.22), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.5835,1.29, "Block 3", cex=0.7, col="white" )
        text(1.3675,1.9, "Baud-Bovy entrance", cex=0.7, col="Black")
        text(1.4,1.402, "Pont-D'arve entrance", cex=0.7, col="Black")
        points(1.37,1.86, col="red", pch=20, cex=1.5)
        points(1.47,1.37, col="red", pch=20, cex=1.5)},
        #height = 400, width = 400
        
      )}
    
    #----------------------------------------------------------------------------------
    #Second floor
    #----------------------------------------------------------------------------------
    
    if(input$section=="2nd floor Droit - 2nd"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
               1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
               1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
               1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
               1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
               1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
               1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
               1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
               1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                   ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                   ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                   ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                   ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                   ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                   ,1.96,1.94,1.94,1.8547619047619,1.8547619047619),cex=0, ylab = "", axes=FALSE, xlab = "", main = "Second floor")
        lines(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
                1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
                1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
                1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
                1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
                1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
                1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
                1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                    ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                    ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                    ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                    ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                    ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                    ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                    ,1.96,1.94,1.94,1.8547619047619,1.8547619047619), col="black")
        text(c(1.37,1.37), c(1.03,1.99), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        #-------section droit 2ème étage--------#
        polygon(c(1.26865601503759,1.06776315789474,1.06776315789474,1.00778443113772,1.00778443113772,
                  1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                  1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.22847744360902,
                  1.22847744360902,1.21578947368421,1.11005639097744,1.09948308270677,1.09948308270677,
                  1.11005639097744,1.21578947368421,1.26865601503759),c(1.94,1.94,1.8547619047619
                                                                        ,1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327
                                                                        ,1.52482993197279,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184
                                                                        ,1.57244897959184,1.56904761904762,1.55204081632653,1.55204081632653,1.56904761904762
                                                                        ,1.79353741496599,1.81054421768707,1.81054421768707,1.81054421768707), density = NULL, angle = 45,
                border = NULL, col = "#e83d38", lty = par("lty"), fillOddEven = FALSE)
        #-------patio bloc 0-------#
        lines(c(1.09948308270677,1.09948308270677,1.11005639097744
                ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.09948308270677,1.09948308270677,1.11005639097744
                  ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                  1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                       ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.16398026315790,1.68129251700680, "Block 0", cex=0.7, col="black" )
        #-------patio bloc 2-------#
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                   ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45, border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.68129251700680, "Block 2", cex=0.7, col="black")
        #-------patio bloc 3-------#
        
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                   ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                     ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.29013605442180, "Block 3", cex=0.7, col="black")
      },
      #height = 400, width = 400
      
      )}
    
    if(input$section=="2nd floor Relation internationales - 2nd"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
               1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
               1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
               1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
               1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
               1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
               1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
               1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
               1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                   ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                   ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                   ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                   ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                   ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                   ,1.96,1.94,1.94,1.8547619047619,1.8547619047619),cex=0, ylab = "", axes=FALSE, xlab = "", main = "Second floor")
        lines(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
                1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
                1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
                1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
                1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
                1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
                1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
                1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                    ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                    ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                    ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                    ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                    ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                    ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                    ,1.96,1.94,1.94,1.8547619047619,1.8547619047619), col="black")
        text(c(1.37,1.37), c(1.03,1.99), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        #-------section RI 2ème étage--------#
        
        polygon(c(1.26865601503759,1.32215568862275,1.32215568862275,1.25928143712575,
                  1.24116541353383,1.22847744360902,1.22847744360902,1.21578947368421),c(1.81054421768707,1.81054421768707
                                                                                         ,1.64047619047619,1.57244897959184,1.57244897959184,1.57244897959184,1.79353741496599,1.81054421768707), density = NULL, angle = 45,
                border = NULL, col = "#00a0de", lty = par("lty"), fillOddEven = FALSE)
        #-------patio bloc 0-------#
        lines(c(1.09948308270677,1.09948308270677,1.11005639097744
                ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.09948308270677,1.09948308270677,1.11005639097744
                  ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                  1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                       ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.16398026315790,1.68129251700680, "Block 0", cex=0.7, col="black" )
        #-------patio bloc 2-------#
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                   ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45, border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.68129251700680, "Block 2", cex=0.7, col="black")
        #-------patio bloc 3-------#
        
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                   ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                     ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.29013605442180, "Block 3", cex=0.7, col="black")
      },
      #height = 400, width = 400
      
      )}
    
    if(input$section=="2nd floor Sciences sociales - 2nd"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
               1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
               1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
               1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
               1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
               1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
               1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
               1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
               1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                   ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                   ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                   ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                   ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                   ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                   ,1.96,1.94,1.94,1.8547619047619,1.8547619047619),cex=0, ylab = "", axes=FALSE, xlab = "", main = "Second floor")
        lines(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
                1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
                1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
                1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
                1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
                1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
                1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
                1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                    ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                    ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                    ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                    ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                    ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                    ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                    ,1.96,1.94,1.94,1.8547619047619,1.8547619047619), col="black")
        text(c(1.37,1.37), c(1.03,1.99), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        
        #-------section SES 2ème étage--------#
        points(1.68735902255639,1.94, cex=0)
        points(1.48223684210526,1.94, cex=0)
        polygon(c(1.48223684210526,1.48223684210526,1.5139567669774,1.6196898496842,1.6323778196090,1.6323778196090,1.65149700598802,
                  1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.68735902255639,
                  1.72753759398496,1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,
                  1.48223684210526),c(1.94,1.81054421768707,1.81054421768707,1.81054421768707,1.79353741496599,1.56904761904762,1.56904761904762,
                                      1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463
                                      ,1.71530612244898,1.71530612244898,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94), density = NULL, angle = 45,
                border = NULL, col = "#f6b002", lty = par("lty"), fillOddEven = FALSE)
        #-------patio bloc 0-------#
        lines(c(1.09948308270677,1.09948308270677,1.11005639097744
                ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.09948308270677,1.09948308270677,1.11005639097744
                  ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                  1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                       ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.16398026315790,1.68129251700680, "Block 0", cex=0.7, col="black" )
        #-------patio bloc 2-------#
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                   ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45, border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.68129251700680, "Block 2", cex=0.7, col="black")
        #-------patio bloc 3-------#
        
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                   ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                     ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.29013605442180, "Block 3", cex=0.7, col="black")
      },
      #height = 400, width = 400
      
      )}
    
    if(input$section=="2nd floor Economie, Finance et management - 2nd"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
               1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
               1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
               1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
               1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
               1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
               1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
               1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
               1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                   ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                   ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                   ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                   ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                   ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                   ,1.96,1.94,1.94,1.8547619047619,1.8547619047619),cex=0, ylab = "", axes=FALSE, xlab = "", main = "Second floor")
        lines(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
                1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
                1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
                1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
                1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
                1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
                1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
                1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                    ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                    ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                    ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                    ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                    ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                    ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                    ,1.96,1.94,1.94,1.8547619047619,1.8547619047619), col="black")
        text(c(1.37,1.37), c(1.03,1.99), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        
        #-------section Eco-Finance 2ème étage--------#
        polygon(c(1.48223684210526,1.5139567669774,1.5033834587068,1.5033834587068,1.5139567669774,
                  1.45389221556886,1.45389221556886,1.41197604790419,1.41197604790419,1.48223684210526)
                ,c(1.81054421768707,1.81054421768707,1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                   ,1.56904761904762,1.61326530612245,1.81054421768707,1.81054421768707), density = NULL, angle = 45,
                border = NULL, col = "#496e8e", lty = par("lty"), fillOddEven = FALSE)
        #-------patio bloc 0-------#
        lines(c(1.09948308270677,1.09948308270677,1.11005639097744
                ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.09948308270677,1.09948308270677,1.11005639097744
                  ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                  1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                       ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.16398026315790,1.68129251700680, "Block 0", cex=0.7, col="black" )
        #-------patio bloc 2-------#
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                   ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45, border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.68129251700680, "Block 2", cex=0.7, col="black")
        #-------patio bloc 3-------#
        
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                   ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                     ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.29013605442180, "Block 3", cex=0.7, col="black")
      },
      #height = 400, width = 400
      
      )}
    
    if(input$section=="2nd floor Espace audiovisuel - 2nd"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
               1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
               1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
               1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
               1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
               1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
               1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
               1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
               1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                   ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                   ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                   ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                   ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                   ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                   ,1.96,1.94,1.94,1.8547619047619,1.8547619047619),cex=0, ylab = "", axes=FALSE, xlab = "", main = "Second floor")
        lines(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
                1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
                1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
                1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
                1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
                1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
                1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
                1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                    ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                    ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                    ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                    ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                    ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                    ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                    ,1.96,1.94,1.94,1.8547619047619,1.8547619047619), col="black")
        text(c(1.37,1.37), c(1.03,1.99), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        
        #-------espace audio-visuel 2ème étage--------#
        polygon(c(1.66347305389222,1.6874251497006,1.6874251497006,1.6196898496842,1.6196898496842,
                  1.6323778196090,1.6323778196090,1.66347305389222),c(1.34115646258503,1.34115646258503
                                                                      ,1.4978231292517,1.4978231292517,1.4193877551020,1.4023809523810,1.34115646258503,1.34115646258503), density = NULL, angle = 45,
                border = NULL, col = "#d8005c", lty = par("lty"), fillOddEven = FALSE)
        #-------patio bloc 0-------#
        lines(c(1.09948308270677,1.09948308270677,1.11005639097744
                ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.09948308270677,1.09948308270677,1.11005639097744
                  ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                  1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                       ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.16398026315790,1.68129251700680, "Block 0", cex=0.7, col="black" )
        #-------patio bloc 2-------#
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                   ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45, border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.68129251700680, "Block 2", cex=0.7, col="black")
        #-------patio bloc 3-------#
        
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                   ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                     ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.29013605442180, "Block 3", cex=0.7, col="black")
      },
      #height = 400, width = 400
      
      )}
    if(input$section=="2nd floor Traduction - 2nd"){
      output$map <- renderPlot({
        par(bg="#ecf0f5")
        plot(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
               1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
               1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
               1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
               1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
               1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
               1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
               1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
               1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                   ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                   ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                   ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                   ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                   ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                   ,1.96,1.94,1.94,1.8547619047619,1.8547619047619),cex=0, ylab = "", axes=FALSE, xlab = "", main = "Second floor")
        lines(c(1.00778443113772,1.00778443113772,1.0437125748503,1.0437125748503,1.05868263473054,1.05868263473054,1.10359281437126,
                1.10359281437126,1.22335329341317,1.22335329341317,1.24116541353383,1.25928143712575,1.32215568862275,1.32215568862275,1.41197604790419,
                1.41197604790419,1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,1.44790419161677,
                1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,1.66347305389222,1.6874251497006,1.6874251497006,
                1.72634730538922,1.73532934131737,1.73832335329341,1.73532934131737,1.72634730538922,1.68742514970065,1.6874251497006,
                1.65149700598802,1.65149700598802,1.66946107784431,1.66946107784431,1.68735902255639,1.6874251497006,1.72753759398496,
                1.72753759398496,1.70850563909774,1.68735902255639,1.68735902255639,1.44205827067669,1.42091185,1.39976503759398,
                1.39976503759398,1.33421052631579,1.33421052631579,1.313063645,1.29191729323308,1.06776315789474,1.06776315789474,
                1.00778443113772),c(1.8547619047619,1.53843537414966,1.53843537414966,1.50102040816327,1.50102040816327,1.52482993197279
                                    ,1.52482993197279,1.50442176870748,1.50442176870748,1.545,1.57244897959184,1.57244897959184,1.64047619047619,1.82755102040816
                                    ,1.82755102040816,1.61326530612245,1.56904761904762,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                                    ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932,1.34115646258503,1.34115646258503,1.42959183673469
                                    ,1.42959183673469,1.45680272108844,1.48061224489796,1.51122448979592,1.53503401360544,1.53503401360544,1.55884353741497
                                    ,1.55884353741497,1.59625850340136,1.59625850340136,1.64727891156463,1.64727891156463,1.71530612244898,1.71530612244898
                                    ,1.88877551020408,1.88877551020408,1.91938775510204,1.94,1.94,1.96,1.97040816326531,1.8921768707483,1.8921768707483,1.97040816326531
                                    ,1.96,1.94,1.94,1.8547619047619,1.8547619047619), col="black")
        text(c(1.37,1.37), c(1.03,1.99), labels = c("Boulevard du Pont-d'Arve","Parc Baud-Bovy"), cex = 0.7)
        
        #-------traduction 2ème étage--------#
        polygon(c(1.45389221556886,1.45389221556886,1.41796407185629,1.41796407185629,1.44790419161677,
                  1.44790419161677,1.65449101796407,1.72634730538922,1.72634730538922,1.66347305389222,
                  1.66347305389222,1.6323778196090,1.6323778196090,1.6196898496842,1.5139567669774,
                  1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6196898496842,
                  1.6874251497006,1.6874251497006,1.65149700598802,1.65149700598802,1.6323778196090,1.6196898496842)
                ,c(1.55204081632653,1.42619047619048,1.3547619047619,1.1030612244898,1.1030612244898
                   ,1.05204081632653,1.05204081632653,1.14047619047619,1.2187074829932,1.2187074829932
                   ,1.34115646258503,1.34115646258503,1.1778911564626,1.1608843537415,1.1608843537415
                   ,1.1778911564626,1.4023809523810,1.4193877551020,1.4193877551020,1.4978231292517
                   ,1.4978231292517,1.55884353741497,1.55884353741497,1.56904761904762,1.56904761904762
                   ,1.55204081632653), density = NULL, angle = 45,
                border = NULL, col = "#ec7205", lty = par("lty"), fillOddEven = FALSE)
        #-------patio bloc 0-------#
        lines(c(1.09948308270677,1.09948308270677,1.11005639097744
                ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.09948308270677,1.09948308270677,1.11005639097744
                  ,1.21578947368421,1.22847744360902,1.22847744360902,1.21578947368421,
                  1.11005639097744,1.09948308270677),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                       ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.16398026315790,1.68129251700680, "Block 0", cex=0.7, col="black" )
        #-------patio bloc 2-------#
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                   ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.79353741496599,1.56904761904762,1.55204081632653,1.55204081632653
                                                                                     ,1.56904761904762,1.79353741496599,1.81054421768707,1.81054421768707,1.79353741496599), density = NULL, angle = 45, border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.68129251700680, "Block 2", cex=0.7, col="black")
        #-------patio bloc 3-------#
        
        lines(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                   ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810))
        polygon(c(1.5033834587068,1.5033834587068,1.5139567669774,1.6196898496842,1.6323778196090,
                  1.6323778196090,1.6196898496842,1.5139567669774,1.5033834587068),c(1.4023809523810,1.1778911564626
                                                                                     ,1.1608843537415,1.1608843537415,1.1778911564626,1.4023809523810,1.419387755102,1.419387755102,1.4023809523810), density = NULL, angle = 45,
                border = NULL, col = "darkgreen", lty = par("lty"), fillOddEven = FALSE)
        text(1.56788063915790,1.29013605442180, "Block 3", cex=0.7, col="black")
      },
      #height = 400, width = 400
      
      )}
    
  })
  
  #--------------------------------Droit1st------------------------------------------
  #----------------------------------------------------------------------------------
  
  AnalyseDroit1st <- eventReactive(input$submit2a, {search1 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Droit - 1st"))
  a <- na.omit(gs_read(ss=search1, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  #----------------------Historique----------------------#
  
  AnalyseDroit1stHist <- eventReactive(input$submit2a, {search11 <- gs_title(paste("1st floor","Droit - 1st"))
  a <- na.omit(gs_read(ss=search11, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #------------------------------Scienceséconomiquesetsociales1st--------------------
  #----------------------------------------------------------------------------------
  
  AnalyseScienceséconomiquesetsociales1st <- eventReactive(input$submit2b, {search2 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Sciences économiques et sociales - 1st"))
  a <- na.omit(gs_read(ss=search2, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseScienceséconomiquesetsociales1stHist <- eventReactive(input$submit2b, {search22 <- gs_title(paste("1st floor","Sciences économiques et sociales - 1st"))
  a <- na.omit(gs_read(ss=search22, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  #--------------------"Psychologie et science de l'éducation - 1st"-----------------
  #----------------------------------------------------------------------------------
  
  AnalysePsychologieetsciencedeléducation1st <- eventReactive(input$submit2c, {search3 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Psychologie et science de l'éducation - 1st"))
  a <- na.omit(gs_read(ss=search3, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalysePsychologieetsciencedeléducation1stHist <- eventReactive(input$submit2c, {search33 <- gs_title(paste("1st floor","Psychologie et science de l'éducation - 1st"))
  a <- na.omit(gs_read(ss=search33, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  #----------------------Espace presse - 1st-----------------------------------------
  #----------------------------------------------------------------------------------
  
  AnalyseEspacepresse1st <- eventReactive(input$submit2d, {search4 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Espace presse - 1st"))
  a <- na.omit(gs_read(ss=search4, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseEspacepresse1stHist <- eventReactive(input$submit2d, {search44 <- gs_title(paste("1st floor","Espace presse - 1st"))
  a <- na.omit(gs_read(ss=search44, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #------------------------------------"Droit - 2nd"---------------------------------
  #----------------------------------------------------------------------------------
  
  AnalyseDroit2nd <- eventReactive(input$submit2e, {search5 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Droit - 2nd"))
  a <- na.omit(gs_read(ss=search5, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseDroit2ndHist <- eventReactive(input$submit2e, {search55 <- gs_title(paste("2nd floor","Droit - 2nd"))
  a <- na.omit(gs_read(ss=search55, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #-------------------------------"Relation internationales - 2nd"-------------------
  #----------------------------------------------------------------------------------
  
  AnalyseRelationinternationales2nd <- eventReactive(input$submit2f, {search6 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Relation internationales - 2nd"))
  a <- na.omit(gs_read(ss=search6, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseRelationinternationales2ndHist <- eventReactive(input$submit2f, {search66 <- gs_title(paste("2nd floor","Relation internationales - 2nd"))
  a <- na.omit(gs_read(ss=search66, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #-----------------------------"Sciences sociales - 2nd"----------------------------
  #----------------------------------------------------------------------------------
  
  AnalyseSciencessociales2nd <- eventReactive(input$submit2g, {search7 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Sciences sociales - 2nd"))
  a <- na.omit(gs_read(ss=search7, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseSciencessociales2ndHist <- eventReactive(input$submit2g, {search77 <- gs_title(paste("2nd floor","Sciences sociales - 2nd"))
  a <- na.omit(gs_read(ss=search77, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #------------------------"Economie, Finance et management - 2nd"-------------------
  #----------------------------------------------------------------------------------
  
  AnalyseEconomieFinanceetmanagement2nd <- eventReactive(input$submit2h, {search8 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Economie, Finance et management - 2nd"))
  a <- na.omit(gs_read(ss=search8, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseEconomieFinanceetmanagement2ndHist <- eventReactive(input$submit2h, {search88 <- gs_title(paste("2nd floor","Economie, Finance et management - 2nd"))
  a <- na.omit(gs_read(ss=search88, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  #--------------------------------"Espace audiovisuel - 2nd"------------------------
  #----------------------------------------------------------------------------------
  
  AnalyseEspaceaudiovisuel2nd <- eventReactive(input$submit2i, {search9 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Espace audiovisuel - 2nd"))
  a <- na.omit(gs_read(ss=search9, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------Historique----------------------#
  
  AnalyseEspaceaudiovisuel2ndHist <- eventReactive(input$submit2i, {search99 <- gs_title(paste("2nd floor","Espace audiovisuel - 2nd"))
  a <- na.omit(gs_read(ss=search99, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  #----------------------------------"Traduction - 2nd"------------------------------
  #----------------------------------------------------------------------------------
  
  AnalyseTraduction2nd <- eventReactive(input$submit2j, {search10 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Traduction - 2nd"))
  a <- na.omit(gs_read(ss=search10, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  #----------------------Historique----------------------#
  
  AnalyseTraduction2ndHist <- eventReactive(input$submit2j, {search1010 <- gs_title(paste("2nd floor","Traduction - 2nd"))
  a <- na.omit(gs_read(ss=search1010, ws = 1))
  a <- as.data.frame(a)
  a <- a[order(a[,2]),]
  
  coord = c(NA)
  
  for (i in min(a$Heure):max(a$Heure)){
    
    if (sum(t(which(a$Heure == i)))>=1){
      
      b = t(which(a$Heure == i))
      for (j in length(b)){
        coord = rbind(coord , b[j] )
      }
    }
  }
  
  coord = na.omit(coord)
  coord2= na.omit(coord)
  
  if ( dim(coord)[1]>=2){
    
    
    for (i in length(coord):2){
      coord[i] = coord[i]-coord[i-1]
    }
    
    a <- as.matrix(a)
    
    sol = t(c(NA,NA))
    ct=1
    
    lala <- t(rbind(t(coord2)-t(coord)+1,t(coord2)))
    
    for (i in 1:length(coord)){
      sol = rbind(sol , t(c(round(mean(a[,1][lala[i,1]:lala[i,2]]), digits = 5),a[coord2[i],2])))
    }
    
    sol = na.omit(sol)
  }else{sol = c(mean(as.matrix(a)[,1]),as.matrix(a)[1,2])
  sol = t(sol)}
  })
  
  
  
  output$hist1 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseDroit1st()[,2],AnalyseDroit1st()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseDroit1st()[,2],AnalyseDroit1st()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseDroit1st()[,2],AnalyseDroit1st()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseDroit1st()[,2],AnalyseDroit1st()[,1], col = "#C30000", lwd=7)
  })
  
  #--------------Historique--------------#
  
  output$hist1hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseDroit1stHist()[,2],AnalyseDroit1stHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseDroit1stHist()[,2],AnalyseDroit1stHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseDroit1stHist()[,2],AnalyseDroit1stHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseDroit1stHist()[,2],AnalyseDroit1stHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist2 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseScienceséconomiquesetsociales1st()[,2],AnalyseScienceséconomiquesetsociales1st()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseScienceséconomiquesetsociales1st()[,2],AnalyseScienceséconomiquesetsociales1st()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseScienceséconomiquesetsociales1st()[,2],AnalyseScienceséconomiquesetsociales1st()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseScienceséconomiquesetsociales1st()[,2],AnalyseScienceséconomiquesetsociales1st()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist2hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseScienceséconomiquesetsociales1stHist()[,2],AnalyseScienceséconomiquesetsociales1stHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseScienceséconomiquesetsociales1stHist()[,2],AnalyseScienceséconomiquesetsociales1stHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseScienceséconomiquesetsociales1stHist()[,2],AnalyseScienceséconomiquesetsociales1stHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseScienceséconomiquesetsociales1stHist()[,2],AnalyseScienceséconomiquesetsociales1stHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist3 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalysePsychologieetsciencedeléducation1st()[,2],AnalysePsychologieetsciencedeléducation1st()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalysePsychologieetsciencedeléducation1st()[,2],AnalysePsychologieetsciencedeléducation1st()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalysePsychologieetsciencedeléducation1st()[,2],AnalysePsychologieetsciencedeléducation1st()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalysePsychologieetsciencedeléducation1st()[,2],AnalysePsychologieetsciencedeléducation1st()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist3hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalysePsychologieetsciencedeléducation1stHist()[,2],AnalysePsychologieetsciencedeléducation1stHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalysePsychologieetsciencedeléducation1stHist()[,2],AnalysePsychologieetsciencedeléducation1stHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalysePsychologieetsciencedeléducation1stHist()[,2],AnalysePsychologieetsciencedeléducation1stHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalysePsychologieetsciencedeléducation1stHist()[,2],AnalysePsychologieetsciencedeléducation1stHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist4 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseEspacepresse1st()[,2],AnalyseEspacepresse1st()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseEspacepresse1st()[,2],AnalyseEspacepresse1st()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseEspacepresse1st()[,2],AnalyseEspacepresse1st()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseEspacepresse1st()[,2],AnalyseEspacepresse1st()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist4hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseEspacepresse1stHist()[,2],AnalyseEspacepresse1stHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseEspacepresse1stHist()[,2],AnalyseEspacepresse1stHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseEspacepresse1stHist()[,2],AnalyseEspacepresse1stHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseEspacepresse1stHist()[,2],AnalyseEspacepresse1stHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist5 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseDroit2nd()[,2],AnalyseDroit2nd()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseDroit2nd()[,2],AnalyseDroit2nd()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseDroit2nd()[,2],AnalyseDroit2nd()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseDroit2nd()[,2],AnalyseDroit2nd()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist5hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseDroit2ndHist()[,2],AnalyseDroit2ndHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseDroit2ndHist()[,2],AnalyseDroit2ndHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseDroit2ndHist()[,2],AnalyseDroit2ndHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseDroit2ndHist()[,2],AnalyseDroit2ndHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist6 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseRelationinternationales2nd()[,2],AnalyseRelationinternationales2nd()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseRelationinternationales2nd()[,2],AnalyseRelationinternationales2nd()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseRelationinternationales2nd()[,2],AnalyseRelationinternationales2nd()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseRelationinternationales2nd()[,2],AnalyseRelationinternationales2nd()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist6hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseRelationinternationales2ndHist()[,2],AnalyseRelationinternationales2ndHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseRelationinternationales2ndHist()[,2],AnalyseRelationinternationales2ndHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseRelationinternationales2ndHist()[,2],AnalyseRelationinternationales2ndHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseRelationinternationales2ndHist()[,2],AnalyseRelationinternationales2ndHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist7 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseSciencessociales2nd()[,2],AnalyseSciencessociales2nd()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseSciencessociales2nd()[,2],AnalyseSciencessociales2nd()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseSciencessociales2nd()[,2],AnalyseSciencessociales2nd()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseSciencessociales2nd()[,2],AnalyseSciencessociales2nd()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist7hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseSciencessociales2ndHist()[,2],AnalyseSciencessociales2ndHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseSciencessociales2ndHist()[,2],AnalyseSciencessociales2ndHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseSciencessociales2ndHist()[,2],AnalyseSciencessociales2ndHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseSciencessociales2ndHist()[,2],AnalyseSciencessociales2ndHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist8 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseEconomieFinanceetmanagement2nd()[,2],AnalyseEconomieFinanceetmanagement2nd()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseEconomieFinanceetmanagement2nd()[,2],AnalyseEconomieFinanceetmanagement2nd()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseEconomieFinanceetmanagement2nd()[,2],AnalyseEconomieFinanceetmanagement2nd()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseEconomieFinanceetmanagement2nd()[,2],AnalyseEconomieFinanceetmanagement2nd()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist8hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseEconomieFinanceetmanagement2ndHist()[,2],AnalyseEconomieFinanceetmanagement2ndHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseEconomieFinanceetmanagement2ndHist()[,2],AnalyseEconomieFinanceetmanagement2ndHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseEconomieFinanceetmanagement2ndHist()[,2],AnalyseEconomieFinanceetmanagement2ndHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseEconomieFinanceetmanagement2ndHist()[,2],AnalyseEconomieFinanceetmanagement2ndHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist9 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseEspaceaudiovisuel2nd()[,2],AnalyseEspaceaudiovisuel2nd()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseEspaceaudiovisuel2nd()[,2],AnalyseEspaceaudiovisuel2nd()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseEspaceaudiovisuel2nd()[,2],AnalyseEspaceaudiovisuel2nd()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseEspaceaudiovisuel2nd()[,2],AnalyseEspaceaudiovisuel2nd()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist9hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseEspaceaudiovisuel2ndHist()[,2],AnalyseEspaceaudiovisuel2ndHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseEspaceaudiovisuel2ndHist()[,2],AnalyseEspaceaudiovisuel2ndHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseEspaceaudiovisuel2ndHist()[,2],AnalyseEspaceaudiovisuel2ndHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseEspaceaudiovisuel2ndHist()[,2],AnalyseEspaceaudiovisuel2ndHist()[,1], col = "#C30000", lwd=7)
  })
  
  output$hist10 <- renderPlot({
    showNotification("Loading...")
    par(bg="#ecf0f5")
    plot(AnalyseTraduction2nd()[,2],AnalyseTraduction2nd()[,1],
         main = "Today", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseTraduction2nd()[,2],AnalyseTraduction2nd()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseTraduction2nd()[,2],AnalyseTraduction2nd()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseTraduction2nd()[,2],AnalyseTraduction2nd()[,1], col = "#C30000", lwd=7)
  })
  
  
  #--------------Historique--------------#
  
  output$hist10hist <- renderPlot({
    par(bg="#ecf0f5")
    plot(AnalyseTraduction2ndHist()[,2],AnalyseTraduction2ndHist()[,1],
         main = "Historical data", xlab = "Time", ylab = "",
         yaxt = "n", xaxt = "n", xlim = c(7,23), ylim = c(0,5), axes = F, pch=20, cex=1.4, col = "darkgrey")
    axis(1, at = seq(7, 23, by = 1), las=1)
    mtext(c("Nice","It's ok","Crowded","Full"), side = 2, at = seq(1, 4, by = 1), las=1)
    lines(c(7,23),c(1,1), lty=2, col = "grey")
    lines(c(7,23),c(2,2), lty=2, col = "grey")
    lines(c(7,23),c(3,3), lty=2, col = "grey")
    lines(c(7,23),c(4,4), lty=2, col = "grey")
    clip(-1000,1000,0.7,2)
    lines(AnalyseTraduction2ndHist()[,2],AnalyseTraduction2ndHist()[,1], col = "#3CB371", lwd=7)
    clip(-1000,1000,2,3)
    lines(AnalyseTraduction2ndHist()[,2],AnalyseTraduction2ndHist()[,1], col = "#FF8C00", lwd=7)
    clip(-1000,1000,3,4.3)
    lines(AnalyseTraduction2ndHist()[,2],AnalyseTraduction2ndHist()[,1], col = "#C30000", lwd=7)
  })
  
  observeEvent(input$submit3, {
    search1 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Droit - 1st"))
    namea1 = noquote(paste("1st floor","Droit"))
    a1 <- as.data.frame(na.omit(gs_read(ss=search1, ws = 1)))
    a1 <-a1[,1][dim(a1)[1]]
    
    showNotification("Step 1/10 ✔ - Ranking")
    
    search2 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Sciences économiques et sociales - 1st"))
    namea2 = noquote(paste("1st floor","Sciences économiques et sociales"))
    a2 <- as.data.frame(na.omit(gs_read(ss=search2, ws = 1)))
    a2 <-a2[,1][dim(a2)[1]]
    
    showNotification("Step 2/10 ✔ - Ranking")
    
    search3 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Psychologie et science de l'éducation - 1st"))
    namea3 = noquote(paste("1st floor","Psychologie et science de l'éducation"))
    a3 <- as.data.frame(na.omit(gs_read(ss=search3, ws = 1)))
    a3 <-a3[,1][dim(a3)[1]]
    
    showNotification("Step 3/10 ✔ - Ranking")
    
    search4 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"1st floor","Espace presse - 1st"))
    namea4 = noquote(paste("1st floor","Espace presse"))
    a4 <- as.data.frame(na.omit(gs_read(ss=search4, ws = 1)))
    a4 <-a4[,1][dim(a4)[1]]
    
    showNotification("Step 4/10 ✔ - Ranking")
    
    search5 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Droit - 2nd"))
    namea5 = noquote(paste("2nd floor","Droit"))
    a5 <- as.data.frame(na.omit(gs_read(ss=search5, ws = 1)))
    a5 <-a5[,1][dim(a5)[1]]
    
    showNotification("Step 5/10 ✔ - Ranking")
    
    search6 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Relation internationales - 2nd"))
    namea6 = noquote(paste("2nd floor","Relation internationales"))
    a6 <- as.data.frame(na.omit(gs_read(ss=search6, ws = 1)))
    a6 <-a6[,1][dim(a6)[1]]
    
    showNotification("Step 6/10 ✔ - Ranking")
    
    search7 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Sciences sociales - 2nd"))
    namea7 = noquote(paste("2nd floor","Sciences sociales"))
    a7 <- as.data.frame(na.omit(gs_read(ss=search7, ws = 1)))
    a7 <-a7[,1][dim(a7)[1]]
    
    showNotification("Step 7/10 ✔ - Ranking")
    
    search8 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Economie, Finance et management - 2nd"))
    namea8 = noquote(paste("2nd floor","Economie, Finance et management"))
    a8 <- as.data.frame(na.omit(gs_read(ss=search8, ws = 1)))
    a8 <-a8[,1][dim(a8)[1]]
    
    showNotification("Step 8/10 ✔ - Ranking")
    
    search9 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Espace audiovisuel - 2nd"))
    namea9 = noquote(paste("2nd floor","Espace audiovisuel"))
    a9 <- as.data.frame(na.omit(gs_read(ss=search9, ws = 1)))
    a9 <-a9[,1][dim(a9)[1]]
    
    showNotification("Step 9/10 ✔ - Ranking")
    
    search10 <- gs_title(paste(noquote(format(Sys.time(), tz = "Europe/Zurich", "%d_%b_%Y")),"2nd floor","Traduction - 2nd"))
    namea10 = noquote(paste("2nd floor","Traduction"))
    a10 <- as.data.frame(na.omit(gs_read(ss=search10, ws = 1)))
    a10 <-a10[,1][dim(a10)[1]]
    
    showNotification("Step 10/10 ✔ - Ranking")
    
    topplaces = c(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    topplaces = t(rbind(topplaces,c(namea1,namea2,namea3,namea4,namea5,namea6,namea7,namea8,namea9,namea10)))
    colnames(topplaces) <- c("lastmark","sections")
    topplaces = topplaces[order(topplaces[,1]),]
    topplaces = topplaces[,2]
    topplaces1 = topplaces
    topplaces1 = topplaces1[1:3]
    topplaces2 = t(rbind(c("N°4","N°5","N°6","N°7","N°8","N°9","N°10"),topplaces[4:10]))
    
    output$ranking <- renderTable(topplaces2, colnames = FALSE ,spacing = "l")
    
    output$top1 <- renderValueBox({
      valueBox("N°1", paste(topplaces1[1]), icon = icon("thumbs-up", lib = "glyphicon"),
               color = "green")
    })
    output$top2 <- renderValueBox({
      valueBox("N°2", paste(topplaces1[2]), icon = icon("thumbs-up", lib = "glyphicon"),
               color = "orange")
    })
    
    output$top3 <- renderValueBox({
      valueBox("N°3", paste(topplaces1[3]), icon = icon("thumbs-up", lib = "glyphicon"),
               color = "red")
    })
    #red, yellow, aqua, blue, light-blue, green, navy, teal, olive, lime, orange, fuchsia, purple, maroon, black.
  })
  
}

shinyApp(ui, server)