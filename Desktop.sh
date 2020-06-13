declare -A board
BOARD_ROWS=3
BOARD_SIZE=$(($BOARD_ROWS*$BOARD_ROWS))
USER_SIGN="O"
COMP_SIGN="O"
stop=false
valid=false
position=0

function initialize_Board(){
	local key=0
	for (( key=1; key<=$BOARD_SIZE ; key++ )) do
  	board[$key]=0
      	done
}

function show_Board(){
	local count=0
	for (( count=1; count<=$BOARD_SIZE ; count++ )) do
		if [ "${board[$count]}" == "0" ]
         	then
			printf  _" "
        	else
			printf ${board[$count]}" "
         	fi
		if [ $(( $count % $BOARD_ROWS )) -eq 0 ]
		then
			echo
		fi
	done
}

function toss_Assign_Sign(){
	randomVariable=$((RANDOM%2))
	if [ $randomVariable -eq 0 ]
	then
		USER_SIGN="X"
	else
		COMP_SIGN="X"
	fi
	echo "Your sign is "$USER_SIGN" and computer sign is "$COMP_SIGN
}

function toss_Plays_First(){
	randomVariable=$((RANDOM%2))
	if [ $randomVariable -eq 0 ]
	then
		echo You play first
		first=user
	else
		echo Computer plays first
		first=comp
   	fi
}

function check_Valid(){
	if [ "$added" == "false" ]
        then

		if [ $1 -gt 0  -a $1 -le $BOARD_SIZE ]
		then
			valid=true
		fi
		if [ "$valid" == "true" -a "${board[$1]}" == "0" ]
		then
			board[$1]=$2
			added=true
		else
			valid=false
		fi
	fi
}

# It is if nothing else if where we can add our Sign
function comuter_Plays_Random(){
	if [ "$added" == "false" ]
        then

		while [ "$valid" == "false" ]
	        do
			number=$((RANDOM%9+1))
			check_Valid $number $COMP_SIGN
		done
		valid=false
	fi
}

function take_User_Input(){
	while [ "$valid" == "false" ]
	do
		read -p "Please enter the number between 1-9 where insert your $USER_SIGN in board " input;
		check_Valid $input $USER_SIGN
		if [ "$valid" == "false" ]
		then
			echo Input not accepted please try again
		fi
	done

}

function send_var(){
	echo $1
	wins $1
}

function wins(){
	if [ $1 == $USER_SIGN ]
	then
		echo "You won"
	else
		echo "Computer Wins"
	fi
}

function search_Daigonal_Left_Right(){
	if [ "$added" == "false" ]
        then

		local count=0
		local increase_by=$((BOARD_ROWS+1))
		position=0
		for (( daig_Key=1; daig_Key <= $BOARD_SIZE; daig_Key+=$increase_by )) do
			if [ ${board[$daig_Key]} == $1 ]
			then
				((count++))
			elif [ "$position" == "0" -a "${board[$daig_Key]}" == "0" ]
	                then
	                	position=$daig_key
			fi
		done
		if [ $count -eq $BOARD_ROWS ]
		then
			wins $1
			stop=true
		elif [ $count -ne $(($BOARD_ROWS-1)) ]
	        then
	                position=0
		fi
	fi
}

function search_Daigonal_Right_Left(){
	if [ "$added" == "false" ]
        then

	        local count=0
	        local increase_by=$((BOARD_ROWS-1))
		local left_Bottom_Limit=$((BOARD_SIZE-BOARD_ROWS+1))
	        position=0
		for (( daig_Key=$BOARD_ROWS; daig_Key <= $left_Bottom_Limit; daig_Key+=$increase_by )) do
	                if [ ${board[$daig_Key]} == $1 ]
	                then
	                	(( count++ ))
			elif [ "$position" == "0" -a "${board[$daig_Key]}" == "0" ]
	                then
	        		position=$daig_Key
	                fi
	        done
	        if [ $count == $BOARD_ROWS ]
	        then
	                wins $1
			stop=true
	        elif [ $count -ne $(($BOARD_ROWS-1)) ]
	        then
		        position=0
	        fi
	fi
}

function search_Rows_To_Get_Position(){
	if [ "$added" == "false" ]
	then
		local count=0
	        key=0
	        for (( row=0;row<$BOARD_ROWS;row++ )) do
	                count=0
	                position=0
	                for (( col=1; col<=$BOARD_ROWS; col++ )) do
	                        key=$((BOARD_ROWS*row+col ))
	                        if [ ${board[$key]} == $1 ]
	                        then
	                                (( count++ ))
	                        elif [ "$position" == "0" -a "${board[$key]}" == "0" ]
	                        then
        		                position=$key
        	                fi
        	        done
        	        if [ $count -ne $(( BOARD_ROWS-1 )) ]
        	        then
        	                position=0
			else
				break
	                fi
	        done
	fi
}

