## Benchmark details

Here's how I did the benchmark:
1. Run benchmark on `main`, `step_1`, `step_10`, `step_100`, `step_1000` and `main` branch in sequence. 
2. Reboot the system between each run.
3. Collect .csv files and generate heatmaps.

### step_1 vs main
Compact raft log every time `applied index` increases 1.

![step_1_read](https://github.com/user-attachments/assets/f2b1d897-3e31-4e39-be31-596c671ede29)

### step_10  vs main
Compact raft log every time `applied index` increases by 10.

![step_10_read](https://github.com/user-attachments/assets/16d519a9-4118-422e-9cfd-6d3f08822c4c)

### step_100  vs main
Compact raft log every time `applied index` increases by 100.

![step_100_read](https://github.com/user-attachments/assets/8c491024-f35a-45c5-95b4-8f0dab9884fa)

### step_1000  vs main
Compact raft log every time `applied index` increases by 1000.

![step_1000_read](https://github.com/user-attachments/assets/2dc69985-41e1-4611-b19c-4d87b0749a81)

### main vs main
Re-run benchmarks on the main branch to ensure results are consistent

![main_2_read](https://github.com/user-attachments/assets/faf1d3fb-b340-41ff-85d8-50cd4818d7bf)

### step_1 vs step_10
Since the benchmark results for step_1 and step_10 are pretty close, here we compare them to see the difference:

![step_1-vs-step_10_read](https://github.com/user-attachments/assets/afe3fefe-e4b2-4514-b3d3-63bf14e33ea5)


---

GitHub workflow: https://github.com/clement2026/etcd-benchmark-action/actions/runs/10424407957

The archive containing .csv files and the script: [etcd-benchmark-20240817-06-00-29.zip](https://github.com/user-attachments/files/16644019/etcd-benchmark-20240817-06-00-29.zip)

The benchmark was run on a self-hosted cloud VM with:
* 16GB RAM
* 8 vCPUs
* 150GB NVMe SSD
* Ubuntu 24.04 LTS x64