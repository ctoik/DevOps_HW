#!/bin/bash

min=1
max=20

echo Please set number from $min to $max:;

read number

echo " "
## start validation
# is number
re='^[0-9]+$'
if ! [[ $number =~ $re ]] ; then
   echo "ValidationError: Not a number"
   exit 2
fi

# is in range
if ! (($number >= min && $number <= max)); then
  echo "ValidationError: Number is out of the range"
  exit 2
fi
## end validation

echo "Countdown..."

for (( i=0; i < number; i++ ));
do
	echo $((number-$i));
done
