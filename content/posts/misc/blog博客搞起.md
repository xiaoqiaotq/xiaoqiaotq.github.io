---
title: "博客建站"
date: 2022-12-05T13:47:00+08:00
draft: false
tags: ["杂"]
---

#### 技术选项

直接用Hugo 不要问我为什么

#### 安装

```
// 安装hugo
brew install hugo
// 检查是否安装成功，查看版本
hugo env
```
#### 目录
![20221206103218.jpg](https://s2.loli.net/2022/12/06/vZmtld6pw3TWAVF.jpg)

#### 启动

```
hugo new site xiaoqiaotq-blog
cd xiaoqiaotq-blog
git init
# 官方sample theme 
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
echo "theme = 'ananke'" >> config.toml

# 本地测试预览
hugo server -D
```

添加gitignore
```ignorelang
# Generated files by hugo
/public/
/resources/_gen/
/assets/jsconfig.json
hugo_stats.json

# Executable may be added to repository
hugo.exe
hugo.darwin
hugo.linux

# Temporary lock file while building
/.hugo_build.lock

.idea
```


#### 主题
暂时找个个简单的,有时间在找
PaperMod https://adityatelange.github.io/hugo-PaperMod/


#### 部署到github page
https://github.com/peaceiris/actions-hugo

1. github 新建repository, xiaoqiaotq.github.io
2. 关联远程remote ·`git remote add origin master  https://github.com/xiaoqiaotq/xiaoqiaotq.github.io.git
添加Action`
```yaml
name: github pages

on:
  push:
    branches:
      - main  # Set a branch that will trigger a deployment
  pull_request:

jobs:
  deploy:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public

```

#### 贴下配置 config.yml
```yaml
baseURL: "https://xiaoqiaotq.github.io"
languageCode: "zh-cn"
title: "xiaoqiaotq"
theme: "PaperMod"
menu:
  main:
    - identifier: 分类
      name: 分类
      url: /categories/
      weight: 10
    - identifier: 标签
      name: 标签
      url: /tags/
      weight: 20
#    - identifier: example
#      name: example.org
#      url: https://example.org
#      weight: 30
#    - identifier: home
#      name: 主页
#      url: /posts/hom
```

#### 访问
https://xiaoqiaotq.github.io

#### 参考
https://gohugo.io/getting-started/quick-start/





