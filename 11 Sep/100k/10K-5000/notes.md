<details>
<summary><kbd>putSize 100 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries 5000

# benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=100000

# monitor heap size using live-pprof(https://github.com/moderato-app/live-pprof)
live-pprof 2379 
```

<img width="1280" alt="100K-10K-5000" src="https://github.com/user-attachments/assets/4399be87-d611-4257-8ff4-ff59506ba4cd">


</details>