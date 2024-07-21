
sudo add-apt-repository ppa:longsleep/golang-backports
apt install golang-go bc htop -y
git clone --depth=1 https://github.com/etcd-io/etcd.git
cd etcd
make build tools
cd /root/etcd/tools/rw-heatmaps



export RATIO_LIST="4/1"
export REPEAT_COUNT=3
export RUN_COUNT=50000
echo RATIO_LIST=$RATIO_LIST
echo REPEAT_COUNT=$REPEAT_COUNT
echo RUN_COUNT=$RUN_COUNT
./rw-benchmark.sh && cd /root/etcd/tools/rw-heatmaps &&  sleep 10 &&./rw-benchmark.sh

git clone  https://github.com/clement2026/etcd.git etcd-17098
git checkout issues-17098