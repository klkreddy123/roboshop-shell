#!/bin/bash

NAMES=("mongodb" "redis" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${NAMES[@]}"
do
    echo "NAME: $i"
done
