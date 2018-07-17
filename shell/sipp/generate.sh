#!/bin/bash

#!/bin/bash
dstfile="g-account.csv"
caller=1000
callee=1050

echo "RANDOM" > $dstfile
while [ $caller != 1050 ]
do
    echo "$caller;$callee;[authentication username=$caller password=1234]" >> $dstfile
    caller=$(($caller + 1))
    callee=$(($callee + 1))
done;
