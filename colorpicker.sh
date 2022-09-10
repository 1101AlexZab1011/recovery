#! /bin/bash

square() {
    echo "$1^2" | bc
}

sqrt() {
    echo "scale=5; sqrt($1)" | bc
}

distance() {
    local point1=($1)
    local point2=($2)
    local distances=()

    for i in ${!point2[*]}; do
        local diff=$((${point1[$i]} - ${point2[$i]}))
        local diff2=$(square $diff)
        distances+=($diff2)
    done

    sum=$(IFS=+; echo "$((${distances[*]}))")

    echo $(sqrt $sum)
}

COLOR=$1
COLORARR=($COLOR)
R=$((16#${COLORARR: 0:2}))
G=$((16#${COLORARR: 2:2}))
B=$((16#${COLORARR: 4:2}))
wdistance=$(distance "$R $G $B" "255 255 255")
bdistance=$(distance "$R $G $B" "0 0 0")

if (( $(echo "$wdistance <= $bdistance" |bc -l) )); then
    echo "333333"
else
    echo "eeeeee"
fi
