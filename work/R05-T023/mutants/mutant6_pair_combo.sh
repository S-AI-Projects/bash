#!/usr/bin/env bash
# Mutant: drops IV (4) if output already contains XL (40)
# This bug causes combined subtractive pairs (such as XLIV or CDXLIV) to produce CDXLIIII instead of CDXLIV
values=( 1000 900 500 400 100 90 50 40 10 9 5 4 1 )
roman=(
    [1000]=M [900]=CM [500]=D [400]=CD 
    [100]=C  [90]=XC  [50]=L  [40]=XL 
    [10]=X   [9]=IX   [5]=V   [4]=IV
    [1]=I
)
output=""
num=$1
for value in "${values[@]}"; do
    if (( value == 4 )) && [[ $output == *XL* ]]; then
        continue
    fi
    while (( num >= value )); do
        output+=${roman[value]}
        ((num -= value))
    done
done
echo "$output"
