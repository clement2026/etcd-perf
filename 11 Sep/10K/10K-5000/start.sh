rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries 5000

./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=10000