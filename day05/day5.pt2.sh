#!/bin/bash

# Read seed ranges from input file
seed_ranges=$(grep "seeds:" input.txt | awk '{for(i=2;i<=NF-1;i+=2) print $i,$(i+1)}')

# Read maps from input file
map_seed_to_soil=$(grep "seed-to-soil map:" -A 1000 input.txt | grep -v "seed-to-soil map:" | awk '{print $1,$2,$3}')
map_soil_to_fertilizer=$(grep "soil-to-fertilizer map:" -A 1000 input.txt | grep -v "soil-to-fertilizer map:" | awk '{print $1,$2,$3}')
map_fertilizer_to_water=$(grep "fertilizer-to-water map:" -A 1000 input.txt | grep -v "fertilizer-to-water map:" | awk '{print $1,$2,$3}')
map_water_to_light=$(grep "water-to-light map:" -A 1000 input.txt | grep -v "water-to-light map:" | awk '{print $1,$2,$3}')
map_light_to_temperature=$(grep "light-to-temperature map:" -A 1000 input.txt | grep -v "light-to-temperature map:" | awk '{print $1,$2,$3}')
map_temperature_to_humidity=$(grep "temperature-to-humidity map:" -A 1000 input.txt | grep -v "temperature-to-humidity map:" | awk '{print $1,$2,$3}')
map_humidity_to_location=$(grep "humidity-to-location map:" -A 1000 input.txt | grep -v "humidity-to-location map:" | awk '{print $1,$2,$3}')

# Function to perform conversion
convert() {
    local value=$1
    local map="$2"

    result=$(echo "$map" | while read line; do
        dest_start=$(echo $line | awk '{print $1}')
        source_start=$(echo $line | awk '{print $2}')
        range_length=$(echo $line | awk '{print $3}')
        
        if ((value >= source_start && value < source_start + range_length)); then
            echo $((dest_start + value - source_start))
            break
        fi
    done)

    echo "$result"
}

# Function to perform multiple conversions
convert_all() {
    local value=$1
    shift

    for map in "$@"; do
        value=$(convert $value "$map")
    done

    echo "$value"
}

# Find the lowest location number corresponding to any of the initial seed numbers
lowest_location=-1
for range in $seed_ranges; do
    start=$(echo $range | cut -d' ' -f1)
    length=$(echo $range | cut -d' ' -f2)

    for ((i = 0; i < length; i++)); do
        seed=$((start + i))
        location=$(convert_all $seed "$map_seed_to_soil" "$map_soil_to_fertilizer" "$map_fertilizer_to_water" "$map_water_to_light" "$map_light_to_temperature" "$map_temperature_to_humidity" "$map_humidity_to_location")
        
        if ((lowest_location == -1 || location < lowest_location)); then
            lowest_location=$location
        fi
    done
done

echo "Lowest location number: $lowest_location"