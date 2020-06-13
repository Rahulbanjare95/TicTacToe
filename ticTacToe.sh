 echo "Welcome to TIC TAC TOE "

   ROW_SIZE=3
   BOARD_SIZE=$((ROW_SIZE*ROW_SIZE))
	userSymbol=1
	compSymbol=0
	firstPlayer=0
	choice=0
   declare -a board

	function randomGenerator(){
		generator=$((RANDOM%2))
	}
	function boardinitializer()
	{
		for (( index =1; index<=$BOARD_SIZE; index++ ))
		do
			board[$index]=0
		done
	}

   function displayBoard()
   {

	  for (( count=1; count<=$BOARD_SIZE; count++ ))
      do
         if [[ ${board[$count]} -eq 0 ]]
         then
            printf _"|"
         else
            printf ${board[$count]}" "
         fi
         if [ $(( $count % $ROW_SIZE )) -eq 0 ]
         then
               echo
         fi
      done
   }

	function assignSymbol()
	{
	randomGenerator
	if [ $generator -eq $userSymbol ]
	then
		userSymbol="X"
		compSymbol="O"
	else
		userSymbol="O"
		compSymbol="X"
	fi
	echo "Player Symbol is $userSymbol and Computer Symbol is $compSymbol "

	}

	function tossFirstPlayer()
	{
	randomGenerator
	if [ $generator -eq $userSymbol ]
	then
		firstPlayer=human
		echo "HUMAN won toss"
	else
		firstPlayer=computer
		echo "Computer won toss"
	fi
	}

	function playerInputChecker()
	{
		boardInitializer
		assignSymbol
		validator=false
		while [ $validator -eq false ]
		do
		displayBoard
		echo "Choose a cell for your $userSymbol "
		read -p "Enter the choice in range 1 - $BOARD_SIZE : " inputPosition

		if [ $inputPosition -gt 0 -a $inputPosition -le $BOARD_SIZE ]
		then
			echo "Valid choice  $inputPosition in range"
					validator=true
				if [ validator -eq true -a ${board[$index]} -eq 0 ]
					then
						board[inputPosition]=$userSymbol
				fi
		else
			echo "Invalid position out of range"
		fi
		done

	}

	function columnChecker(){
		count=0
		for(( column=1; column<=$ROW_SIZE; column++ ))
		do
			for(( row=0; row<=$ROW_SIZE; row++ ))
			do
				index=$(($ROW_SIZE*row+column))
				if [ ${board[$index]}==$1 ]
				then
					(( count++ ))
				fi
			done
			if [ $count -eq $ROW_SIZE ]
			then
				winner $1
				quit=true
			fi
		done
	}

	function rowChecker()
	{
      count=0
      for(( row=0; row<=$ROW_SIZE; row++ ))
      do
         for(( column=1; column<=$ROW_SIZE; column++ ))
         do
            index=$(($ROW_SIZE*row+column))
            if [ ${board[$index]}==$1 ]
            then
               (( count++ ))
            fi
         done
         if [ $count -eq $ROW_SIZE ]
         then
            winner $1
            quit=true
         fi
      done
   }


	function diagonalEndingTopRight()
	{
    for (( position=1; position<=$BOARD_SIZE; position+=$((ROW_SIZE+1)) ))
		do
			if [ ${board[$position]} -eq $1 ]
			then
				((count++))
			fi
		done

	if [ $count -eq $ROW_SIZE ]
		then
			winner $1
			quit=true
	fi

	}
	function diagonalEndingTopLeft()
	{
	for (( position=$ROW_SIZE; position<=$((BOARD_SIZE+1-ROW_SIZE)); position+=$((ROW_SIZE-1)) ))
	do
		if [ ${board[$position]} -eq $1 ]
		then
			((count++))
		fi
	done
	if [ $count -eq $BOARD_SIZE ]
		then
			winner $1
			quit=true
	fi

	}

	function winnerChecker()
	{
		columnChecker $1
		rowChecker $1
		diagonalEndingTopRight $1
		diagonalEndingTopLeft $1
	}

	function invokeParametersSign(){

		echo $1
		winner $1
	}

	function winner(){
		if [ $1 -eq $userSymbol ]
		then
			echo "HUMAN WINS"
		else
			echo "Computer Wins"
		fi
	}

	execute=$( invokeParametersSign $userSymbol )
	echo $execute
