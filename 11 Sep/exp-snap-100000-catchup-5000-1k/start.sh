rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries 5000

./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000