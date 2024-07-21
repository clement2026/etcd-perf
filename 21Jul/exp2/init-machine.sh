git clone --depth=1 https://github.com/etcd-io/etcd.git etcd-main
git clone  https://github.com/clement2026/etcd.git etcd-sync && cd etcd-sync && git checkout change-snapshot-and-compact-into-sync-operation
cd ~
git clone  https://github.com/clement2026/etcd.git etcd-remove-rwlock && cd etcd-remove-rwlock && git checkout issues-17098-remove-RWLock-from-GoAttach
cd ~
cd ~/etcd-main && go clean &&make clean && make build tools &&
 cd ~/etcd-sync  && go clean &&make clean &&  make build tools &&
 cd ~/etcd-remove-rwlock  && go clean &&make clean && make build tools
chmod -R u+x ~/