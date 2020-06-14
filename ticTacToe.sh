#!/bin/bash -x
	ROW_SIZE=3
	BOARD_SIZE=$(($ROW_SIZE*$ROW_SIZE))
	userSymbol="O"
	compSymbol="O"
	quit=false
	validator=false
	position=0
	count=0

	declare -A board

	function boardInitializer(){
        local position=0
        for (( position=1; position<=$BOARD_SIZE ; position++ )) 
			do
                board[$position]=0
        	done
	}

	function displayBoard(){
        local count=0
        for (( count=1; count<=$BOARD_SIZE ; count++ ))
			do
             if [ "${board[$count]}" == "0" ]
               then
                     printf  _" "
                else
                     printf ${board[$count]}" "
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
                echo User turn first
                firstPlay=user
        else
                echo Computer turn first
                firstPlay=computer
        fi
		}

	function validPositionChecker(){
		if [ "$visited" == "false" ]
		then

        if [ $1 -gt 0  -a $1 -le $BOARD_SIZE ]
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

	function computerPlays(){
      if [ "$visited" == "false" ]
		then
		  while [ "$validator" == "false" ]
        do
                number=$((RANDOM%9+1))
                validPositionChecker $number $compSymbol
        done
        validator=false
		fi
		}

	function userPlays(){

        while [ "$validator" == "false" ]
        do
                read -p "Please enter the number between 1-9 where insert your $userSymbol in board " input
                validPositionChecker $input $userSymbol
                if [ "$validator" == "false" ]
                then
                    echo Input not accepted please try again
                fi
        done
        validator=false
		}

	function diagonalEndingTopLeft(){
		if [ "$visited" == "false" ]
		then
			cell=0
		  local count=0
		  local increase_by=$((ROW_SIZE+1))
        for (( position=1; position <= $BOARD_SIZE; position+=$((ROW_SIZE+1)) ))
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
                winnerDisplay $1
                quit=true
        elif [ $count -ne $(($ROW_SIZE-1)) ]
			then
				cell=0
			fi
		fi

		}

	function diagonalEndingTopRight(){
		if [ "$visited" == "false" ]
		then

        local count=0
			cell=0
        for (( position=$ROW_SIZE; position <= $((BOARD_SIZE+1-ROW_SIZE)); position+=$((ROW_SIZE-1)) )) do
                if [ ${board[$position]} == $1 ]
                then
                        ((count++))
                elif [ "$cell" == "0" -a "${board[$position]}" == 0 ]
						then
							cell=$position
						fi

        done
        if [ $count == $ROW_SIZE ]
        then
                winnerDisplay $1
                quit=true
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
        position=0
        for (( row=0;row<$ROW_SIZE;row++ )) 
			do
                count=0
					cell=0
           for (( col=1; col<=$ROW_SIZE; col++ )) 
				do
               position=$(($ROW_SIZE*row+col ))
               if [ ${board[$position]} == $1 ]
               then
                    (( count++ ))
                elif [ "$cell" == "0" -a "${board[$position]}" == 0 ]
                  then
                     cell=$position
                  fi

              done
                if [ $count -eq $ROW_SIZE ]
                then
                        winnerDisplay $1
                        quit=true
								break
					elif [ $count -ne $(($ROW_SIZE-1)) ]
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
        position=0
        for (( col=1;col<=$ROW_SIZE;col++ )) do
                count=0
                for (( row=0; row<=$ROW_SIZE; row++ )) do
                        position=$(($ROW_SIZE*row+col ))
                        if [ "${board[$position]}" == "$1" ]
                        then
                                (( count++ ))
								 elif [ "$cell" == "0" -a "${board[$position]}" == 0 ]
                  then
                     cell=$position
                  fi

              done
                if [ $count -eq $ROW_SIZE ]
                then
                        winnerDisplay $1
                        quit=true
								break
               elif [ $count -ne $(($ROW_SIZE-1)) ]
               then
                  cell=0
               else
                  break

                fi
        done
        fi

		}

	function checkMoveToWin(){
	 diagonalEndingTopLeft $compSymbol
	validPositionChecker $cell $compSymbol
	 diagonalEndingTopRight $compSymbol
	validPositionChecker	$cell $compSymbol
	 rowChecker $compSymbol
	validPositionChecker $cell $compSymbol
	 columnChecker $compSymbol
	validPositionChecker $cell $compSymbol

	}
	function Block(){
	 	diagonalEndingTopLeft $userSymbol
   	validPositionChecker $cell $compSymbol
    	diagonalEndingTopRight $userSymbol
   	validPositionChecker $cell $compSymbol
    	rowChecker $userSymbol
   	validPositionChecker $cell $compSymbol
    	columnChecker $userSymbol
	 	validPositionChecker $cell $compSymbol
	}

	function checkForComp(){
		validPositionChecker
		Block
		computerPlays
	}

	function winnerCheck(){
        diagonalEndingTopLeft $1
        diagonalEndingTopRight $1
        rowChecker $1
        columnChecker $1
	}

	function winnerDisplay(){
        if [ $1 == $userSymbol ]
        then
                echo You won
        else
                echo Computer won
        fi
	}

	function simulateTicTacToe(){
        boardInitializer
        assignSymbol
        toss
        while [ $quit == false ]
        do
                displayBoard
                userPlays
                validator=false
						valid=false
                winnerCheck $userSymbol
                computerPlays
						valid=false
                winnerCheck $compSymbol
        done
        displayBoard
	}
	simulateTicTacToe

