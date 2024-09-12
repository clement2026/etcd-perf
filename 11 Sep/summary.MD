#18382 raises the issue of high memory usage related to the etcd member catch-up mechanism. I’ve been working on it for a while and have some findings to share.

## Experiments
I’ve run a few experiments to observe the heap size of an etcd instance. Below is a table I put together from my observations, showing how the heap size changes when benchmarking etcd.

* `putSize`: average size of `put` requests

| putSize | --snapshot-count | --experimental-snapshot<br/>-catchup-entries | heap size<br/>v3.5.16 | heap size<br/>v3.6.0-alpha.0 |
|---------|------------------|----------------------------------------------|-----------------------|------------------------------|
| 1 KB    | 10000            | 5000                                         | 6 MB ~ 28 MB          | 13 MB ~ 31.7 MB              |
| 10 KB   | 10000            | 5000                                         | 64 MB ~ 180 MB        |                              |
| 100 KB  | 10000            | 5000                                         | 569 MB ~ 1.5 GB       | 536 MB ~ 1.62 GB             |
| 1 MB    | 10000            | 5000                                         | 5 GB ~ 14.2 GB        |                              |
| ---     | ---              | ---                                          | ---                   | ---                          |
| 1 KB    | 100000           | 5000                                         | 15 MB ~ 143 MB        | 15 MB ~ 152 MB               |
| 10 KB   | 100000           | 5000                                         | 67 MB ~ 1.1GB         |                              |
| 100 KB  | 100000           | 5000                                         | 900 MB ~ 10.6 GB      | 690 MB ~ 10.4 GB             |
| ---     | ---              | ---                                          | ---                   | ---                          |
| 1 MB    | 500              | 500                                          | 550 MB ~ 1 GB         |                              |

> Both v3.5 and v3.6 use 5000 as the default value for `--experimental-snapshot-catchup-entries`; however, the default value for `--snapshot-count` is set much lower in v3.6 at 10,000, compared to 100,000 in v3.5.

#### v3.5.16 f20bbadd4

<details>
<summary><kbd>putSize 1 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000

# Monitor heap size using live-pprof (https://github.com/moderato-app/live-pprof)
live-pprof 2379 
```

<img width="1915" alt="1K-10K-5000" src="https://github.com/user-attachments/assets/fdbd286c-20e4-4b77-a904-5d62f34385cd">
</details>

<details>
<summary><kbd>putSize 10 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=10000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1280" alt="10K-10K-5000" src="https://github.com/user-attachments/assets/6817dbfe-7fb8-4b00-97b9-4fb97589d34e">
</details>

<details>
<summary><kbd>putSize 100 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=100000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1280" alt="100K-10K-5000" src="https://github.com/user-attachments/assets/4399be87-d611-4257-8ff4-ff59506ba4cd">
</details>

<details>
<summary><kbd>putSize 1 MB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="1000K-10K-5000" src="https://github.com/user-attachments/assets/e1f121ed-5a2e-4317-b615-867756cfe27c">
</details>

<details>
<summary><kbd>putSize 1 KB</kbd> <kbd>snapshot-count 100,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="1K-100K-5000" src="https://github.com/user-attachments/assets/021d878f-cb0c-47d4-8614-265a55384b43">
</details>

<details>
<summary><kbd>putSize 10 KB</kbd> <kbd>snapshot-count 100,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=10000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1280" alt="10K-100K-5000" src="https://github.com/user-attachments/assets/f4c792e6-94d7-4b7f-a90e-14c7eb2419f7">
</details>

<details>
<summary><kbd>putSize 100 KB</kbd> <kbd>snapshot-count 100,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=100000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="100K-100K-5000" src="https://github.com/user-attachments/assets/e389401c-160d-4db2-875f-daecccf64498">
</details>

<details>
<summary><kbd>putSize 1 MB</kbd> <kbd>snapshot-count 500</kbd> <kbd>experimental-snapshot-catchup-entries 500</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=500 \
--experimental-snapshot-catchup-entries=500

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="1000K-500-500" src="https://github.com/user-attachments/assets/922d6e25-105d-42f3-b2c7-e755fb297f45">
</details>

#### v3.6.0-alpha.0 981061a49

<details>
<summary><kbd>putSize 1 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="1K-10K-5000" src="https://github.com/user-attachments/assets/ecab09bd-f09b-463b-9cbd-84b6af936ffa">
</details>

<details>
<summary><kbd>putSize 100 KB</kbd> <kbd>snapshot-count 10,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=10000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=100000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1280" alt="100K-10K-5000" src="https://github.com/user-attachments/assets/eeffa762-f655-4f54-9deb-7144468e7912">
</details>

<details>
<summary><kbd>putSize 1 KB</kbd> <kbd>snapshot-count 100,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=1000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1915" alt="1K-100K-5000" src="https://github.com/user-attachments/assets/b8c93753-785c-4864-ac39-67a7ab63d32f">
</details>

<details>
<summary><kbd>putSize 100 KB</kbd> <kbd>snapshot-count 100,000</kbd> <kbd>experimental-snapshot-catchup-entries 5000</kbd></summary>

```bash
# Run etcd
rm -rf tmp.etcd;
etcd --data-dir tmp.etcd \
--enable-pprof=true \
--auto-compaction-mode=periodic \
--auto-compaction-retention=5s \
--snapshot-count=100000 \
--experimental-snapshot-catchup-entries=5000

