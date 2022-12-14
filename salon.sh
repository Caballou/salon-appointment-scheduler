#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to my salon, how can I help you?" 



MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n1) cut \n2) color \n3) brushing \n4) perm \n5) style"

  read SERVICE_ID_SELECTED

  if [[ $SERVICE_ID_SELECTED > 5 || $SERVICE_ID_SELECTED =~ '^[0-9]+$' ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else

    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"

  read SERVICE_TIME

  INSERT_SERVICE_TIME=$($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME')")
  fi


  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU