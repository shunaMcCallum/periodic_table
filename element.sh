#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number,atomic_mass,symbol,name,type,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$1")
else
  ELEMENT=$($PSQL "SELECT atomic_number,atomic_mass,symbol,name,type,melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $ELEMENT | while IFS=" |" read A_NUMBER A_MASS SYMBOL NAME TYPE M_POINT B_POINT ; do
  echo "The element with atomic number $A_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
done
