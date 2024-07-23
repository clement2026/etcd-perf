curl -fsSLo- https://s.id/golang-linux | bash

git clone https://github.com/clement2026/etcd.git main

cd ~/main && go clean && make clean && make build tools
chmod -R u+x ~/