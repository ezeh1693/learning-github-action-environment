#!/bin/bash

echo "Successfully executed dynamically generated script name for Insight"
printenv
echo "My secret Name: $MY_SECRET_NAME"
echo "My Secret: $MY_SECRET"

if [[ "$MY_SECRET" == "My Insight Secret" ]]; then
  echo "Secret is correct"
else
  echo "Secret is not correct"
fi