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
  game_state$player_sequence = FALSE
  game_state$ai_sequence = FALSE
  
  ## resolve actions -----------------------------------------------------------
  
  observeEvent(input$plot_click,{ 
    game_state$step = game_state$step + 1
    ai_move = update_state(input, game_state)
    if(ai_move)
      update_ai_state(input, game_state)
  })
  
  ## plot the game board -------------------------------------------------------
  
  output$game_board <- renderPlot({
    
    values_DF = game_state$board %>%
      mutate(display_value = ifelse(is.na(value), "-", as.character(value))) %>%
      select(x_mid, y_mid, display_value)

    board_DF = game_state$board %>%
      select(xmin=x_min,
             xmax=x_max,
             ymin=y_min,
             ymax=y_max,
             fill_colour = background_colour,
             line_colour = background_colour,
             value)
    
    card_DF = game_state$board %>%
      filter(!is.na(value) & nchar(card_colour) == 7) %>%
      select(xmin=x_inner_min,
             xmax=x_inner_max,
             ymin=y_inner_min,
             ymax=y_inner_max,
             fill_colour = card_colour,
             line_colour = card_border_colour,
             value)
    
    # this order matters as lower rectangles are drawn on top of earlier ones
    DF3 = rbind(board_DF, card_DF)
    
    pp +
      geom_rect(data = DF3,
                mapping=aes(xmin=xmin,
                            xmax=xmax,
                            ymin=ymin,
                            ymax=ymax,
                            fill=fill_colour,
                            color = line_colour)
      ) +
      scale_fill_identity() +
      scale_colour_identity() +
      geom_text(data=values_DF,
                aes(x=x_mid, y=y_mid, label=display_value), size=16)
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
            "\nstep number = ", game_state$step,
            "\nplayer sequence = ", game_state$player_sequence
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
