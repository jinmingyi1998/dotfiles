#!/bin/bash

# 默认代理设置
export JIMMY_SHELL_PROXY="${JIMMY_SHELL_PROXY:-http://192.168.100.31:1080}"

# 内部函数：设置代理
_proxy_set() {
    local proxy_addr="$1"
    export http_proxy="$proxy_addr"
    export https_proxy="$http_proxy"
    export HTTP_PROXY="$http_proxy"
    export HTTPS_PROXY="$http_proxy"
    echo "✅ 代理已设置为：$http_proxy"
}

# 内部函数：取消代理
_proxy_unset() {
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
    echo "✅ 代理已关闭"
}

# 主函数：处理所有代理操作
proxy() {
    case "$1" in
        "on")
            _proxy_set "$JIMMY_SHELL_PROXY"
            ;;
        "off")
            _proxy_unset
            ;;
        "set")
            if [ -z "$2" ]; then
                echo "错误：请指定代理地址"
                echo "用法：proxy set http://proxy:port"
                return 1
            fi
            export JIMMY_SHELL_PROXY="$2"
            _proxy_set "$JIMMY_SHELL_PROXY"
            echo "✅ 默认代理已更新为：$JIMMY_SHELL_PROXY"
            ;;
        "status")
            if [ -n "$http_proxy" ]; then
                echo "当前代理：$http_proxy"
            else
                echo "当前未启用代理"
            fi
            echo "默认代理设置：$JIMMY_SHELL_PROXY"
            ;;
        *)
            echo "用法："
            echo "  proxy on              # 开启代理"
            echo "  proxy off             # 关闭代理"
            echo "  proxy set http://proxy:port  # 设置并保存新的默认代理"
            echo "  proxy status          # 显示代理状态"
            return 1
            ;;
    esac
}
