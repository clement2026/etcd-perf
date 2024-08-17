# Summary

After separating raft log compact from snapshot, the throughout sees an increase when compacting raft log every time `applied index` increases by 1, 10, 100(let’s refer to this as “step” going forward). 

Throughput performs best when step is 1 or 10. There isn’t much difference between the two. I've set the default step value to 10 in the code.

