<details>
<summary><kbd>putSize 1 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000

# monitor heap size using live-pprof
live-pprof 2379 
```
<img width="1915" alt="1K-10K-5000" src="https://github.com/user-attachments/assets/fdbd286c-20e4-4b77-a904-5d62f34385cd">
</details>