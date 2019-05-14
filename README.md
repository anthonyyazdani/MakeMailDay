# Make Mail Day
###### Anthony Yazdani, Mehdi Benammou, Øyvind Dolincourt
![alt text](https://image.noelshack.com/fichiers/2019/20/2/1557824198-screen-shot-2019-05-14-at-10-55-39.png)

## The project
Make Mail Day is a Shiny Web app designed to propose interesting services to Uni Mail students on a daily basis. The voting feature "Make our Day" enables the user of the app to contribute : a contribution means a vote of a certain area of the library. By voting, he gives information to all the other users of the app about the curent situation at the library and also contibute to make a "historical data plot", which also gives a realistic view based on the past. The access to the ranking of the best section should be able to help students find their perfect spot to study. 


## The idea
As students are generally engaged in a sort of routine, we thougt it would be interesting to collect data and understand how they behave everyday. This project was the perfect opportunity to understand how data gathering and summerizing works and to make realevant statistics about our daily working environment seemed to a very exciting. With the raise of the streaming data and the need for analysis tools to manage these data, we were curious discover the functioning of a sector of activity that has an undeniable influence on all kind of businesses nowadays. 


## The code
The sturcture of the code is the following:
  * UI part: we use a package named Shinydashboards that offers a clean and enjoyable environement for the user. Widgets are added for the user to be able to grade the section of his choice. Hyperlinks are put together in the sidebar, giving rapid access to the web page of University of Geneva.
  * Server parts : first comes the creation of the Google Sheet that enables to stock data (contributions) in online matrices. Please note that the matrices are initialized every day and a matrix is created for each section of the library everyday.
  * Than come the maps of the library (first floor and second floor): when a user selects a section on the selection widget, a map appears and the section he chose is displayed in the official color of the faculty. This feature enables the users to easily find the section they want to grade. Under appears the button *MakeourDay* which directly send the grade in the correponding matrix on Google Sheet.
  * The code for the *Stay Informed* tab: when the user clicks on the tab, he can choose the section that interests him and ask the app to display the plots for this particular section: a live contribution graph and a historical data graph are displayed. This is enabled by pulling the data in a section matrix and plot (x = time between 8:00 am and 22:00 pm, y = mean grade between 0 and 4). An average grade for each hour is produced so that people get realevant information.
  * The historical graphs are plotted by pulling the data of section matrices that stores all the grades given by the users and show a past trend for all the sections of the library.
  * The ranking tab code : takes the grade for the last hour for each section and compare wich has the best grade. A top 10 is created every day.
  
  Hope you will enjoy the app, and if you go to the library, don't forget to contribute.
  
  > "MAKE YOUR PERSONAL INTEREST AN ADVANTAGE FOR THE COMMUNITY"
  
  



