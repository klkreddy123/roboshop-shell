#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""

# If mongodb or mysql take t3.micro for others take t2.micro

for i in "${NAMES[@]}"
do
   if [[ $i=="mongodb" || $i=="mysql" ]]
    then
        INSTANCE_TYPE="t3.micro"
    else
        INSTANCE_TYPE="t2.micro"
    fi
done
