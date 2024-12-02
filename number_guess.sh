#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t -c"

# $NUMBER isn't completely POSIX compliant
NUMBER=$(( (RANDOM % 1000) + 1 ))

echo "Enter your username:"
read USERNAME

USER=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME';")

# if no user found
if [[ -z $USER ]]; then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  ADD_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
else
  echo "$USER" | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

NUM_GUESSES=0
echo "Guess the secret number between 1 and 1000:"
read GUESS

# if not an integer
while [[ ! $GUESS =~ ^[0-9]+$ ]]; do
  echo "That is not an integer, guess again:"
  read GUESS
done

while [ ! "$GUESS" -eq "$NUMBER" ]; do
  NUM_GUESSES=$(( NUM_GUESSES + 1 ))
  if [[ "$GUESS" -gt "$NUMBER" ]]; then
    echo "It's lower than that, guess again:"
    read GUESS
  else
    echo "It's higher than that, guess again:"
    read GUESS
  fi
done

NUM_GUESSES=$(( NUM_GUESSES + 1 ))
echo "You guessed it in $NUM_GUESSES tries. The secret number was $NUMBER. Nice job!"

UPDATE_USER=$($PSQL "UPDATE users SET games_played = games_played + 1, best_game = $NUM_GUESSES WHERE username = '$USERNAME';")