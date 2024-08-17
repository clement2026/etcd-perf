# Benchmark Summary

Here are the benchmark results for compacting the raft log every time `applied index` increases by 1, 10, 100, and 1000 (let's call this "step").

| Branch            |       | Throughput       |
|-------------------|-------|------------------|
| main(as the base) | read  | -                |
|                   | write | -                |
| step_1            | read  | [2.86%, 17.00%]  |
|                   | write | [3.02%, 16.75%]  |
| step_10           | read  | [2.82%, 16.53%]  |
|                   | write | [2.98%, 16.95%]  |
| step_100          | read  | [-2.09%, 9.77%]  |
|                   | write | [-1.00%, 10.93%] |
| step_1000         | read  | [-4.13%, 7.27%]  |
|                   | write | [-4.91%, 7.65%]  |
| main again        | read  | [-4.19%, 7.39%]  |
|                   | write | [-4.41%, 9.03%]  |

Throughput performs best when the step is 1 or 10. There isn’t much difference between the two. I've set the default step value to 10 in the code.
