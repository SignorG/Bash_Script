#!/bin/bash 

## Create a Directory where we will store our Bookmarks.
## Our goal is to have a csv file with the link of bookmarks
## and a .lz4json that can be used as a replacement


DIR_NAME=~/Documents/bookmarks_backup
if [ -d "$DIR_NAME" ];
then
 echo "Directory Already Exist."
else
 echo "Directory Created"
 mkdir ~/Documents/bookmarks_backup
fi

## looking for our lz4json
## with sort in combination with tail -1 we should be able to take the latest backup

our_json=$(find ~/.mozilla/firefox/ -name "*bookmarks*" | sort | tail -1)
echo "The path of our json is:"
echo $our_json

rm ~/Documents/bookmarks_backup/*   #that was just for testing poupose

cp $our_json ~/Documents/bookmarks_backup/

echo " "
echo "Our jsonlz4 has been copied to $DIR_NAME"
ls ~/Documents/bookmarks_backup/

## notice that the jsonlz4 is a proprietary json format of mozilla
## you may need to install the lz4json package to run the following command
## that converts the jsonlz4 in a normal json format 

lz4jsoncat $our_json > ~/Documents/bookmarks_backup/bookmarks.json 

## we have created a normal json file, which we can work.
## even if we are gonna treat it like a common text file

echo " "
echo "The normal json file after the creation:"
cd ~/Documents/bookmarks_backup/
ls

## now the first thing we noticed that bookmarks.json is like a one bigstrin, let's divide it

sed 's/,/\n/g' bookmarks.json > bookmarks.list

#we divided our json in a list
#we also noticed that all our link are stored under "uri" name

#cat bookmarks.json
(echo "$(<bookmarks.list)" | grep '"uri"') > bookmarks_filter.list
echo " " 
echo "Our bookmarks list, still a little bit raw anyway"
cat bookmarks_filter.list  

## let's get rid of "uri": and also of the brackets and the quotes

sed -i 's/"uri"://g' bookmarks_filter.list
sed -i 's/"//g'      bookmarks_filter.list
sed -i 's/}//g'      bookmarks_filter.list
sed -i 's/]//g'      bookmarks_filter.list

echo " "
echo "And finally our clean list of Bookmarks!"
cat bookmarks_filter.list

rm bookmarks.list # we dont need anymore
echo "Ok!"

ls
