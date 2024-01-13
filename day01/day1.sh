#!/bin/bash

total=0
currentLineNumber=0

while IFS= read -r line; do
    currentLineNumber=$((currentLineNumber + 1))
    currentLinetotal=0

    for ((i=0; i<${#line}; i++)); do
        char="${line:$i:1}"
        if [[ $char =~ [0-9] ]]; then
            currentLinetotal=$((currentLinetotal * 10 + char))
        
        else
            total=$((total + currentLineNumber + currentLinetotal))
            currentLinetotal=0
        fi
    done

    total=$((total + currentLineNumber + currentLinetotal))1
done < "input.txt"

echo "total of line numbers and numbers in lines: $total"
