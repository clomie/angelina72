#!/bin/bash -eu
grep -i -F "layer $1" | perl -pe 's/.+?(\(xy.+\))\).+/$1/' | perl -pe 's/\(xy ([\d\.]+) ([\d\.]+)\) ?/[$1, $2],\n/g'
