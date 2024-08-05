# Summary

Please disregard the earlier benchmark results. They were incorrect. Here are the reliable ones. Each branch was tested multiple times, with `main 01` as the baseline.

| Branch                                                                                        |       | Performance Change |
|-----------------------------------------------------------------------------------------------|-------|--------------------|
| main 01                                                                                       | read  | -                  |
|                                                                                               | write | -                  |
| main 02                                                                                       | read  | [-5.38%, 6.66%]    | 
|                                                                                               | write | [-5.09%, 6.52%]    |
| main 03                                                                                       | read  | [-4.45%, 7.12%]    | 
|                                                                                               | write | [-3.82%, 7.20%]    |
| patch 01                                                                                      | read  | [-3.49%, 5.95%]    |
|                                                                                               | write | [-4.78%, 6.40%]    |
| patch 02                                                                                      | read  | [-4.68%, 4.62%]    |
|                                                                                               | write | [-5.07%, 6.42%]    |
| remove-rwlock 01(based on https://github.com/etcd-io/etcd/pull/18283#issuecomment-2228070484) | read  | [-3.41%, 4.79%]    |
|                                                                                               | write | [-3.87%, 5.34%]    |
| remove-rwlock 02                                                                              | read  | [-5.34%, 4.81%]    |
|                                                                                               | write | [-5.74%, 6.65%]    |

It seems this PR/patch doesn't show significant performance changes.

The benchmarks were conducted using the following script on a cloud VM with 8 vCPUs and 16 GB RAM.

```bash
export RATIO_LIST="4/1"
export REPEAT_COUNT=3
export RUN_COUNT=50000
date; cd ~/etcd/tools/rw-heatmaps && ./rw-benchmark.sh; date;
```

# Details

@ahrtr You were right about the strange 30% increase. The 30% turns out to be wrong data from my faulty script:

```
date; cd ~/etcd-sync/tools/rw-heatmaps && ./rw-benchmark.sh && cd ~/etcd/tools/rw-heatmaps &&  sleep 30 &&./rw-benchmark.sh; date
```

When running this script to benchmark 2 branches, the second one always shows the 30% drop in performance. I’m not sure if it’s a machine issue, as I didn't see unusual I/O, swap, or CPU activity after each benchmark.

Anyway, I managed to get solid benchmark results by rebooting the machine after each run. Below are benchmark details. Machine was rebooted after each benchmark.

### Test 1

Benchmark main branch for 3 times to ensure the results is reliable.

![main-01-vs-main-02](https://github.com/user-attachments/assets/0a9f5360-f6be-450a-9e74-272eaed2fc62)
![main-01-vs-main-03](https://github.com/user-attachments/assets/5a63123f-e247-4e3b-9eb4-6444663d6e6b)
[main-01.csv](https://github.com/user-attachments/files/16352858/main-01.csv) [main-02.csv](https://github.com/user-attachments/files/16352860/main-02.csv) [main-03.csv](https://github.com/user-attachments/files/16352861/main-03.csv)

### Test 2

Benchmark this PR/patch twice

![main-01-vs-patch](https://github.com/user-attachments/assets/3b591ab4-f818-441f-908c-d10b94d4398d)
![main-01-vs-patch-02](https://github.com/user-attachments/assets/44725f6f-4c95-4b6c-ab16-950d4d3ce966)
[patch.csv](https://github.com/user-attachments/files/16352873/patch.csv) [patch-02.csv](https://github.com/user-attachments/files/16352874/patch-02.csv)

### Test 3

Benchmark https://github.com/etcd-io/etcd/pull/18283#issuecomment-2228070484 twice. [Code is here](https://github.com/clement2026/etcd/tree/issues-17098-remove-RWLock-from-GoAttach)

![main-01-vs-remove-rwlock](https://github.com/user-attachments/assets/bd58ea0f-6a67-41eb-b296-cffdf24212ef)
![main-01-vs-remove-rwlock-02](https://github.com/user-attachments/assets/4e5d767d-d301-4d19-bab9-a033119c75f4)
[remove-rwlock.csv](https://github.com/user-attachments/files/16352889/remove-rwlock.csv) [remove-rwlock-02.csv](https://github.com/user-attachments/files/16352888/remove-rwlock-02.csv)

