#!/bin/bash

# counnect to the database
PSQL="psql --username=freecodecamp --dbname=salon -t -c"

# display salon menu
SALON_MENU(){
  #check if an argument was passed
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  # display salon title
  echo -e "\n~~~~~ MY SALON ~~~~~\n"

  #display salon message
  echo -e "\nWelcome to my salon, how can i help you.\n"

  # get salon services
  SALON_SERVICES=$($PSQL "select * from services")
  echo "$SALON_SERVICES" | while read  SERVICE_ID BAR NAME BAR
  do
    if [[ $SERVICE_ID != "service_id" && $NAME != "name" ]]
    then
      echo  "$SERVICE_ID) $NAME"
    fi
    
  done
  # read the selected service id
  read SERVICE_ID_SELECTED

  
  
  #check is the id provides is a number
  if [[ !$SERVICE_ID_SELECTED =~ ^[0-9]$+ ]]
  then
    SALON_MENU "Please enter a valid number"
  else
    # check if the id selected is available
    SELECTED_ID=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
    
    if [[ -z $SELECTED_ID ]]
    then
      # send to main
      SALON_MENU "Please select an available service"
    else
      #get user phone number
      echo -e "\n What's your phone number?"
      read CUSTOMER_PHONE
      #check if the customer exists
      CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

      if [[ -z $CUSTOMER_ID ]]
      then
        #customer does not not exist
        #get user name
        echo -e "\nI don't have a record for that phone number, what is your name?"
        read CUSTOMER_NAME
        # add the customer to the customers table
        INSERT_CUSTOMER=$($PSQL "Insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
        #get service name
        SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
        #get user time
        echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
        read SERVICE_TIME
        #put the user down for a service
        #get customer id
        CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
        
        RESERVE_APPOINTMENT=$($PSQL "Insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
        
        echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      
      fi
      
    fi
  fi


}

SALON_MENU
