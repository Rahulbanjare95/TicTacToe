   echo "Welcome to TIC TAC TOE "

   ROW_SIZE=3
   BOARD_SIZE=$((ROW_SIZE*ROW_SIZE))
	user_symbol=1
	comp_symbol=0
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

	function assignSymbol(){

	generator=$((RANDOM%2))
	if [ $generator -eq $user_symbol ]
	then
		user_symbol="X"
		comp_symbol="O"
	else
		user_symbol="O"
		comp_symbol="X"
	fi
	echo "Player Symbol is $user_symbol and Computer_Symbol is $comp_symbol "

	}

	assignSymbol




