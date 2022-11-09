#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

RESULT () {
  echo "The element with atomic number $ATOMIC_NUM is $ELEM_NAME ($ELEM_SYM). It's a $ELEM_TYPE, with a mass of $ELEM_MASS amu. $ELEM_NAME has a melting point of $ELEM_MELT celsius and a boiling point of $ELEM_BOIL celsius."
}

#argument check
if [ -z $1 ]
  then
  #if no argument, echo Please provide an element as an argument.
  echo "Please provide an element as an argument."
else
  #argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
    then
    ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMIC_NUM ]]
      then
      echo "I could not find that element in the database."
    else
      ELEM_NAME=$($PSQL "SELECT name FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
      ELEM_SYM=$($PSQL "SELECT symbol FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
      ELEM_TYPE=$($PSQL "SELECT type FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
      ELEM_MASS=$($PSQL "SELECT atomic_mass FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
      ELEM_MELT=$($PSQL "SELECT melting_point_celsius FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM") 
      ELEM_BOIL=$($PSQL "SELECT boiling_point_celsius FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
      RESULT
    fi
  else
    ELEM_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1' OR name='$1'")
    if [[ -z $ELEM_NAME ]]
      then
      echo "I could not find that element in the database."
    else
      ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ELEM_NAME'")
      ELEM_SYM=$($PSQL "SELECT symbol FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ELEM_NAME'")
      ELEM_TYPE=$($PSQL "SELECT type FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ELEM_NAME'")
      ELEM_MASS=$($PSQL "SELECT atomic_mass FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ELEM_NAME'")
      ELEM_MELT=$($PSQL "SELECT melting_point_celsius FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ELEM_NAME'") 
      ELEM_BOIL=$($PSQL "SELECT boiling_point_celsius FROM elements RIGHT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ELEM_NAME'")
      RESULT
    fi
  fi
fi