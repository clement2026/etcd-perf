curl -fsSLo- https://s.id/golang-linux | bash

git clone https://github.com/clement2026/etcd.git main          --single-branch --branch main
git clone https://github.com/clement2026/etcd.git remove-rwlock --single-branch --branch issues-17098-remove-RWLock-from-GoAttach

cd ~/main && go clean && make clean && make build tools &&
 cd ~/remove-rwlock  && go clean && make clean && make build tools
chmod -R u+x ~/