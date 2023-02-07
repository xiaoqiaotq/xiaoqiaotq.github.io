---
title: "codepush热更新"
date: 2023-01-11T22:04:16+08:00
draft: false
tags: ["Android","Cordova"]
cover:
    image: "https://cn.bing.com/th?id=OHR.YearRabbit_ZH-CN2751166096_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp"
    hidden: true # only hide on current single page
---


codepush是微软一套热更新系统，托管部署资源如 react-native , cordova 等
CodePush-CLI 是热更新客户端工具，目前微软已废弃，建议使用AppCenter-CLI

#### Cordova 限制（只能更新静态资源，原生code不能更新）

Any product changes which touch native code (e.g. upgrading Cordova versions, adding a new plugin) cannot be distributed via CodePush, and therefore, must be updated via the appropriate store(s).

MainActivity 触发 webview 加载 file:///android\_asset/www/index.html

### code-push-cli 常用命令

```
#安装 最新为3.0 我们用2
yarn global add code-push-cli@2

code-push -h
# 会打开浏览器 https://appcenter.ms/cli-login?hostname=CISZ03-0820 弹出token 
code-push login
# admin 123456
code-push login https://code-push.xx.top/


code-push whoami

# 创建app 默认创建两个deployment Production, Staging
#code-push app add <appName> <os> <platform>
 code-push app add sankyu-test android cordova

# 查看应用
code-push app ls
code-push deployment ls sankyu-test -k
# 查看deployment
#code-push deployment history <appName> <deploymentName> [options]
code-push deployment history sankyu-test Staging
code-push deployment history sankyu-test Production

# 发布 版本以config.xml version 为准,可以手动指定
# code-push release-cordova <appName> <platform> [options]
code-push release-cordova sankyu-test android  -d Staging -t 0.0.2
# 发布 ^0.0.1
quasar build -m android
code-push release-cordova sankyu-test android  -d Production -t  "^0.0.1"



```

