#!/bin/bash
#Script that performs a search query in Google and Yandex and saves a page with the results
forGoogle="https://www.google.com/search?q="
forYa="https://yandex.ru/search/?text="
echo Enter your request: 
read text
forYa="$forYa$text"
text=`echo $text |sed 's/ /+/g'`
forGoogle="$forGoogle$text"
cd ~/Unix/ya
wget "$forYa"
cd ~/Unix/go
wget "$forGoogle"
