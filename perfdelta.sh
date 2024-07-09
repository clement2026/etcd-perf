#!/bin/bash

# Function to calculate average of three colon-separated values
calculate_average() {
    IFS=":" read -r val1 val2 val3 <<< "$1"
    avg=$(echo "scale=6; ($val1 + $val2 + $val3) / 3" | bc)
    echo "$avg"
}

# Ensure two files are provided as input
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 main.csv patch.csv"
    exit 1
fi

main_file=$1
patch_file=$2

# Check if files exist
if [ ! -f "$main_file" ] || [ ! -f "$patch_file" ]; then
    echo "Both input files must exist."
    exit 1
fi

# Process files and compute performance deltas
awk -F, '
function calculate_avg(values, avg) {
    split(values, iter, ":")
    avg = (iter[1] + iter[2] + iter[3]) / 3
    return avg
}

BEGIN {
    delta_list = ""
    print "Processing files..."
}

NR==FNR && FNR > 1 {
    # Store main_file results in an array
    avg_main = calculate_avg($5)
    main_avg[$2 "," $3 "," $4] = avg_main
    next
}

NR!=FNR && FNR > 1 {
    # Get patch_file results and compare with main_file
    avg_patch = calculate_avg($5)
    key = $2 "," $3 "," $4
    if (key in main_avg) {
        delta = ((avg_patch / main_avg[key]) - 1) * 100
        delta_list = delta_list delta "\n"
    }
}

END {
    print delta_list | "sort -n"
}
' "$main_file" "$patch_file"
