#18382 brings up the high memory usage issue, which is related to the etcd member catchup mechanism.
I’ve tried out a few flags to manage the memory usage of an etcd instance and have some insights to share.

This comment focuses solely on the Go heap size (inuse_space). It doesn’t account for memory allocated through `mmap`(used by bbolt) and `cgo`.

#### Do I need to worry about Go heap size when running etcd?

If the `put` requests are small, it’s fine. For example, if the average size of `put` requests(let’s call it putSize) is 1KB, the heap size should be under
200MB for v3.5 and under 50MB for
v3.6.

The heap size increases as putSize gets bigger. Here’s a table I put together from my observations, showing how the heap size changes after benchmarking
etcd for a while.

| putSize | snapshot-count | experimental-snapshot-catchup-entries | max heap size(v3.5) | max heap size(v3.6) |
|---------|----------------|---------------------------------------|---------------------|---------------------|
| 1 KB    | 10000          | 5000                                  | 6 MB ~ 28 MB        | 13 MB ~ 33 MB       |
| 1 KB    | 100000         | 5000                                  | 15 MB ~ 150 MB      |                     |
| 100 KB  | 100000         | 5000                                  | 0.9 GB ~ 11 GB      |                     |
| 1 MB    | 10000          | 5000                                  | 5 GB ~ 14.2 GB      |                     |
| 1 MB    | 500            | 500                                   | 0.5 GB ~ 1 GB       |                     |

As `putSize` increases, we see that the heap size ranges from
```bash
experimental-snapshot-catchup-entries * putSize
to
(experimental-snapshot-catchup-entries + snapshot-count) * putSize
```

####                      

<details>
<summary><kbd>Screenshots</kbd></summary>
<br/>	
<img width="1920" alt="Heap" src="https://github.com/user-attachments/assets/0bc04e0d-45ed-4b8a-8abf-b550fde31d60">
<img width="1920" alt="CPU" src="https://github.com/user-attachments/assets/67d6852e-26c6-44ca-a23f-a99e71b6e482">
<img width="1920" alt="Allocs" src="https://github.com/user-attachments/assets/22e90362-4c0b-4db5-bb43-bf6234b8bf07">
<img width="1920" alt="Goroutine" src="https://github.com/user-attachments/assets/eb79a142-f0d1-4993-95e7-ce4571ecde19">
<img width="1920" alt="Detect Endpoints" src="https://github.com/user-attachments/assets/837215f1-e7f9-424e-94b2-4f67ba5af697">
<img width="1920" alt="Options" src="https://github.com/user-attachments/assets/7d0b33b9-b5cd-48bf-9ccc-0651ae54685f">
</details>