#!/bin/bash
BASE_DIR=$1
ETCD_BIN="$BASE_DIR/bin/etcd"
ETCD_BM_BIN="$BASE_DIR/bin/tools/benchmark"

# fixed
KEY_SPACE_SIZE="${KEY_SPACE_SIZE:-$((1024 * 64))}"
BACKEND_SIZE="${BACKEND_SIZE:-$((20 * 1024 * 1024 * 1024))}" # 20GB
RANGE_RESULT_LIMIT="${RANGE_RESULT_LIMIT:-100}"
KEY_SIZE="256"

# variable
RATIO="4.0"
VALUE_SIZE="$((2 ** 14))"
CONN_CLI_COUNT="$((2**10))"
RUN_COUNT=50000

echo "RATIO=$RATIO"
echo "VALUE_SIZE=$VALUE_SIZE"
echo "CONN_CLI_COUNT=$CONN_CLI_COUNT"
echo "RUN_COUNT=$RUN_COUNT"

function main() {
startedAt=$(date)
echo "started at $startedAt"
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
  "bench")
    benchmark
    ;;
  *)
    echo "invalid argument"
    ;;
esac
echo "started at $startedAt"
echo "finished at $(date)"
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

main $2
