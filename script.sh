#!/bin/bash
#This program Add a new contact to the address book,Remove a contact from the address book and Display all the contacts in the address book
usage() {
    echo -e "Usage: $0 [-o <add|remove|display>]\n[OPTIONAL][-e <contact-email>][!MUST USE WITH DISPLAY OPTION] - To search a contact" 1>&2; exit 1;
}

# To check if there is directory else create

if [[ ( -d "~/Contacts" ) ]]
then
    mkdir ~/Contacts
fi

flag=0
# Getting options
if [ $# -eq 0 ];
then
    usage
    exit 0
else
while getopts ":o:e:h" o; do
    case "${o}" in
        o)
            ACTION=${OPTARG}
            ;;
        e)
            flag=1
            EMAIL=${OPTARG}
            ;;
        :)
            echo "ERROR: Option -$OPTARG requires an argument"
            usage
            exit
            ;;
#update starts here
        h)
            usage
#update ends here

    esac
done
fi

# If action is add getting inputs from user and write to txt file
if [[ $ACTION == "add" ]];
then
    echo "Enter name: "
    read NAME
    echo "Enter email: "
    read EMAIL
    echo "Enter address: "
    read ADDRESS
    echo "Enter phone number(s): "
    read PHONE

    printf "$NAME\n$EMAIL\n$ADDRESS\n$PHONE\n" > ~/Contacts/$EMAIL.txt


elif [[ $ACTION == "remove" ]]
then
    echo "Enter email for remove contact:"
    read EMAIL

    # Checking if contact exists and remove
    if [[ -f ~/Contacts/$EMAIL.txt ]]
    then
        rm ~/Contacts/$EMAIL.txt
    else
        echo "Contact does not exist!"
    fi

elif [[ $ACTION == "display" ]]
then
    # Checking any contact
    if [[ ( -f ~/Contacts/* ) ]]
    then
        echo "There is no record!"
        exit
    fi

    # Defining a array for keep contact data
    declare -a contact

    # Reading each contact file and storing an array
    for f in ~/Contacts/*.txt
    do
        contact=()
        while IFS= read -r line
        do
            #echo "$line"
            contact+=("$line")
        done < "$f"

        # If not using "-e" option with "display" option; Display every contact
        if [[ flag -eq "0" ]]
            then
                printf "\e[1;33mName :\e[0m ${contact[0]}\t\e[1;33mEmail :\e[0m ${contact[1]}\t\e[1;33mAddress : \e[0m${contact[2]}\t\e[1;33mPhone :\e[0m ${contact[3]}\n"

        # If using "-e" option, provide name,address or phone; display provided property
        elif [[ flag -eq 1 && $EMAIL == ${contact[1]} ]]
            then
            echo "Provide property (name | address | phone) :"
            read PROP

            if [[ ${PROP^^} == "NAME" ]]
            then
                printf "\e[1;33mName :\e[0m${contact[0]}\n"

            elif [[ ${PROP^^} == "ADDRESS" ]]
            then
                printf "\e[1;33mAddress :\e[0m${contact[2]}\n"

            elif [[ ${PROP^^} == "PHONE" ]]
            then
                printf "\e[1;33mPhone :\e[0m${contact[3]}\n"
            else
                printf "\e[1;33mWRONG CHOICE!\n"
                exit 1
            fi
        fi
    done
fi


