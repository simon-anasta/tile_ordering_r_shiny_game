#
# Tile ordering game
# Server
# Simon Anastasiadis
#
# 2020-12-30
#

shinyServer(function(input, output, session) {
  
  # initialise
  game_state = reactiveValues()
  
  game_state$player_deck = c(rep("1", NUM_CARDS_VALUE_1),
                             rep("2", NUM_CARDS_VALUE_2),
                             rep("3", NUM_CARDS_VALUE_3)) %>%
    sample(DECK_SIZE)
  
  # plot
  output$plot1 <- renderPlot({
    
    
    ggplot() + 
      scale_x_continuous(name="x") + 
      scale_y_continuous(name="y") +
      geom_rect(data=DF_BOARD,
                mapping=aes(xmin=x_min, xmax=x_max, ymin=y_min, ymax=y_max, fill=is_ai), color="black", alpha=0.5) +
      geom_text(data=DF_BOARD,
                aes(x=x_mid, y=y_mid, label=is_storage), size=4)
    
  })
  
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })

})
