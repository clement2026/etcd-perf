### Test 2

`rw-heatmap`

Summary of Improvements

* 2% ~ 12% improvement to read performance
* 1% ~ 13% improvement to write performance

### Test 2

`benchmark put` 50000 values of 1 MB each, within 6 minutes

| Branch | Max Memory |
|--------|------------|
| main   | 31 GB      |
| patch  | 12 GB      |

Summary of Improvements

* 59% reduction in maximum memory usage

### Test 2

`benchmark txn-mixed` 1,000,000 transactions, within 20 minutes

| Value Size | Branch | Initial Memory | Final Memory | CPU Usage |
|------------|--------|----------------|--------------|-----------|
| 1 KB       | main   | 35.5 MB        | 45.83 MB     | 4050.75s  |
|            | patch  | 39.4 MB        | 52.01 MB     | 3584.51s  |
| 16 MB      | main   | 188.97 MB      | 884.82 MB    | 6552.40s  |
|            | patch  | 119.57 MB      | 753.51 MB    | 5954.52s  |

Summary of Improvements

* 12% improvement in CPU usage for 1KB transactions
* 9% improvement in CPU usage for 16MB transactions
* 15% reduction in memory usage for 16MB transactions

Degradations

* 13% increase in memory usage for 1KB transactions
