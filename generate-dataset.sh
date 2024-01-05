#!/bin/bash

for file in ./content/gifs/*; do
    fileName=$(echo $file | awk -F/ '{print $NF}')
    length=$(exiftool $file | grep Duration | cut -d ":" -f 2 | sed "s/\s//g" | sed "s/s//g")
    millis=$(echo "$length * 1000" | bc | cut -d . -f 1)

    while [ $millis -lt 800 ]; do 
        millis=$(echo "$millis * 2" | bc | cut -d . -f 1)
    done

    name=$(echo $fileName | sed 's/\.[^.]*$//' )
    url="/content/gifs/${fileName}"
    jq -n --arg name $name --arg lengthInMillis $millis --arg url $url '{name: $name, url: $url, lengthInMillis: $lengthInMillis}'
done | jq -n '. |= [inputs]' > ./content/gifs.json