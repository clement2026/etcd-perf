<details>
<summary><kbd>putSize 1 MB</kbd> <kbd>snapshot-count 500</kbd> <kbd>experimental-snapshot-catchup-entries 500</kbd></summary>

```bash
# run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=500 \
--experimental-snapshot-catchup-entries 500

# benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000000

# monitor heap size using live-pprof(https://github.com/moderato-app/live-pprof)
live-pprof 2379 
```

<img width="1915" alt="1000K-500-500" src="https://github.com/user-attachments/assets/922d6e25-105d-42f3-b2c7-e755fb297f45">

</details>