rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000