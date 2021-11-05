#!/bin/bash
 # This program output a file with line numbers
usage() {
    echo "Usage: $0 [file-name]" 1>&2; exit 1;
}

if [[ !( -f $1 ) ]];
    then
        echo "There is no file!"
        exit
else

    line_count=1
    while IFS= read -r line
        do

            echo "$line_count. $line"
            line_count=$(expr $line_count + 1)

        done < "$1"

fi
