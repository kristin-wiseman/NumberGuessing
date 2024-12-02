#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t -c"

NUMBER=$(( (RANDOM % 1000) + 1 ))

echo "Enter your username:"
read USERNAME

USER=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME';")

if [[ -z $USER ]]; then
  echo "Welcome $USERNAME! It looks like this is your first time here."
  ADD_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
else
  echo "$USER" | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi