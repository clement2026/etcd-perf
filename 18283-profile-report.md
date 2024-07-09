I ran multiple CPU profiles with different `value size` and `connection count`. The results show that MVCC operations
like `mvcc.(*keyIndex).get`, `mvcc.(*keyIndex).isEmpty`, and `mvcc.(*keyIndex).findGeneration` significantly impact
total CPU time. Other functions worth noting are `runtime.memmove`, `syscall.Syscall6`, and `cmpbody`.

Since this patch tends to increase throughput, so higher CPU usage wasn’t surprising. These results didn't give me a
clear conclusion. To better understand the issue, I should have collected and compared CPU profile data when the patch
showed lower throughput. Unfortunately, I didn't record the throughput during the CPU profiles.

Anyway, I’m sharing these results here and would love to know what you think before I dig deeper.

**CPU Time Usage**

| Connection Count | Value Size Range | Main    | Patch   | Change in CPU Time Usage | Files                                                                                                                                                                     |
|------------------|------------------|---------|---------|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 32               | 16 KB            | 322.51s | 331.32s | 2.73%                    | [main.pb.gz](https://github.com/user-attachments/files/16144448/main.pb.gz) [patch.pb.gz](https://github.com/user-attachments/files/16144452/patch.pb.gz)                 |
| 32               | 32 KB            | 467.14s | 460.28s | -1.47%                   | [main.pb.gz](https://github.com/user-attachments/files/16144290/main.pb.gz) [patch.pb.gz](https://github.com/user-attachments/files/16144291/patch.pb.gz)                 |
| 32               | 64 KB            | 596.94s | 588.16s | -1.47%                   | [main.pb.gz](https://github.com/user-attachments/files/16144299/main.pb.gz) [patch.pb.gz](https://github.com/user-attachments/files/16144300/patch.pb.gz)                 |
| 1024             | 16 KB            | 319.78s | 332.02s | 3.83%                    | [main.pb.gz](https://github.com/user-attachments/files/16144311/main-1024-14.pb.gz) [patch.pb.gz](https://github.com/user-attachments/files/16144313/patch-1024-14.pb.gz) |
| 1024             | 32 KB            | 424.93s | 435.31s | 2.44%                    | [main.pb.gz](https://github.com/user-attachments/files/16144316/main-1024-15.pb.gz) [patch.pb.gz](https://github.com/user-attachments/files/16144317/patch-1024-15.pb.gz) |
| 1024             | 64 KB            | 544.16s | 547.28s | 0.57%                    | [main.pb.gz](https://github.com/user-attachments/files/16144330/main-1024-16.pb.gz) [patch.pb.gz](https://github.com/user-attachments/files/16144333/patch-1024-16.pb.gz) |

**Script**
[run.sh.zip](https://github.com/user-attachments/files/16144338/run.sh.zip)
All these tests use this script but with different `VALUE_SIZE` and `CONN_CLI_COUNT`

