# Summary
Here are the results of the four benchmarks performed using the `rw-benchmark.sh` script.

| Value Size Range |       | Performance Change |
|------------------|-------|--------------------|
| 256 B ~  16 KB   | read  | -1.67% ~ 27.31%    |
|                  | write | -1.12% ~ 28.64%    |
| 256 B ~  16 KB   | read  | -0.67% ~ 30.40%    |
|                  | write | -1.32% ~ 30.71%    |
| 256 B ~ 32 KB    | read  | 3.68%  ~ 33.13%    |
|                  | write | 3.00%  ~ 34.37%    |
| 8 KB ~  32 KB    | read  | 0.11%  ~ 20.38%    |
|                  | write | 0.97%  ~ 21.13%    |

# Details

**Hardware**
* Test 1 was conducted on a cloud VM with 8 vCPUs and 16 GB RAM. 
* The remaining 3 tests were conducted on cloud VMs with 8 vCPUs and 32 GB RAM.

**Script**
All 4 tests use this script but differ in their `VALUE_SIZE_POWER_RANGE` variable.
```bash
export RATIO_LIST="4/1"
export REPEAT_COUNT=3
export RUN_COUNT=50000
./rw-benchmark.sh
```

## Test 1
`export VALUE_SIZE_POWER_RANGE="8 14"` 

![compare_read](https://github.com/etcd-io/etcd/assets/27894831/e746825c-10b8-44b8-bd44-49879b98ab03)

[main.csv](https://github.com/user-attachments/files/16143207/main.csv)  [patch.csv](https://github.com/user-attachments/files/16143209/patch.csv)

## Test 2
`export VALUE_SIZE_POWER_RANGE="8 14"`

![compare_read](https://github.com/etcd-io/etcd/assets/27894831/ec783f37-2883-4e5e-b7c3-aeae73c7ae42)

[main.csv](https://github.com/user-attachments/files/16143236/main.csv)  [patch.csv](https://github.com/user-attachments/files/16143237/patch.csv)

## Test 3
`export VALUE_SIZE_POWER_RANGE="8 15"`

![compare_read](https://github.com/etcd-io/etcd/assets/27894831/ec2c35b5-d07c-4edb-ba95-e0f6dd262791)

[main.csv](https://github.com/user-attachments/files/16143240/main.csv)  [patch.csv](https://github.com/user-attachments/files/16143241/patch.csv)


## Test 4
`export VALUE_SIZE_POWER_RANGE="13 15"`

![compare_read](https://github.com/etcd-io/etcd/assets/27894831/9214ac6c-060f-4756-af37-bd7484599cca)

[main.csv](https://github.com/user-attachments/files/16143247/main.csv)  [patch.csv](https://github.com/user-attachments/files/16143248/patch.csv)
