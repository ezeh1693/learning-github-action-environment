#!/bin/bash

echo "Successfully executed dynamically generated script name for Andela"
echo "My secret Name: $MY_SECRET_NAME"
echo "My Secret: $MY_SECRET"

if [[ "$MY_SECRET" == "My Andela Secret" ]]; then
  echo "Secret is correct"
else
  echo "Secret is not correct"
fi