	echo "Welcome to TIC TAC TOE "

	ROW_SIZE=3
	BOARD_SIZE=$((ROW_SIZE*ROW_SIZE))

	declare -a board

	function showBoard()
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

	showBoard
