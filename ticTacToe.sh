 echo "Welcome to TIC TAC TOE "

   ROW_SIZE=3
   BOARD_SIZE=$((ROW_SIZE*ROW_SIZE))
	userSymbol=1
	compSymbol=0
	firstPlayer=0

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
      local count=0
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
		checker=false
		displayBoard
		assignSymbol
		echo "Choose a cell for your $userSymbol "
		read -p "Enter the choice in range 1 - $BOARD_SIZE : " inputPosition

		if [ $inputPosition -gt 0 -a $inputPosition -le $BOARD_SIZE ]
		then
			echo "Valid choice  $inputPosition in range"
		else
			echo "Invalid position out of range"
		fi

	}
	playerInputChecker

