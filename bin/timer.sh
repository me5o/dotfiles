#!/bin/bash
past=0
for i in $*
do
    sleep $((60 * ($i - $past)))
    growlnotify -t "Timer" -m "$i mitutes past."
    past=$i
done
