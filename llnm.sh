#!/bin/bash
 # This program output a file with line numbers
usage() {
    echo "Usage: $0 [file-name]" 1>&2; exit 1;
}


#update starts here
#cretae h option and n option to output line numbers
while getopts ":hn:" opt; do
    case $opt in
        h)
            usage
            ;;
        n)
            n=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;

    esac
done
#update ends here( n icin if gerekli)


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
