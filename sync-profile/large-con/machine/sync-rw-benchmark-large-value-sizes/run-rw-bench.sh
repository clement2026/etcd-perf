export RATIO_LIST="4/1"
export REPEAT_COUNT=3
export RUN_COUNT=50000
export VALUE_SIZE_POWER_RANGE="14 17"

echo RATIO_LIST=$RATIO_LIST
echo REPEAT_COUNT=$REPEAT_COUNT
echo RUN_COUNT=$RUN_COUNT
echo VALUE_SIZE_POWER_RANGE=$VALUE_SIZE_POWER_RANGE

date; cd ~/etcd-sync/tools/rw-heatmaps && ./rw-benchmark.sh && cd ~/etcd/tools/rw-heatmaps &&  sleep 30 &&./rw-benchmark.sh; date