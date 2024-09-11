rm -rf etcd0.etcd; etcd -name etcd0 \
--data-dir etcd0.etcd \
--enable-pprof=true \
--snapshot-count=1000 \
--advertise-client-urls http://localhost:2379 \
--listen-client-urls http://localhost:2379 \
--initial-advertise-peer-urls http://localhost:2380 \
--listen-peer-urls http://localhost:2380 \
--initial-cluster-token vitastor-etcd-1 \
--initial-cluster etcd0=http://localhost:2380 \
--initial-cluster-state new \
--max-txn-ops=100000 \
--max-request-bytes=104857600 \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--experimental-snapshot-catchup-entries 5000



rm -rf etcd0.etcd; ./3.6/bin/etcd -name etcd0 \
--data-dir etcd0.etcd \
--enable-pprof=true \
--snapshot-count=500 \
--advertise-client-urls http://localhost:2379 \
--listen-client-urls http://localhost:2379 \
--initial-advertise-peer-urls http://localhost:2380 \
--listen-peer-urls http://localhost:2380 \
--initial-cluster-token vitastor-etcd-1 \
--initial-cluster etcd0=http://localhost:2380 \
--initial-cluster-state new \
--max-txn-ops=100000 \
--max-request-bytes=104857600 \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--experimental-snapshot-catchup-entries 500


./bin/tools/benchmark put --total=5000 --val-size=2000000 --key-space-size=1 --sequential-keys

./bin/tools/benchmark txn-mixed --total=500000 --val-size=2000000 --key-space-size=1 --rw-ratio=1