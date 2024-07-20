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


declare -A repos=(
    ["etcd-main"]="main"
    ["etcd-sync"]="change-snapshot-and-compact-into-sync-operation"
    ["etcd-remove-lock"]="issues-17098-remove-RWLock-from-GoAttach"
)

# 定义一个函数来处理克隆和构建
clone_and_build() {
    local repo_url="https://github.com/clement2026/etcd.git"

    for dir in "${!repos[@]}"; do
        git clone "$repo_url" "$dir" && cd "$dir" || exit
        git checkout "${repos[$dir]}"
        make build tools
        cd - || exit
    done
}

# 定义一个函数来修改权限
change_permissions() {
    for key in "${!repos[@]}"; do
        chmod u+x ~/"$key/tools/rw-heatmaps/"*.sh
    done

}

# 执行函数
clone_and_build
change_permissions
