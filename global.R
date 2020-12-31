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

get_component_value <- function(DF, component){
  
  answer = DF %>%
    filter(component_name == component) %>%
    select(value) %>%
    unlist(use.names = FALSE)
  
  return(handle_non_singletons(answer))
}

set_component_value <- function(DF, component, new_value){
  
  answer_df = DF %>%
    mutate(value = ifelse(component_name == component, new_value, value))
  
  return(answer_df)
}

##