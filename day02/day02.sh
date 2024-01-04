#!/bin/bash

counter=0
possible_games=""

while IFS= read -r line; do
    ((counter++))
    
    # Extract game ID and cube information
    game_id=${line%%:*}
    cubes_info=${line#*:}

    # Split cube information into individual subsets
    IFS=';' read -ra subsets <<< "$cubes_info"
    
    valid_game=true

    # Check each subset for cube counts
    for subset in "${subsets[@]}"; do
        IFS=', ' read -ra cubes <<< "$subset"
        for cube in "${cubes[@]}"; do
            color=${cube#*,}
            count=${cube%,*}
            
            # Check if the cube count matches the expected values
            #echo "$cube"
            echo "$count"
            echo "$color"
            if [[ $color == "red" ]] && [[ $count -le 12 ]]; then
                valid_game=true
            elif [[ $color == "green" ]] && [[ $count -le 13 ]]; then
                valid_game=true
            elif [[ $color == "blue" ]] && [[ $count -le 14 ]]; then
                valid_game=true
            else
                valid_game=false
            fi
            #case $color in
            #    "red")   [[ $count != 12 ]] && valid_game=false ;;
            #    "green") [[ $count != 13 ]] && valid_game=false ;;
            #    "blue")  [[ $count != 14 ]] && valid_game=false ;;
            #esac
        done
    done

    # If the game is valid, add its ID to the list
    echo "Line: $line, Game ID: $game_id, Valid Game: $valid_game"
    echo $valid_game
    game_id="${game_id:5}"
    echo "$game_id"
    if [ $valid_game == true ]; then
    echo "hi"
    possible_games=$((possible_games + game_id))
    fi
    
done < input.txt

echo "Possible games: $possible_games"