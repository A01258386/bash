#!/bin/bash

# Defining usage function
usage() {
    echo "Usage: $0 [-u <URL>] [OPTIONAL][-f <filename>]" 1>&2; exit 1; # "1>&2" redirects output to stderr
}
URL=""
WRITETOFILE=false

# Getting arguments
while getopts "u:f:" o; do
    case "${o}" in
        u)
            # Setting URL variable from "-u" option
            URL=${OPTARG}
            ;;
        # If no argument passed to options
        :)
            echo "ERROR: Option -$OPTARG requires an argument"
            usage
            ;;

        f)
            # If argument f is passed
            WRITETOFILE=true
            FILENAME=${OPTARG}
            ;;
    esac
done

if [[ $WRITETOFILE == "true" && $URL != "" ]]
then
    # Getting html content from given URL with wget. Then parsing output with "a" header. Then getting URL from parsed output.
    # If argument f is passed, writes to file which name is given by user
    wget -qO - $URL | grep -o '<a href="http.*"' | awk -F[\"\"] '{print $2}' > "${FILENAME}"

elif [[ $WRITETOFILE == "false" && $URL != "" ]]
then
    wget -qO - $URL | grep -o '<a href="http.*"' | awk -F[\"\"] '{print $2}'
else
    usage
fi
