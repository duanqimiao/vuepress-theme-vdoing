#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
npm run build

# 进入生成的文件夹
cd docs/.vuepress/dist

# deploy to github
echo 'b.duanqimiao.com' > CNAME
if [ -z "$GITHUB_TOKEN" ]; then
  msg='deploy'
  githubUrl=git@github.com:duanqimiao/vuepress-theme-vdoing.git
else
  msg='来自github actions的自动部署'
  githubUrl=https://duanqimiao:${GITHUB_TOKEN}@github.com/duanqimiao/vuepress-theme-vdoing.git
  git config --global user.name "duanqimiao"
  git config --global user.email "duanqimiao@gmail.com"
fi
git init
git add -A
git commit -m "${msg}"
git push -f $githubUrl master:gh-pages # 推送到github

# deploy to coding
# 如果是发布到自定义域名
# echo 'xugaoyi.com' > CNAME

# 如果发布到 https://<USERNAME>.github.io
git push -f git@github.com:duanqimiao/duanqimiao.github.io.git master

# 如果发布到 https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com:<USERNAME>/<REPO>.git master:gh-pages
if [ -z "$CODING_TOKEN" ]; then  # -z 字符串 长度为0则为true；$CODING_TOKEN来自于github仓库`Settings/Secrets`设置的私密环境变量
  codingUrl=git@e.coding.net:xgy/xgy.git
else
  codingUrl=https://HmuzsGrGQX:${CODING_TOKEN}@e.coding.net/xgy/xgy.git
fi
git add -A
git commit -m "${msg}"
git push -f $codingUrl master # 推送到coding

cd - # 退回开始所在目录
rm -rf docs/.vuepress/dist