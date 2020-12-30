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

## Parameters ------------------------------------------------------------------

# board dimensions
STORAGE_SLOTS = 3
DECK_SLOTS = 1
BOARD_WIDTH = STORAGE_SLOTS + DECK_SLOTS
BOARD_LHS = 0
BOARD_RHS = BOARD_LHS + BOARD_WIDTH - 1
AI_ROW = 1
SCORE_ROW = 0
PLAYER_ROW = -1
BOARD_HEIGHT = 1 + (max(AI_ROW, PLAYER_ROW, SCORE_ROW) 
                    - min(AI_ROW, PLAYER_ROW, SCORE_ROW))

# display parameters
UNIT_WIDTH = 1
UNIT_HEIGHT = 1
BORDER = 0.05

# game settings
DECK_SIZE = 30

## Playspace points ------------------------------------------------------------

PLAYSPACE_DF = data.frame(row_y = rep(1:BOARD_HEIGHT, times = BOARD_WIDTH),
                          col_x = rep(1:BOARD_WIDTH, each = BOARD_HEIGHT))

PLAYSPACE_DF = PLAYSPACE_DF %>%
  mutate(
    is_ai = row_y == BOARD_HEIGHT,
    is_player = row_y == 1,
    is_deck = (is_ai & col_x == BOARD_WIDTH) | (is_player & col_x == 1),
    is_storage = (is_ai | is_player) & !is_deck,
    
    x_mid = (col_x - 1 + BOARD_LHS) * UNIT_WIDTH,
    x_min = x_mid - 0.5 * UNIT_WIDTH,
    x_max = x_mid + 0.5 * UNIT_WIDTH,
    x_inner_min = x_min + BORDER,
    x_inner_max = x_max - BORDER,
    
    y_mid = case_when(is_ai ~ AI_ROW, is_player ~ PLAYER_ROW, TRUE ~ SCORE_ROW) * UNIT_HEIGHT,
    y_min = y_mid - 0.5 * UNIT_WIDTH,
    y_max = y_mid + 0.5 * UNIT_WIDTH,
    y_inner_min = y_min + BORDER,
    y_inner_max = y_max - BORDER,
  )



         
