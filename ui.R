#
# Tile ordering game
# User Interface
# Simon Anastasiadis
#
# 2020-12-30
#

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  plotOutput("game_board", click = "plot_click"),
  
  uiOutput("debug_values"),
  
  h4("Insturctions"),
  
  p("Each player has a deck of numbered cards (default 10 each of 1, 2 and 3",
    "Each player's deck is shuffled and three cards are dealed face-up. The",
    "top card of the deck is also turned face up."),
  p("On each player's turn, they choose one of their four face up cards and",
    "play it into their pile in the middle. Points are scored for the played",
    "card."),
  p("After playing, if the top card of the deck was not played it is put in",
    "the empty space left by the card that was played. The new card on top of",
    "the deck is turned face up"),
  p("The game ends hen both players run out of cards. The player with the",
    "highest score at the end of the game is the winner. Each card played",
    "scores its face value, but is doubled if it is part of a run."),
  p("For example: A '2' would usually score 2 points. But if played after a",
    "'1' then it scores the player 4 points. Playing '1' followed by '2' and",
    "then by '3' would earn a player 11 points (1 point for the '1', 4 points",
    "(2 points doubled) for the '2', and 6 points (3 points doubled) for the",
    "'3'."),
  p("The computer will play against you. While it may win some games, it will",
    "regularly loose against a good player.")
  
))
