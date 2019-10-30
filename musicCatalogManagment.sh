#!/bin/bash
#Script for adding music files from other folders or the Internet to a special directory
log(){
  message="$USER $(date) $1 $2"
  echo $message >> ~/Unix/music/logfile.txt
}
while true
do
  echo "Enter command:"
  echo "add - to add a new file"
  read command
  case $command in
    add )
      echo "Enter the path where the file lies"
      echo "//dir... - if it lies on the computer"
      echo "http://... - if it is on the Internet"
      read path
      if [ "`echo $path | cut -c 1`" = "\/" ]
      then
        file=$(basename $path)
        exp=`echo $file | sed 's#.*\.##g'`
        if [[ $exp == mp3 || $exp == wav || $exp == flac ]]
        then
          cp $path ~/Unix/music
          if [ $? -eq 0 ]
          then
            log $command $file
          fi
        else
          echo "File must have .mp3, .wav or .flac extension"
        fi
      elif [ "`echo $path |cut -c 1`" = "h" ]
      then
        file=`echo $path | sed 's#.*\/##g'` #file's name
        exp=`echo $file | sed 's#.*\.##g'`
        if [[ $exp == mp3 || $exp == wav || $exp == flac ]]
        then
          cd ~/Unix/music
          wget $path >/dev/null
          log $command $file
          cd -
        else
          echo "File must have .mp3, .wav or .flac extension"
        fi
      else
        echo "File path is incorrect"
      fi
    ;;
  esac
done
