#
# Tile ordering game
# Global
# Simon Anastasiadis
#
# 2020-12-30
#

library(shiny)
library(ggplot2)
library(dplyr)
library(assertthat)

## Parameters ------------------------------------------------------------------

DEBUG = TRUE

# display parameters
UNIT_WIDTH = 1
UNIT_HEIGHT = 1
BORDER = 0.05

# game settings
NUM_CARDS_VALUE_1 = 10
NUM_CARDS_VALUE_2 = 10
NUM_CARDS_VALUE_3 = 10
DECK_SIZE = 30

## Playing board ---------------------------------------------------------------

DF_BOARD = read.csv("board_components.csv")
assert_that(all(c("component_name","row_y","col_x") %in% colnames(DF_BOARD)))
assert_that(all(c("is_ai","is_player","is_storage") %in% colnames(DF_BOARD)))
assert_that(length(DF_BOARD$component_name) == length(unique(DF_BOARD$component_name)))

DF_BOARD = DF_BOARD %>%
  mutate(
    x_mid = col_x * UNIT_WIDTH,
    x_min = x_mid - 0.5 * UNIT_WIDTH,
    x_max = x_mid + 0.5 * UNIT_WIDTH,
    x_inner_min = x_min + BORDER,
    x_inner_max = x_max - BORDER,
    
    y_mid = row_y * UNIT_HEIGHT,
    y_min = y_mid - 0.5 * UNIT_WIDTH,
    y_max = y_mid + 0.5 * UNIT_WIDTH,
    y_inner_min = y_min + BORDER,
    y_inner_max = y_max - BORDER,
    
    value = NA
  )

# board dimensions
BOARD_WIDTH_MIN = min(DF_BOARD$col_x)
BOARD_WIDTH_MAX = max(DF_BOARD$col_x)
BOARD_WIDTH = BOARD_WIDTH_MAX - BOARD_WIDTH_MIN + 1
BOARD_HEIGHT_MIN = min(DF_BOARD$row_y)
BOARD_HEIGHT_MAX = max(DF_BOARD$row_y)
BOARD_HEIGHT = BOARD_HEIGHT_MAX - BOARD_HEIGHT_MIN + 1

## Handle non-singletons -------------------------------------------------------

handle_non_singletons <- function(answer, msg = "not singleton"){
  
  if(length(answer) == 1){
    return(answer)
  } else if(length(answer) == 0) {
    return(NA)
  } else if(length(answer) >= 2){
    warning(msg)
    return(answer)
  } else {
    stop("unreachible case")
  }
  
}

## Return location clicked -----------------------------------------------------

component_clicked = function(mouse_x, mouse_y){
  assert_that(is.numeric(mouse_x))
  assert_that(is.numeric(mouse_y))
  
  answer = DF_BOARD %>%
    mutate(clicked = (
      x_min <= mouse_x 
      & mouse_x < x_max
      & y_min <= mouse_y
      & mouse_y < y_max)
    ) %>%
    filter(clicked) %>%
    select(component_name) %>%
    unlist(use.names = FALSE)
  
  return(handle_non_singletons(answer))
}

## Get and Set value of component ----------------------------------------------

get_cmp_value <- function(DF, component){
  
  answer = DF %>%
    filter(component_name == component) %>%
    select(value) %>%
    unlist(use.names = FALSE)
  
  return(handle_non_singletons(answer))
}

set_cmp_value <- function(DF, component, new_value){
  
  answer_df = DF %>%
    mutate(value = ifelse(component_name == component, new_value, value))
  
  return(answer_df)
}

## create base plot once for speed ---------------------------------------------

pp = ggplot() +
  xlim(c(min(DF_BOARD$x_min), max(DF_BOARD$x_max))) +
  ylim(c(min(DF_BOARD$y_min), max(DF_BOARD$y_max))) +
  theme_void() +
  theme(legend.position = "none")

## Setup game ------------------------------------------------------------------

# player deck
player_deck = c(rep(1, NUM_CARDS_VALUE_1),
                rep(2, NUM_CARDS_VALUE_2),
                rep(3, NUM_CARDS_VALUE_3)) %>%
  sample(DECK_SIZE)
# ai deck
ai_deck = c(rep(1, NUM_CARDS_VALUE_1),
            rep(2, NUM_CARDS_VALUE_2),
            rep(3, NUM_CARDS_VALUE_3)) %>%
  sample(DECK_SIZE)
# deal starting hands
DF_BOARD = set_cmp_value(DF_BOARD,"player_storage_1", player_deck[1])
DF_BOARD = set_cmp_value(DF_BOARD,"player_storage_2", player_deck[2])
DF_BOARD = set_cmp_value(DF_BOARD,"player_storage_3", player_deck[3])
DF_BOARD = set_cmp_value(DF_BOARD,"player_deck", player_deck[4])
player_deck = player_deck[-(1:4)]

# initial scores
DF_BOARD = set_cmp_value(DF_BOARD,"player_score", 0)
DF_BOARD = set_cmp_value(DF_BOARD,"ai_score", 0)

## Update each turn ------------------------------------------------------------
# pass in input and reactiveValues so function can interact with them

update_state <- function(input, game_state){

  mouse_pc = input$plot_click
  component = component_clicked(mouse_pc$x, mouse_pc$y)
  
  # skip if not valid click
  if(!component %in% c("player_deck",
                       "player_storage_1",
                       "player_storage_2",
                       "player_storage_3")){
    return()
  }
  
  # local copy for ease of reference
  DF = game_state$board
  
  # fetch relevant values
  last_player_placement = get_cmp_value(DF, "player_placement")
  last_player_score = get_cmp_value(DF, "player_score")
  value_clicked = get_cmp_value(DF, component)
  
  # stop if null value clicked
  if(is.na(value_clicked))
    return()
  
  # is sequence maintained?
  p_seq = value_clicked == 1 |
    (game_state$player_sequence
     & value_clicked == last_player_placement + 1)

  # show placement
  DF = set_cmp_value(DF, "player_placement", value_clicked)
  
  # new score
  score_increase = ifelse(p_seq & value_clicked != 1, 2, 1) * value_clicked
  DF = set_cmp_value(DF, "player_score", last_player_score + score_increase)
  
  # update card display
  top_deck = get_cmp_value(DF, "player_deck")
  DF = set_cmp_value(DF, component, top_deck)
  DF = set_cmp_value(DF, "player_deck", game_state$player_deck[1])
  
  # update reactives
  game_state$player_deck = game_state$player_deck[-1]
  game_state$player_sequence = p_seq
  game_state$board = DF
}

## Reference -------------------------------------------------------------------

# component = component_clicked(mouse_x, mouse_y)
# value = get_cmp_value(DF, component)
# DF = set_cmp_value(DF, component, new_value)
