#
# Tile ordering game
# Server
# Simon Anastasiadis
#
# 2020-12-30
#

shinyServer(function(input, output, session) {
  
  ## initialise dynamics -------------------------------------------------------
  game_state = reactiveValues()
  
  game_state$player_deck = c(rep("1", NUM_CARDS_VALUE_1),
                             rep("2", NUM_CARDS_VALUE_2),
                             rep("3", NUM_CARDS_VALUE_3)) %>%
    sample(DECK_SIZE)
  
  ## plot ----------------------------------------------------------------------
  
  
  
  
  output$plot1 <- renderPlot({
    
    
    pp +
      geom_rect(data=DF_BOARD,
                mapping=aes(xmin=x_min, xmax=x_max, ymin=y_min, ymax=y_max, fill=is_ai), color="black", alpha=0.5) +
      geom_text(data=DF_BOARD,
                aes(x=x_mid, y=y_mid, label=is_storage), size=16)
    
  })
  
  
  
  ## debug info ----------------------------------------------------------------
  if(DEBUG){
    output$debug_info <- renderText({
      pc = input$plot_click
      if(is.null(pc)){
        pc$x = 0
        pc$y = 0
      }
      paste("x =", pc$x,
            "\ny =", pc$y,
            "\ncomponent =", component_clicked(pc$x, pc$y))
    })
    output$debug_values <- renderUI({
      hr()
      verbatimTextOutput("debug_info")
    })
  } else {
    output$debug_values <- renderUI({
      hr()
    })
  }
  
  ## ----
  
})
