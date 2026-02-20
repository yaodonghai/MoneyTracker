#!/bin/bash
# 推送代码到 GitHub 的脚本
# 使用方法：./push_to_github.sh <你的GitHub仓库地址>

if [ -z "$1" ]; then
    echo "错误：请提供 GitHub 仓库地址"
    echo "使用方法: ./push_to_github.sh https://github.com/yaodonghai/MoneyTracker.git"
    exit 1
fi

REPO_URL=$1

echo "添加远程仓库..."
git remote add origin $REPO_URL

echo "推送到 GitHub..."
git push -u origin main

echo "完成！代码已推送到 GitHub"
echo "仓库地址: $REPO_URL"
