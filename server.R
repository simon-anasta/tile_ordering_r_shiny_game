#
# Tile ordering game
# Server
# Simon Anastasiadis
#
# 2020-12-30
#

shinyServer(function(input, output, session) {
  
  ## setup reactives -----------------------------------------------------------
  # once values are made reactives we can not edit them in setup
  # hence setup each value first before making reactive
  game_state = reactiveValues()
  game_state$step = 0
  game_state$board = DF_BOARD
  game_state$player_deck = player_deck
  game_state$ai_deck = ai_deck
  
  ## resolve actions -----------------------------------------------------------
  
  observeEvent(input$plot_click,{ 
    game_state$step = game_state$step + 1
    update_state()
  })
  
  ## plot the game board -------------------------------------------------------
  
  output$game_board <- renderPlot({
    
    pp +
      geom_rect(data=game_state$board,
                mapping=aes(xmin=x_min,
                            xmax=x_max,
                            ymin=y_min,
                            ymax=y_max,
                            fill=is_ai),
                color="black",
                alpha=0.5) +
      geom_text(data=game_state$board,
                aes(x=x_mid, y=y_mid, label=value), size=16)
    
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
            "\ncomponent =", component_clicked(pc$x, pc$y),
            "\nstep number = ", game_state$step
      )
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
