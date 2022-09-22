#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "truncate teams,games")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    # Get count of team name in the table
    WNAME="$($PSQL "select name from teams where name='$WINNER'")"

    

    # Check if the WTeam name already exists
    if [[ -z $WNAME ]]
    then
      # Add the team name to the table
      echo "$($PSQL "Insert into teams(name) values('$WINNER')")"
  
    fi

    ONAME="$($PSQL "select name from teams where name='$OPPONENT'")"


    # Check if the OTeam name already exists
    if [[ -z $ONAME ]]
    then
      # Add the team name to the table
      echo "$($PSQL "Insert into teams(name) values('$OPPONENT')")"
      
    fi
  
    # Insert game details into the games tables


    # Get winning team id with team name

    WTID="$($PSQL "select team_id from teams where name='$WINNER'")"

    # Get opponent team id with team name

    OTID="$($PSQL "select team_id from teams where name='$OPPONENT'")"

    # Insert game rows into the table
    echo "$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WTID,$OTID,$WINNER_GOALS,$OPPONENT_GOALS)")"

  fi

  
done