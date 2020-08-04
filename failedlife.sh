#!/bin/bash

# FUNCTIONS MAP

# intro_msg
# counter

# calcnumber <-- MAIN FUNCTION
    # msg_victory
        # msg_vic_lineone
        # msg_vic_linetwo
    # msg_failure

# retry

# FUNCTIONS LISTING

intro_msg () {

title_array=(
            "_________________________________________________________"
            "< < < - Y O U - F A I L E D - I N - L I F E - > > >" 
            "Daniel Palacio © 2020" 
            "_________________________________________________________" 
)                

rows=$( tput lines )
loc_row=0

cols=$( tput cols )
loc_col=$(( $cols / 2 ))

clear

for line in "${title_array[@]}"; do
    
    loc_row=$(( $loc_row + 2 ))
    linelen=$( echo -n $line | wc -c )
    loc_col=$(( $loc_col - ( $linelen / 2 ) ))
    
    tput cup $loc_row $loc_col

    if [[ "$line" == "< < < - Y O U - F A I L E D - I N - L I F E - > > >" ]]; then
    
        tput bold;  echo "$line"; tput sgr0
        loc_col=$(( $loc_col + ( $linelen / 2 ) ))
        continue

    fi

    echo $line

    loc_col=$(( $loc_col + ( $linelen / 2 ) ))
    
done

echo ""; echo ""

}

counter () {

s=2

echo ""

while [ $s -gt 0 ]; do

    echo -ne "Starting in $s...\r"
    sleep 1s
    s=$(( $s - 1 ))

done

echo ""

}

# github.com/palaciodaniel

msg_victory () {

tput bold
tput civis
tput setab 2 # Green background
tput clear

msg_vic_lineone # Line 1

sleep 1s

msg_vic_linetwo # Line 2

sleep 3s

}

msg_vic_lineone () {

lineonemsg=("C" "O" "N" "G" "R" "A" "T" "U" "L" "A" "T" "I" "O" "N" "S" "!")

rows=$( tput lines )
lineone_locrow=$(( ( $rows / 2 ) - 2 ))

cols=$( tput cols )
lineonelen=$( echo ${#lineonemsg[@]} ) # Length of the array.
lineone_loccol=$(( ( $cols / 2 ) - $lineonelen ))

for letter in "${lineonemsg[@]}"; do # This will print every letter from the array.

    tput cup $lineone_locrow $lineone_loccol
    echo $letter
    sleep 0.13s
    lineone_loccol=$(( $lineone_loccol + 2 )) # This allows for the letter to appear as if they're being written on the moment.

done

}

msg_vic_linetwo () {

linetwomsg="You didn't fail in life!"

rows=$( tput lines )
linetwo_locrow=$(( $rows / 2 ))

cols=$( tput cols )
linetwolen=$( echo -n $linetwomsg | wc -c ) # Length of the string.
linetwo_loccol=$(( ($cols / 2) - ( $linetwolen / 2 ) ))

tput cup $linetwo_locrow $linetwo_loccol
echo $linetwomsg

}

msg_failure () {

# Variables

falmessage="YOU FAILED IN LIFE"

rows=$( tput lines )
middle_row=$(( ( $rows / 2 ) - 2 ))

cols=$( tput cols )
msglength=$( echo -n $falmessage | wc -c )
middle_col=$(( ($cols / 2) - ( $msglength / 2 ) ))

# Code

tput bold
tput civis
tput setab 1 # Red background
tput clear

tput cup $middle_row $middle_col
echo $falmessage

sleep 3s

}

calcnumber () {

# Variables

defaultps1=$PS1
FBRIGHTGREEN="\033[0;92m" # Green font.
RESET="\033[0m" # Reset font color.

num=1
multiplier=5

# Code

while [ $num -lt 11 ]; do

    number1=$(( RANDOM % $multiplier )) ; number2=$(( RANDOM % $multiplier ))

    echo "" ; tput bold; tput smul; echo "CALCULATION $num/10:"; tput sgr0

    read -t 6 -p "$number1 "+" $number2 = " user_input
        
        if [ $user_input -eq $(( $number1 + $number2 )) ]; then # While you keep guessing...
            echo -e "${FBRIGHTGREEN}CORRECT!"${RESET}
            num=$(( $num + 1 ))

            if [ $num -eq 11 ]; then
                msg_victory
                tput sgr0; tput cup $( tput lines ) 0; tput cnorm
                clear
            fi

            multiplier=$(( $multiplier * 2 ))
            number1=$(( RANDOM % $multiplier )); number2=$(( RANDOM % $multiplier ))
        else # If you fail...
            num=11
            msg_failure
            tput sgr0; tput cup $( tput lines ) 0; tput cnorm
            clear
        fi

done

}

retry () {

# Variables

FBRIGHTYELLOW="\033[0;93m" # Yellow font.
RESET="\033[0m" # Reset font color.

goodbyemsg="- - Thank you for playing! See you later! - -"
goodbyelen=$( echo -n $goodbyemsg | wc -c )

# Code

while true; do

    intro_msg
    
    tput bold
    read -p "- Retry? (Y/N): " yesorno
    tput sgr0

    case $yesorno in
        [Yy]* ) 
                counter;
                calcnumber;;
        [Nn]* ) 
                intro_msg;
                echo "";
                tput cup $(( $loc_row + 2 )) $(( ( $cols / 2 ) - ( $goodbyelen / 2 ) ))
                echo -e "${FBRIGHTYELLOW}$goodbyemsg${RESET}";
                echo ""; 
                break;;
        * ) 
                echo "";;
    esac

done

}

# GAME EXECUTION CODE

intro_msg
counter
calcnumber
retry

