#!/bin/bash
# ========================================
#  ics-pa-gitbook 一键构建脚本
#  生成 _book 静态文件夹
#  用法: ./build.sh
# ========================================
set -e

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

ORIG_NODE_VERSION=$(node -v 2>/dev/null | sed 's/v//')
BUILD_NODE_VERSION="10"

echo "==> 切换到 Node.js v${BUILD_NODE_VERSION}..."
nvm use "$BUILD_NODE_VERSION" 2>/dev/null || {
    echo "    Node v${BUILD_NODE_VERSION} 未安装，正在安装..."
    nvm install "$BUILD_NODE_VERSION"
    nvm use "$BUILD_NODE_VERSION"
}

# 安装 gitbook-cli（如果还没装）
if ! command -v gitbook &>/dev/null; then
    echo "==> 安装 gitbook-cli..."
    npm install -g gitbook-cli
fi

echo "==> 预下载 GitBook 3.2.3..."
gitbook fetch 3.2.3

echo "==> 安装项目依赖..."
rm -rf node_modules
npm install --no-audit

echo "==> 修复 gitbook-plugin-callouts 兼容性..."
sed -i -r 's/<h3>/<h5>/' node_modules/gitbook-plugin-callouts/index.js

echo "==> 编译 GitBook..."
gitbook build .

echo ""
echo "===== 构建完成 ====="
echo "输出目录: $(pwd)/_book"
echo "文件数量: $(find _book -type f | wc -l)"
echo "目录大小: $(du -sh _book | cut -f1)"

# 恢复原始 Node 版本
if [ -n "$ORIG_NODE_VERSION" ]; then
    echo "==> 恢复 Node.js v${ORIG_NODE_VERSION}..."
    nvm use "$ORIG_NODE_VERSION" 2>/dev/null || true
fi
