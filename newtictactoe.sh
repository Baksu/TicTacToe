printf "\033c"
declare board_state
declare current_player="X"
declare player=1
declare move_counter=0
declare is_end=0

line_horizontal_solid="---------"
separator="|"

function initBoard
{
	board_state=(1 2 3 4 5 6 7 8 9)
}

function drawBoard
{
	printf "\033c"
	i=0
	for item in ${board_state[*]}
	do
		printf "|%s|" $item
		((i++))
		if (($i%3 == 0)); then
			printf "\n%s\n" $line_horizontal_solid
		fi
	done	
	if (($is_end == 1)); then
		printf "PLAYER %s WON\n" $current_player
	elif (($is_end == 2)); then
		printf "TIE"
	fi
}

function writeMove
{
	printf "\nCurrent player: %s\n" $current_player
	printf "Choose number: "
	read action

	setMove $action
}

if [ "$x" == "X" ]; then
  echo "x has the value 'valid'"
fi

function checkWinner
{
	#check rows
	for ((i=0;i<7;i+=3))do
		if [ "${board_state[$i]}" == "${board_state[$(($i+1))]}" ] && 
		[ "${board_state[$(($i+1))]}" == "${board_state[$(($i+2))]}" ]; then
			is_end=1
		fi
	done
	#check columns
	for ((i=0;i<3;i++))do
		if [ "${board_state[$i]}" == "${board_state[$(($i+3))]}" ] && 
		[ "${board_state[$(($i+1))]}" == "${board_state[$(($i+6))]}" ] ;then
			is_end=1
		fi
	done

	if [ "${board_state[0]}" == "${board_state[4]}" ] && 
		[ "${board_state[4]}" == "${board_state[8]}" ] ;then
			is_end=1
	fi

	if [ "${board_state[2]}" == "${board_state[4]}" ] && 
		"${board_state[4]}" == "${board_state[6]}" ] ;then
			is_end=1
	fi

	if(($move_counter == 9)); then
		is_end=2
	fi
}

function changePlayer
{	
	if(($player == 1)); then
		current_player="O"
		player=0
	else
		current_player="X"
		player=1
	fi
}

function setMove
{
	if [[ ! $1 =~ ^-?[0-9]+$ ]]; then
		drawBoard
		printf "\nChoose a number in the range [1-9]. Try again."
		writeMove
	elif(("${board_state[$1-1]}" == "X")) || (("${board_state[$1-1]}" == "O")); then
		drawBoard
		printf "\nInvalid move. Try again."
		writeMove
	else
		((move_counter++))
		board_state[$1-1]=$current_player
		checkWinner
		if(($is_end == 0)); then
			changePlayer
		fi
	fi
}

initBoard
while [ true ]
do
	drawBoard
	if(($is_end == 0)); then
		writeMove
	else
		printf "\nEnd Game (Enter)"
		read end
		exit
	fi
done
