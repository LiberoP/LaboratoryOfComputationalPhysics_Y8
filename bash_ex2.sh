#!/bin/bash

read -p "Please provide number of files to create (and press Enter): " n

# ---> 2a:
grep -v "^#" "./data/data.csv" | sed -e "s/,//g" > "./data/data.txt"
# ---> substitute commas with spaces; NB g for global, ie not just first instance

# ---> 2b:
echo "Number of even numbers: "
grep -o "[0-9]\+" "./data/data.txt" | grep -c "[02468]$"
# ---> NB -o selects only matching part of line, each on a NEW line;
#      backslash for keeping meaning of "+", which stands for arbitrary repetition of charachter;
#      "$" for end of line

# ---> 2c:
threshold=$(echo "100 * sqrt(3) / 2" | bc -l)
#---> need command substitution and bc for calculation; "-l" loads math library
acc_g=0
acc_s=0
while read line; do # ---> NB this syntax
X=$(echo $line | awk '{print $1}') # ---> NB this syntax to get a certain column
Y=$(echo $line | awk '{print $2}')
Z=$(echo $line | awk '{print $3}')
radius=$(echo "sqrt($X*$X + $Y*$Y + $Z*$Z)" | bc -l)
if (( $(echo "$radius >= $threshold" | bc -l) )); # ---> NB needed for float comaprison
then
(( acc_g++ )) # ---> NB otherwise wouldnt do math
else
(( acc_s++ ))
fi
done < "./data/data.txt" # ---> NB this syntax
echo "Occurences greater than threshold: $acc_g; smaller than it: $acc_s"

# ---> 2d:
for (( i=1; i<=n; i++ ));
do
# ---> NB this (would be more compact with sed):
    while read line; do
        for num in $line; do
            result=$(echo "$num / $i" | bc -l)
            printf "%.2f " $result # ---> NB to fix number of decimal digits
        done
        echo "" # ---> NB to add new line
    done < "./data/data.txt" > "./data/data_$i.txt"
done