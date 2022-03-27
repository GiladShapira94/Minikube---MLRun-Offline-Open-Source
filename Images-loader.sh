#!/bin/bash

for f in All_Images/*.tar; do
    echo "---------Start loading ----------------"
    echo "Image:" $f
    docker load --input $f
    echo "-------------Done----------------------"
done