![1638165009\_1\_.jpg](https://i.loli.net/2021/11/29/i8PzgEbM6HCtmSF.png)

![Dingtalk\_20211129161908.jpg](https://i.loli.net/2021/11/29/tWUB1RJeSybKp8h.jpg)

### 部署code-push-server

<https://github.com/lisong/code-push-server/blob/master/docker/README.md>

    git clone https://github.com/lisong/code-push-server.git
    cd code-push-server/docker


    vim docker-compose.yml
    # 替换ip
    :%s/YOU_MACHINE_IP/your ip/g

    修改镜像为  panshx/code-push-server:latest


    修改config.js中tokenSecret
    可以打开连接https://www.grc.com/passwords.htm获取 63 random alpha-numeric characters类型的随机生成数作为密钥

    可选修改存储 config.js
    common.storageType: 'oss'
      oss: {
        accessKeyId: "",
        secretAccessKey: "",
        endpoint: "https://oss-cn-shanghai.aliyuncs.com",
        bucketName: "bucketName",
        prefix: "", // Key prefix in object key
        downloadUrl: "https://bucket.oss-cn-shanghai.aliyuncs.com/", // binary files download host address.
      },


    #启动
    1. 启动redis 有就复用，没有单独起
    docker run --name redis -v redisdata:/data -p 6379:6379 -d redis:4.0.11-alpine
    2. 启动mysql，导入sql，会自动创建数据库，表
      ./sql/codepush-all.sql:/docker-entrypoint-initdb.d/codepush-all.sql
    3. 启动服务
    docker-compose up
    // docker stack deploy -c docker-compose.yml code-push-server

    # 测试连通性 admin 123456 默认登录密码
    curl -I http://your ip:3000/

#### docker-compose.yml 改写

    version: "3.7"
    services:
      server:
        image: panshx/code-push-server:latest
        volumes:
          - data-storage:/data/storage
          - data-tmp:/data/tmp
          - ./config.js:/config.js
        environment:
          DOWNLOAD_URL: "http://YOU_MACHINE_IP:3000/download"
          MYSQL_HOST: "10.0.4.3"
          MYSQL_PORT: "3306"
          MYSQL_USERNAME: "codepush"
          MYSQL_PASSWORD: "123456"
          MYSQL_DATABASE: "codepush"
          STORAGE_DIR: "/data/storage"
          DATA_DIR: "/data/tmp"
          NODE_ENV: "production"
          CONFIG_FILE: "/config.js"
          REDIS_HOST: "10.0.4.3"
          REDIS_PORT: "6379"
          VIRTUAL_HOST: httpbin.xiaoqiaotq.top
          LETSENCRYPT_HOST: httpbin.xiaoqiaotq.top
          VIRTUAL_PORT: 3000
        deploy:
          resources:
            limits:
              cpus: "2"
              memory: 1000M
          restart_policy:
            condition: on-failure
        ports:
          - "3000:3000"
        networks:
          - servernet
    networks:
      servernet:
    volumes:
      data-storage:
      data-tmp:

### 客户端接入

<https://github.com/Microsoft/cordova-plugin-code-push>

<https://www.itguliang.com/post/bdc17ac0.html>

```
cordova plugin add cordova-plugin-code-push@latest

### 修改config.xml
<platform name="android">
    <allow-intent href="market:*" />
    <preference name="CodePushDeploymentKey" value="nVHPr6asLSusnWoLBNCSktk9FWbiqLF160UDgcc" />
    <preference name="CodePushServerUrl" value="https://code-push.aa.top/" />
</platform>

### 代码接入
codePush.sync();


```
#### 抓包

##### 发版
`
code-push release-cordova wms-test android  -d Staging -t 1.1.1
`

```
POST /apps/wms-test/deployments/Staging/release HTTP/1.1
Host: localhost:3000
Accept-Encoding: gzip, deflate
User-Agent: node-superagent/3.8.3
X-CodePush-CLI-Version: 2.1.9
Accept: application/vnd.code-push.v2+json
Authorization: Bearer tLDLTtCUSRYrO4P2BntrzPktkrgq4ksvOXqog
X-CodePush-SDK-Version: 2.0.6
content-type: multipart/form-data; boundary=--------------------------641068731626182805276171
Content-Length: 931966
Connection: close

----------------------------641068731626182805276171
Content-Disposition: form-data; name="package"; filename="m6Xk8At6CX1ZRtH.zip"
Content-Type: application/zip

PK..........GV............
...www/.DS_Store..A
.@......6.l....H...D.
...w..:Z..W.&A.......{..f.<.Xun6...#...%.3".l~..=v]..}......o.8...B.!.........!..!.|(...... .E9.......q ..9.....!.....0~........~.B,.4.....d./.X0.m..
----------------------------641068731626182805276171
Content-Disposition: form-data; name="packageInfo"

{"description":"","isDisabled":false,"isMandatory":false,"rollout":100,"appVersion":"1.1.1"}
----------------------------641068731626182805276171--


HTTP/1.1 200 OK
X-DNS-Prefetch-Control: off
X-Frame-Options: SAMEORIGIN
Strict-Transport-Security: max-age=15552000; includeSubDomains
X-Download-Options: noopen
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization, X-CodePush-Plugin-Version, X-CodePush-Plugin-Name, X-CodePush-SDK-Version
Access-Control-Allow-Methods: PUT,POST,GET,PATCH,DELETE,OPTIONS
Content-Type: text/html; charset=utf-8
Content-Length: 18
ETag: W/"12-VQcfpGWTIWZxIW5CJEu508IDMlk"
Date: Tue, 07 Feb 2023 08:35:40 GMT
Connection: close

{"msg": "succeed"}
```

![WX20230207-164303@2x.png](https://s2.loli.net/2023/02/07/TxMJ2DlaXK5v41W.png)

##### 代码更新检查 codepush.sync()调用
```
http://localhost:3000/v0.1/public/codepush/update_check?deployment_key=K4TwqkWsAnkWjBIHaOijClKrMygF4ksvOXqog&app_version=1.3.4&package_hash=f7d21597ae65922062c71f7bac4fc7deef60c7775b82ede0f004f8a336dc73d9

# 有更新返回示例(返回最新版本)
{
    "update_info":{
        "download_url":"https://aaa.oss-cn-shanghai.aliyuncs.com//FnsxIg4pOx_TAzuvnlognY0qXpsS",
        "description":"",
        "is_available":true,
        "is_disabled":false,
        "target_binary_range":"1.0.0",
        "label":"v6",
        "package_hash":"827ec4301e2fbc59e297ac05ed26465e5449492d0391219dbc6bcb6f3c2c6e44",
        "package_size":931523,
        "should_run_binary_version":false,
        "update_app_version":false,
        "is_mandatory":false
    }
}

# hash一致，返回空的update_info
{"update_info":{"download_url":"","description":"","is_available":false,"is_disabled":true,"target_binary_range":"","label":"","package_hash":"","package_size":0,"should_run_binary_version":false,"update_app_version":false,"is_mandatory":false}}
```



#### 困扰的问题
app_version不会变，除非在config.xml指定新版version，此时需要重新打apk包，热更新就失去价值了，热更新只会更新label（v2 数字累加）




#### 源码分析



#### 参考：
1. https://www.itguliang.com/post/bdc17ac0.html
2. https://github.com/lisong/code-push-server