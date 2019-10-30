#!/bin/bash
#Script checking the existence of sites which name consists of 3 letters
r=".ru"
list=( a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9 0 - _ )
for i in ${list[*]}
do
  for j in ${list[*]}
  do
    for k in ${list[*]}
    do
      site="$i$j$k$r"
      echo $site
      ping -c 2 $site
      if [ $? -eq 0 ]
      then
        echo $site>>exists.txt
      else
        echo $site>>absent.txt
      fi
    done
  done
done
