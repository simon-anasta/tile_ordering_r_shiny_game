#
# Tile ordering game
# Server
# Simon Anastasiadis
#
# 2020-12-30
#

shinyServer(function(input, output, session) {
  
  output$plot1 <- renderPlot({
    
    
    ggplot() + 
      scale_x_continuous(name="x") + 
      scale_y_continuous(name="y") +
      geom_rect(data=PLAYSPACE_DF,
                mapping=aes(xmin=x_min, xmax=x_max, ymin=y_min, ymax=y_max, fill=is_storage), color="black", alpha=0.5) +
      geom_text(data=PLAYSPACE_DF,
                aes(x=x_mid, y=y_mid, label=is_deck), size=4)
    
  })
  
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })

})
