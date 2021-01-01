# tile_ordering_r_shiny_game

A simple game made to explore partial orderings.

The game uses a single ggplot image as the board and a mouse listener
to detect player selection.

The UI and server are simple with most of the logic being contained in
the global script.

## Rules:

Each player has a deck of numbered cards (default 10 each of 1, 2 and 3).
Each player's deck is shuffled and three cards are dealed face-up. The
top card of the deck is also turned face up.

On each player's turn, they choose one of their four face up cards and
play it into their pile in the middle. Points are scored for the played
card.

After playing, if the top card of the deck was not played it is put in
the empty space left by the card that was played. The new card on top of
the deck is turned face up.

The game ends hen both players run out of cards. The player with the
highest score at the end of the game is the winner. Each card played
scores its face value, but is doubled if it is part of a run.

For example: A '2' would usually score 2 points. But if played after a
'1' then it scores the player 4 points. Playing '1' followed by '2' and
then by '3' would earn a player 11 points (1 point for the '1', 4 points
(2 points doubled) for the '2', and 6 points (3 points doubled) for the
'3'.

The computer will play against you. While it may win some games, it will
regularly loose against a good player.

## Versions:

Written in R version 4.0.3 (2020-10-10) "Bunny-Wunnies Freak Out".

Core packages and versions: shiny (version 1.5.0), ggplot2 (version 3.3.2),
dplyr (version 1.0.2), and assertthat (version 0.2.1).

## Mathematics

While the default game shown here is simple, as the total size of the deck
incraeses, and the number of unique cards increases, or the number of face
up cards decreases, the complexity & skill level of the game increases.

There are probably some interesting results that could be (or have already been)
proven about this type of ordering problem.
