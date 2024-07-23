export RATIO_LIST="4/1"
export REPEAT_COUNT=3
export RUN_COUNT=50000

echo RATIO_LIST=$RATIO_LIST
echo REPEAT_COUNT=$REPEAT_COUNT
echo RUN_COUNT=$RUN_COUNT

date; cd ~/sync/tools/rw-heatmaps && ./rw-benchmark.sh; date;