function search_Rows_If_Won(){
	local count=0
	key=0
	for (( row=0; row<$BOARD_ROWS; row++ )) do
		count=0
		for (( col=1; col<=$BOARD_ROWS; col++ )) do
			key=$(( BOARD_ROWS*row+col ))
			if [ ${board[$key]} == $1 ]
			then
				(( count++ ))
			fi
		done
		if [ $count -eq $BOARD_ROWS ]
		then
			wins $1
			stop=true
			break
		fi
	done
}

function search_Columns_To_Get_Position(){
	if [ "$added" == "false" ]
        then

		local count=0
		key=0
		for (( col=1;col<=$BOARD_ROWS;col++ )) do
		        count=0
		        position=0
		        for (( row=0; row<=$BOARD_ROWS; row++ )) do
		                key=$((BOARD_ROWS*row+col ))
		                if [ "${board[$key]}" == "$1" ]
				then
		                        (( count++ ))
		                elif [ "$position" == "0" -a "${board[$key]}" == "0" ]
				then
					position=$key
		                fi
		        done
		        if [ $count -ne $(( BOARD_ROWS-1 )) ]
		        then
		               position=0
			else
				break
		        fi
		done
	fi
}

function search_Columns_If_Won(){
	if [ "$added" == "false" ]
        then
		local count=0
		key=0
		for (( col=1;col<=$BOARD_ROWS;col++ )) do
		        count=0
		        for (( row=0; row<=$BOARD_ROWS; row++ )) do
		                key=$(($BOARD_ROWS*row+col ))
		                if [ "${board[$key]}" == "$1" ]
		                then
		                        (( count++ ))
		                fi
		        done
		        if [ $count -eq $BOARD_ROWS ]
		        then
		                wins $1
				stop=true
				break
			fi
		done
	fi
}

function block_Opponent(){

	search_Rows_To_Get_Position $USER_SIGN
	check_Valid $position $COMP_SIGN
	search_Columns_To_Get_Position $USER_SIGN
	check_Valid $position $COMP_SIGN
	search_Daigonal_Left_Right $USER_SIGN
	check_Valid $position $COMP_SIGN
	search_Daigonal_Right_Left $USER_SIGN
	check_Valid $position $COMP_SIGN

}



function take_Corners(){
	if [ $added == "false" ]
	then 
		local key=1
		check_Valid $key $COMP_SIGN
		
		key=$((BOARD_ROWS*0+BOARD_ROWS))
		check_Valid $key $COMP_SIGN
		
		key=$(( BOARD_ROWS*$((BOARD_ROWS-1)) + 1))	
		check_Valid $key $COMP_SIGN
		
		key=$(( BOARD_ROWS*$((BOARD_ROWS-1)) + BOARD_ROWS))
		check_Valid $key $COMP_SIGN
	fi
	
}

function take_Center(){
	if [ $added == "false" ]
	then 	
		num_Rows_Ahead=$((BOARD_ROWS/2))
		local key=$(( $(( BOARD_ROWS*num_Rows_Ahead )) + $((BOARD_ROWS-num_Rows_Ahead )) ))
		check_Valid $key $COMP_SIGN
	fi
}

function check_If_Can_Win(){
	search_Rows_To_Get_Position $COMP_SIGN
	check_Valid $position $COMP_SIGN
	search_Columns_To_Get_Position $COMP_SIGN
	check_Valid $position $COMP_SIGN
	search_Daigonal_Left_Right $COMP_SIGN
	check_Valid $position $COMP_SIGN
	search_Daigonal_Right_Left $COMP_SIGN
	check_Valid $position $COMP_SIGN
}

function check_Win(){
	search_Daigonal_Left_Right $1
	search_Daigonal_Right_Left $1
	search_Rows_If_Won $1
	search_Columns_If_Won $1
}

function comp_Plays(){
	check_If_Can_Win
	block_Opponent
	take_Corners
	take_Center
	comuter_Plays_Random
}

function is_Game_Over(){
	local count=0
	for values in ${board[@]}
	do
		if [ $values == "0" ]
		then
			((count++))
		fi
		if [ $count -gt 0 ]
		then
			break
		fi
	done
	if [ $count -eq 0  -a $stop == "false" ]
	then
		echo "It's a tie"
		stop=true
	fi
	
}

function play(){
	initialize_Board
	toss_Assign_Sign
	toss_Plays_First
	while [ $stop == false ]
	do
		valid=false
		added=false
		
		if [ $first == "user" ]
		then	
			show_Board
			take_User_Input
			valid=false
			added=false
	#		echo ${board[@]}
			check_Win $USER_SIGN
			is_Game_Over
			first=comp
		fi		
		if [ $first == "comp" -a $stop == "false" ]
		then
			comp_Plays
			added=false		
			check_Win $COMP_SIGN
			is_Game_Over
			first=user
		fi
	done
	show_Board
}

play

