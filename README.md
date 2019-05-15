# Make Mail Day
###### Anthony Yazdani, Mehdi Benammou, Øyvind Dolincourt
![](https://image.noelshack.com/fichiers/2019/20/2/1557824198-screen-shot-2019-05-14-at-10-55-39.png)
[![IMAGE ALT TEXT HERE](https://image.noelshack.com/fichiers/2019/20/2/1557824198-screen-shot-2019-05-14-at-10-55-39.png)](https://www.youtube.com/watch?v=LHvEJiMOzSQ)

https://www.youtube.com/embed/LHvEJiMOzSQ<VIDEO ID>

## The project
Make Mail Day is a Shiny Web app designed to propose interesting services to Uni Mail students on a daily basis. The voting feature "Make our Day" enables the user of the app to contribute : a contribution means a grade for a certain area of the library. By voting, users give information to all the other users of the app about the current situation at the library and also contribute to understand the distribution and the habits of individuals within the library. The access to the ranking of the best section should be able to help students find their perfect spot to study. 


## The idea
As students are generally engaged in a sort of routine, we thought it would be interesting to collect data and understand how they behave every day. This project was the perfect opportunity to understand how data gathering and analysis works. To make relevant statistics about our daily working environment seemed to be very exciting. With the rise of the streaming data and the need for analysis tools to manage these data, we were curious to discover the functioning of a sector of activity that has an undeniable influence on all kinds of businesses nowadays.


## The code
The structure of the code is the following:
  * UI part: we use a package named Shinydashboards that offers a clean and enjoyable environment for the user. Widgets are added for the user to be able to grade the section of his choice. Hyperlinks are put together in the sidebar, giving rapid access to the web page of the University of Geneva.
  * Server parts : first comes the creation of the Google Sheet that enables to stock data (contributions). Please note that the sheets are initialized every day and a sheet is created for each section of the library every day.
  * Then come the maps of the library (first floor and second floor): when a user selects a section on the selection widget, a map appears and the section he chose is displayed in the official color of the faculty. This feature enables the users to easily find the section they want to grade. Below appears the button *MakeourDay* which directly send the grade in the corresponding sheet.
  * The code for the *Stay Informed* tab: when the user clicks on the tab, he can choose the section that interests him and ask the app to display the plots for this particular section: a live contribution graph and a historical data graph are displayed. This is enabled by pulling the data in a section matrix and plot (x = time between 8:00 am and 22:00 pm, y = mean grade between 0 and 4 for each hour). An average grade for each hour is produced so that people get relevant information.
  * The historical graphs are plotted by pulling the data of section sheets that stores all the grades given by the users and show a past trend for all the sections of the library.
  * The ranking tab code : takes the grade for the last hour for each section and compare which has the best grade. A top 10 is created each time you click on the submit button.
  
  Hope you will enjoy the app, and if you go to Uni Mail library, don't forget to contribute!
  
  > "Make your personal interest an advantage for the community"
  
  



