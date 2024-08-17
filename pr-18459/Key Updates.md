# Key Updates

* Added a new function `compactRaftLog` for raft log compaction.
* Introduce 2 variables: `RaftLogCompactionStep` and `DefaultRaftLogCompactionStep` to manage how often the raft log is compacted.
* Refactor some existing tests. These tests previously expected a compaction immediately after a snapshot to ensure a snapshot was sent to followers. This PR broke those tests, so I modified them to ensure they still work.
* Add unit and integration tests for this PR.