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

DF_BOARD = read.csv("board_components.csv") %>%
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
    y_inner_max = y_max - BORDER
  )

# board dimensions
BOARD_WIDTH_MIN = min(DF_BOARD$col_x)
BOARD_WIDTH_MAX = max(DF_BOARD$col_x)
BOARD_WIDTH = BOARD_WIDTH_MAX - BOARD_WIDTH_MIN + 1
BOARD_HEIGHT_MIN = min(DF_BOARD$row_y)
BOARD_HEIGHT_MAX = max(DF_BOARD$row_y)
BOARD_HEIGHT = BOARD_HEIGHT_MAX - BOARD_HEIGHT_MIN + 1
