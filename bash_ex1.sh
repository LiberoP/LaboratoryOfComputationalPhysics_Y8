#!/bin/bash

# ---> NB RUN THIS IN LINUX ENVIRONMENT (eg WSL2)
# ---> 1a:
mkdir $HOME/labcomput/students
initial_path="$HOME/labcomput/LCP_22-23_students.csv" # ---> NB no "$", no spaces before/after "=" when assigning new variable
wget -O $initial_path "https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&dl=1"
# ---> replaced e with dl in link for immediate download;
#      by default saves in current location

final_path="$HOME/labcomput/students/LCP_22-23_students.csv" 

if [ ! -f "$final_path" ];
then
mv $initial_path $final_path
else
echo "File already existed in final destination. Delete it to continue."
fi

# ---> 1b
grep "PoD" $final_path > "$HOME/labcomput/students/LCP_22-23_students_PoD.csv"
grep "Physics" $final_path > "$HOME/labcomput/students/LCP_22-23_students_Physics.csv"

# ---> 1c-d:
file_length=$(grep -c "^" $final_path) # ---> NB needs parentheses for command substitution
noheader_path="$HOME/labcomput/students/LCP_22-23_students_noheader.csv"
tail -n +2 $final_path > $noheader_path # ---> NB to skip 2-1=1 lines at beginning

for i in {A..Z}; 
do
echo -n "$i: " >> $HOME/labcomput/students/counts.txt # ---> NB this line
grep -c "^$i" $noheader_path >> $HOME/labcomput/students/counts.txt; # ---> for selecting columns can also use "cut"
# ---> NB ">>" to append, ">" to overwrite
done

# ---> 1d 
sort -t':' -k2 -n $HOME/labcomput/students/counts.txt | tail -1 
# ---> NB to sort by count and show highest (prints to screen):
#     -t sets delimiter, -k the position to consider, -n sorts (highest to lowest) numerically

# ---> 1e
for (( i=1; i<=18; i++ ));
do
newfile_path="$HOME/labcomput/students/students_group_$i.csv"
for (( j=i; j<=($file_length-1); j+=18 )) # ---> NB the "+="
do sed -n "${j}p" $noheader_path >> $newfile_path
# ---> NB to get j-th line ("p" is print command, "${j}" the address where command is executed), "-n" prevents other stuff to be printed
done
done

# the task was the following:
# Exercise 1:
# 1\.a Make a new directory called `students` in your home. Download a csv file with the list of students of this lab from [here](https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv) (use the `wget` command) and copy that to `students`. First check whether the file is already there
# 1\.b Make two new files, one containing the students belonging to PoD, the other to Physics.
# 1\.c For each letter of the alphabet, count the number of students whose surname starts with that letter. 
# 1\.d Find out which is the letter with most counts.
# 1\.e Assume an obvious numbering of the students in the file (first line is 1, second line is 2, etc.), group students "modulo 18", i.e. 1,19,37,.. 2,20,38,.. etc. and put each group in a separate file  
