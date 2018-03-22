#!/usr/bin/env bash

options=$1
file=$2

cert=$(openssl $options -out $file)

if [[ $cert = *"BEGIN"* ]]; then
  echo $cert > $file
fi

if grep -q BEGIN "$file"; then
  echo "Sucessfull"
  exit 0
fi

echo "Error occured"
exit 1