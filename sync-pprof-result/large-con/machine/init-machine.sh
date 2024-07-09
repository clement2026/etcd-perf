apt install bc htop make emacs -y

curl -fsSLo- https://s.id/golang-linux | bash

echo '
export GOROOT="$HOME/go"
export GOPATH="$HOME/go/packages"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
' >> ~/.bashrc

git clone --depth=1 https://github.com/etcd-io/etcd.git
git clone  https://github.com/clement2026/etcd.git etcd-sync && cd etcd-sync && git checkout change-snapshot-and-compact-into-sync-operation
cd ~/etcd && make build tools && cd ~/etcd-sync && make build tools
chmod u+x ~/etcd/tools/rw-heatmaps/*.sh && chmod u+x ~/etcd-sync/tools/rw-heatmaps/*.sh