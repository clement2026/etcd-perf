curl -fsSLo- https://s.id/golang-linux | bash

git clone https://github.com/clement2026/etcd.git sync --single-branch --branch change-snapshot-and-compact-into-sync-operation

cd ~/sync && go clean && make clean && make build tools
chmod -R u+x ~/