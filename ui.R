#
# Tile ordering game
# User Interface
# Simon Anastasiadis
#
# 2020-12-30
#



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  plotOutput("plot1", click = "plot_click"),
  
  uiOutput("debug_values")
  

))
