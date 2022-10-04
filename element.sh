# connect to the database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"



# check whether argument exisit

if [[ -n $1 ]] 
then
  ARGUMENT=$1
  #check if the argument is and in or a string.
  if [[ $ARGUMENT =~ ^[0-9]+$ ]]
  then
    # argument is a number
    ELEMENT_DETAILS=$($PSQL "select atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius from properties left join types using(type_id) inner join elements using(atomic_number) where atomic_number=$1")
  else
    # argument is not a number
    ELEMENT_DETAILS=$($PSQL "select atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius from properties left join types using(type_id) inner join elements using(atomic_number) where symbol='$1' or name='$1'")
  fi

  # check empty Element Details 

  if [[ -z $ELEMENT_DETAILS ]]
  then
    # Element is not there
    echo "I could not find that element in the database."
  else
    # get data based on argument
    echo "$ELEMENT_DETAILS" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi

else
  # ask for element
  echo "Please provide an element as an argument."
fi

# The project is finaly finished
