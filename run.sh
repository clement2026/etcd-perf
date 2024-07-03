#!/bin/bash

ETCD_BIN="./bin/etcd"
ETCD_BM_BIN="./bin/tools/benchmark"
BACKEND_SIZE="$((20 * 1024 * 1024 * 1024))" # 20gb
KEY_SPACE_SIZE="$((1024 * 64))"
RATIO="4.0"
KEY_SIZE="256"
RUN_COUNT="1000000"
RANGE_RESULT_LIMIT="100"
VALUE_SIZE="$((2 ** 14))" # VALUE_SIZE="$((2 ** 14))" # from 256 to 16384
CONN_CLI_COUNT="$((2**11))" # CONN_CLI_COUNT="$((2**11))" # from 32 to 2048

echo "CONN_CLI_COUNT=${CONN_CLI_COUNT}"
echo "VALUE_SIZE=${VALUE_SIZE}"

function main() {
case $1 in
  "start")
    run_etcd_server
    ;;
  "clean")
    clean
    ;;
  "init")
    init_etcd_db
    ;;
  "write")
    write
    ;;
  "bench")
    benchmark
    ;;
  *)
    echo "invalid argument"
    ;;
esac
}

function clean() {
  [ -d "default.etcd" ] && echo "removing default.etcd" && rm -rf default.etcd/
}

function run_etcd_server() {
  echo "starting etcd server"
  ${ETCD_BIN} --quota-backend-bytes=${BACKEND_SIZE} \
    --log-level 'error' \
    --enable-pprof
}

function init_etcd_db() {
  echo "initialize etcd database..."
  ${ETCD_BM_BIN} put --sequential-keys \
    --key-space-size=${KEY_SPACE_SIZE} \
    --val-size=${VALUE_SIZE} --key-size=${KEY_SIZE} \
    --total=${KEY_SPACE_SIZE} \
    &>/dev/null
}

function benchmark() {
  ${ETCD_BM_BIN} txn-mixed "" \
    --conns=${CONN_CLI_COUNT} --clients=${CONN_CLI_COUNT} \
    --total=${RUN_COUNT} \
    --rw-ratio ${RATIO} --limit ${RANGE_RESULT_LIMIT} \
    --val-size ${VALUE_SIZE}
}

#	putCmd.Flags().IntVar(&keySize, "key-size", 8, "Key size of put request")
#	putCmd.Flags().IntVar(&valSize, "val-size", 8, "Value size of put request")
#	putCmd.Flags().IntVar(&putRate, "rate", 0, "Maximum puts per second (0 is no limit)")
#
#	putCmd.Flags().IntVar(&putTotal, "total", 10000, "Total number of put requests")
#	putCmd.Flags().IntVar(&keySpaceSize, "key-space-size", 1, "Maximum possible keys")
#	putCmd.Flags().BoolVar(&seqKeys, "sequential-keys", false, "Use sequential keys")
#	putCmd.Flags().DurationVar(&compactInterval, "compact-interval", 0, `Interval to compact database (do not duplicate this with etcd's 'auto-compaction-retention' flag) (e.g. --compact-interval=5m compacts every 5-minute)`)
#	putCmd.Flags().Int64Var(&compactIndexDelta, "compact-index-delta", 1000, "Delta between current revision and compact revision (e.g. current revision 10000, compact at 9000)")
#	putCmd.Flags().BoolVar(&checkHashkv, "check-hashkv", false, "'true' to check hashkv")

function write() {
  VALUE_SIZE="$((2 ** 20))" # 1MB
  KEY_SPACE_SIZE="$((1024 * 18))" # VALUE_SIZE * KEY_SPACE_SIZE = 18GB
  echo "VALUE_SIZE=${VALUE_SIZE}"
  echo "KEY_SPACE_SIZE=${KEY_SPACE_SIZE}"
  echo "RUN_COUNT=${RUN_COUNT}"

  ${ETCD_BM_BIN} put "" \
    --key-space-size=${KEY_SPACE_SIZE} \
    --total=${RUN_COUNT} \
    --val-size ${VALUE_SIZE}
}

main $1