# Benchmark
./bin/tools/benchmark txn-mixed --total=99999999999 --val-size=100000

# Monitor heap size using live-pprof
live-pprof 2379 
```

<img width="1280" alt="100K-100K-5000" src="https://github.com/user-attachments/assets/9be815b8-c533-4fc2-a75f-a3a0d67ef10e">
</details>

---

## How to estimate the heap size of etcd

The etcd member catch-up mechanism maintains a list of entries to keep the leader and followers in sync.
When etcd receives a put request, it appends the request data to the entries. These entries significantly impact etcd’s heap size.

As `put` requests keep appending to the entries, `--snapshot-count` and `--experimental-snapshot-catchup-entries` control when and how to shrink/compact the entries.

Once we know the average size of `put` requests (let’s call it `putSize`), we can estimate the heap size of these entries. It ranges from:

```bash
experimental-snapshot-catchup-entries * putSize
```

to:

```bash
(experimental-snapshot-catchup-entries + snapshot-count) * putSize
```

The heap size of these entries, plus some overhead, is roughly the heap size and RSS of etcd.

With this in mind, we can try to answer some questions.

### Q1: Do I need to worry about the heap size of etcd?

If `putSize` is small, like 1KB, the heap size should be under 200 MB for v3.5 and under 50 MB for v3.6. With such low memory usage, there is no need to manually set `--snapshot-count` and `--experimental-snapshot-catchup-entries`. The default settings work fine.

If `putSize` is big, you can estimate the heap size of etcd according to the table and calculations we discussed earlier. You can also set custom values for `--snapshot-count` and `--experimental-snapshot-catchup-entries` to control the heap size.

### Q2: Is it okay to set a really low value for `--snapshot-count`?

Setting a low value for `--snapshot-count` makes etcd create snapshots more often. This can cause CPU spikes and isn't ideal for latency-sensitive situations.
Here’s an example of the spikes:

<img width="600" alt="1000K-10K-5000" src="https://github.com/user-attachments/assets/e1f121ed-5a2e-4317-b615-867756cfe27c">

### Q3: Is it okay to set a really low value for `--experimental-snapshot-catchup-entries`?

If `--experimental-snapshot-catchup-entries` is set too low, slow followers might need to use snapshots to catch up with the leader. This is less efficient and puts more pressure on the leader compared to just using the entries. This often occurs when the network connection between the leader and followers is bad.

However, it’s fine to set `--experimental-snapshot-catchup-entries` to as low as `1` if you only have a single instance of etcd.

---

The analysis above focuses solely on the heap size of etcd. It doesn’t include memory allocated through `mmap` (used by bbolt) and `cgo`. To determine the total
physical memory requirements for etcd, memory allocated through `mmap` must also be taken into account.