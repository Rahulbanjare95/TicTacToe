#!/bin/bash

	read -p "Enter the  Row size " ROW_SIZE
	echo "Your Board is $ROW_SIZE X $ROW_SIZE "
	BOARD_SIZE=$(($ROW_SIZE*$ROW_SIZE))
	echo "Board has $BOARD_SIZE cells"
	userSymbol="o"
	compSymbol="o"
	quit=false
	validator=false
	position=0
	count=0
	declare -a board
	function resetBoard(){
		for (( position=1; position<=$BOARD_SIZE ; position++ )) do
      		board[$position]=0
      done
	}

	function displayBoard(){
		for (( count=1; count<=$BOARD_SIZE ; count++ ))
		do
			if [ "${board[$count]}" == "0" ]
         	then
					printf  _"|"
        	else
				printf ${board[$count]}"|"
         fi
			if [ $(( $count % $ROW_SIZE )) -eq 0 ]
				then
					echo
			fi
		done
	}

	function assignSymbol(){
		randomVariable=$((RANDOM%2))
		if [ $randomVariable -eq 0 ]
			then
				userSymbol="X"
		else
				compSymbol="X"
		fi
		echo "Your sign is "$userSymbol" and computer sign is "$compSymbol
	}

	function toss(){
		randomVariable=$((RANDOM%2))
		if [ $randomVariable -eq 0 ]
		then
			echo Your turn first you won toss
			first=user
		else
			echo Computer plays first computer won toss
			first=comp
   	fi
	}

	function validPositionChecker(){
		if [ "$visited" == "false" ]
        then

				if [ "$1" -gt "0"  -a "$1" -le "$BOARD_SIZE" ]
				then
					validator=true
				fi
				if [ "$validator" == "true" -a "${board[$1]}" == "0" ]
				then
					board[$1]=$2
					visited=true
				else
					validator=false
				fi
		fi
	}

	function computerPlay(){
		if [ "$visited" == "false" ]
      	then
				while [ "$validator" == "false" ]
	        	do
					number=$((RANDOM%BOARD_SIZE+1))
					validPositionChecker $number $compSymbol
				done
				validator=false
		fi
	}

	function userPlays(){
		while [ "$validator" == "false" ]
		do
		read -p "Please enter the number between 1-$BOARD_SIZE where insert your $userSymbol in board " input;
		validPositionChecker $input $userSymbol
		if [ "$validator" == "false" ]
		then
			echo "Invalid User Input"
		fi
		done
	}

	function winnerDisplay(){
		if [ "$1" == "$userSymbol" ]
		then
		echo "You won"
		else
		echo "Computer won"
		fi
	}

	function countRowSize(){
			count==$ROW_SIZE
         winnerDisplay $1
         quit=true
	}

	function diagonalEndingTopLeft(){
		if [ "$visited" == "false" ]
        then
			local count=0
			for (( position=1; position <= $BOARD_SIZE; position+=$((ROW_SIZE+1))  )) 
			do
			if [ ${board[$position]} == $1 ]
				then
					((count++))
			elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
       		then
          		cell=$position
			fi
			done
			if [ $count -eq $ROW_SIZE ]
				then
					countRowSize
			elif [ $count -ne $(($ROW_SIZE-1)) ]
	      	then
	                cell=0
			fi
		fi
	}

	function diagonalEndingTopRight(){
	if [ "$visited" == "false" ]
      then
			local cell=0
     		local count=0
			for (( position=$ROW_SIZE; position <= $((BOARD_SIZE-ROW_SIZE+1)); position+=$((ROW_SIZE-1)) ))
				do
       			if [ ${board[$position]} == $1 ]
      				then
       					(( count++ ))
		 			elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
 						then
							cell=$position
 		 			fi
      		done
     			if [ $count == $ROW_SIZE ]
  		  			then
						countRowSize
     			elif [ $count -ne $(($ROW_SIZE-1)) ]
        			then
	        			cell=0
     			fi
	fi
	}

	function rowChecker(){
	if [ "$visited" == "false" ]
		then
		local count=0
        for (( row=0;row<$ROW_SIZE;row++ ))
			do
          count=0
          cell=0
          for (( col=1; col<=$ROW_SIZE; col++ ))
			 do
            position=$((ROW_SIZE*row+col ))
         	if [ ${board[$position]} == $1 ]
      		then
               (( count++ ))
            elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
            then
               cell=$position
            fi
  	         done
				if [ $count == $ROW_SIZE ]
				then
					countRowSize
  	        	elif [ $count -ne $(( ROW_SIZE-1 )) ]
  	        	then
                cell=0
				else
					break
            fi
        done
	fi
	}

	function columnChecker(){
		if [ "$visited" == "false" ]
        then
		local count=0
		for (( col=1;col<=$ROW_SIZE;col++ ))
			do
        	count=0
         cell=0
         for (( row=0; row<=$ROW_SIZE; row++ ))
			do
          	position=$((ROW_SIZE*row+col ))
         	if [ "${board[$position]}" == "$1" ]
				then
               (( count++ ))
             elif [ "$cell" == "0" -a "${board[$position]}" == "0" ]
				 then
					cell=$position
             fi
        	done
			if [ $count == $ROW_SIZE ]
         then
            countRowSize
         elif [ $count -ne $(( ROW_SIZE-1 )) ]
         then
             cell=0
			 else
            	break
       	 fi
     		done
		fi
		}

	function block(){
	rowChecker $userSymbol
	validPositionChecker $cell $compSymbol
	columnChecker $userSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopRight $userSymbol
	validPositionChecker $cell $compSymbol
	diagonalEndingTopLeft $userSymbol
	validPositionChecker $cell $compSymbol
	}

	function corners(){
	if [ $visited == "false" ]
	then
		local position=1

		validPositionChecker 1 $compSymbol
		position=$((ROW_SIZE*0+ROW_SIZE))
		validPositionChecker $position $compSymbol
		position=$(( ROW_SIZE*$((ROW_SIZE-1)) + 1))

		validPositionChecker $position $compSymbol
		position=$(( ROW_SIZE*$((ROW_SIZE-1)) + ROW_SIZE))
		validPositionChecker $position $compSymbol
	fi
	}

	function winnerChecker(){
		rowChecker $compSymbol
		validPositionChecker $cell $compSymbol

		columnChecker $compSymbol
		validPositionChecker $cell $compSymbol

		diagonalEndingTopRight $compSymbol
		validPositionChecker $cell $compSymbol

		diagonalEndingTopLeft $compSymbol
		validPositionChecker $cell $compSymbol
	}

	function centre()
	{
	 if [ "$visited" == "false" ]
		then
			mid=$((ROW_SIZE/2))
			position=$(( $(( ROW_SIZE*mid)) + $((ROW_SIZE-mid)) ))
			validPositionChecker $position $compSymbol
		fi
	}
	function checkPossibleWins(){
		diagonalEndingTopRight $1
		diagonalEndingTopLeft $1
		rowChecker $1
		columnChecker $1
	}

  function sides()
   {
		local side=0
   if [ $visited == "false" ]
   then
   for (( "side"="1"; "side"<="$ROW_SIZE"; side++ ))
   do
      position=side
      validPositionChecker $position $compSymbol
   done

   for (( "side=1"; "side"<="$BOARD_SIZE"; side+=$ROW_SIZE ))
   do
      position=side
      validPositionChecker $position $compSymbol
   done

   for (( "side"="$((BOARD_SIZE-ROW_SIZE+1))"; "side"<="$BOARD_SIZE"; side++ ))
   do
      position=side
      validPositionChecker $position $compSymbol
   done
   for (( "side"="$ROW_SIZE"; "side"<="$BOARD_SIZE"; side++ ))
   do
      position=side
      validPositionChecker $position $compSymbol
   done
   fi
   }

	function Plays(){
		winnerChecker
		block
		corners
		centre
		sides
		computerPlay
	}

	function GameEnd()
	{
	local count=0
	for elements in ${board[@]}
	do
		if [ $elements == "0" ]
		then
			((count++))
		fi
		if [ $count -gt 0 ]
		then
			break
		fi
	done
	if [ $count -eq 0  -a $quit == "false" ]
	then
		echo "Draw"
		quit=true
	fi

	}
	function resetter(){
		 validator=false
         visited=false
	}

	function simulateTicTacToe()
	{
		resetBoard
		assignSymbol
		toss
		while [ $quit == false ]
		do
			resetter
			if [ $first == user ]
			then
				displayBoard
				userPlays
				resetter
				checkPossibleWins $userSymbol
				GameEnd
				first=comp
			fi

			if [ $first == comp -a $quit == false ]
			then
				Plays
				resetter
				checkPossibleWins $compSymbol
				GameEnd
				first=user
			fi
		done
	displayBoard
	}
	simulateTicTacToe


