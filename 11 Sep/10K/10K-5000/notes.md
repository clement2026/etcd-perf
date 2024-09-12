<details>
<summary><kbd>putSize 10 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=10000

# monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1280" alt="10K-10K-5000" src="https://github.com/user-attachments/assets/6817dbfe-7fb8-4b00-97b9-4fb97589d34e">

</details>