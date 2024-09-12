<details>
<summary><kbd>putSize 1 KB</kbd> <kbd>snapshot-count 100,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries 5000

# benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000

# monitor heap size using live-pprof(https://github.com/moderato-app/live-pprof)
live-pprof 2379 
```

<img width="1915" alt="1K-100K-5000" src="https://github.com/user-attachments/assets/b8c93753-785c-4864-ac39-67a7ab63d32f">

</details>