<details>
<summary><kbd>putSize 1 MB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

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
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000000

# monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="1000K-10K-5000" src="https://github.com/user-attachments/assets/e1f121ed-5a2e-4317-b615-867756cfe27c">


</details>