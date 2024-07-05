#!/bin/bash
ETCD_BIN="/Users/clement/projects/clement/etcd/bin/etcd"
ETCD_BM_BIN="/Users/clement/projects/clement/etcd/bin/tools/benchmark"
BACKEND_SIZE="$((20 * 1024 * 1024 * 1024))" # 20GB
KEY_SPACE_SIZE="$((1024 * 64))"
RATIO="4.0"
KEY_SIZE="256"
RUN_COUNT="1000000"
RANGE_RESULT_LIMIT="100"
VALUE_SIZE="$((2 ** 8))" # VALUE_SIZE="$((2 ** 14))" # from 256 to 16384
CONN_CLI_COUNT="$((2**5))" # CONN_CLI_COUNT="$((2**11))" # from 32 to 2048

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
  "write-small")
    write_small
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
  BACKEND_SIZE="$((20 * 1024 * 1024 * 1024))" # 20GB
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

function write() {
  VALUE_SIZE="$((2 ** 20))" # 1MB
#  KEY_SPACE_SIZE="$((1024 * 18))" # VALUE_SIZE * KEY_SPACE_SIZE = 18GB
  echo "VALUE_SIZE=${VALUE_SIZE}"
  echo "KEY_SPACE_SIZE=${KEY_SPACE_SIZE}"
  echo "RUN_COUNT=${RUN_COUNT}"

  ${ETCD_BM_BIN} put "" \
    --key-space-size=${KEY_SPACE_SIZE} \
    --total=${RUN_COUNT} \
    --val-size ${VALUE_SIZE}
}

function write_small() {
  VALUE_SIZE="$((2 ** 10))" # 1MB
  RUN_COUNT="1000000"
  #  KEY_SPACE_SIZE="$((1024 * 18))" # VALUE_SIZE * KEY_SPACE_SIZE = 18GB
  echo "VALUE_SIZE=${VALUE_SIZE}"
  echo "KEY_SPACE_SIZE=${KEY_SPACE_SIZE}"
  echo "RUN_COUNT=${RUN_COUNT}"

  ${ETCD_BM_BIN} put "" \
    --key-space-size=${KEY_SPACE_SIZE} \
    --total=${RUN_COUNT} \
    --val-size ${VALUE_SIZE}
}

main $1