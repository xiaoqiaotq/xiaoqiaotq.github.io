---
title: "Iterm lrzsz"
date: 2022-12-16T09:16:19+08:00
tags: ["linux","shell","iterm"]
cover:
    image: "https://cn.bing.com/th?id=OHR.GlacierGoats_ZH-CN0764810245_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp"
    hidden: true 
---

https://wsgzao.github.io/post/lrzsz/

https://gist.github.com/meowoodie/4bcf6d6ae81727b618bf

lrzsz 客户端 服务端都得安装
```
# 安装本地 默认装在/opt/homebrew/bin 目录
brew install lrzsz

# 在 / usr/loal/bin 目录下创建两个文件
cd /usr/local/bin
wget https://raw.githubusercontent.com/RobberPhex/iterm2-zmodem/master/iterm2-recv-zmodem.sh
wget https://raw.githubusercontent.com/RobberPhex/iterm2-zmodem/master/iterm2-send-zmodem.sh

# 赋予这两个文件可执行权限
chmod 777 /usr/local/bin/iterm2-*

# 配置item 见下图 Perference-> Profiles -> Default -> Advanced -> Triggers 的 Edit 按钮，

Regular expression: rz waiting to receive.\*\*B0100
Action: Run Silent Coprocess
Parameters: /usr/local/bin/iterm2-send-zmodem.sh
Instant: checked

Regular expression: \*\*B00000000000000
Action: Run Silent Coprocess
Parameters: /usr/local/bin/iterm2-recv-zmodem.sh
Instant: checked

改脚本sh /usr/local/bin to /opt/homebrew/bin/

```
![image](https://raw.githubusercontent.com/wsgzao/storage-public/master/img/20201102111035.png)