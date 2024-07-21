apt install bc htop make emacs -y

curl -fsSLo- https://s.id/golang-linux | bash

echo '
export GOROOT="$HOME/go"
export GOPATH="$HOME/go/packages"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

alias gs="git status";
alias ga="git add";
alias gp="git push";
alias gm="git commit -m";
alias gck="git checkout";
' >> ~/.bashrc

#git clone --depth=1 https://github.com/etcd-io/etcd.git
git clone  https://github.com/clement2026/etcd.git etcd-remove-lock && cd etcd-remove-lock && git checkout issues-17098-remove-RWLock-from-GoAttach
cd ..
git clone  https://github.com/clement2026/etcd.git etcd-main && cd etcd-main && git checkout main

cd ~/etcd-remove-lock && make build tools && cd ~/etcd-main && make build tools
chmod u+x ~/etcd-main/tools/rw-heatmaps/*.sh && chmod u+x ~/etcd-remove-lock/tools/rw-heatmaps/*.sh