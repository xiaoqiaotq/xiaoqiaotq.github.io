---
title: "Openssl"
date: 2022-12-09T17:17:20+08:00
draft: false
tags: ["Linux","安全"]
---

reference https://www.madboa.com/geek/openssl

#### 常用命令

##### X509证书
```
# 等于cat alipay/alipayCertPublicKey_RSA2.crt
openssl x509 -in alipay/alipayCertPublicKey_RSA2.crt
# 格式化输出
openssl x509 -in alipay/alipayCertPublicKey_RSA2.crt -noout  -text
# 导出 public key
openssl x509 -in ~/cert/wxpay/apiclient_cert.pem -pubkey -noout > public.pem
```
##### 摘要

```
openssl md5  ~/Downloads/CertTrustChain.p7b
openssl sha256 ~/Downloads/CertTrustChain.p7b
```

##### p12
p12是个keystore，可以存放证书，私钥

```
# 提取私钥 可能需要输入密码
openssl pkcs12 -in wxpay/apiclient_cert.p12  -out aa-key.pem -nocerts
# 提取证书（证书带公钥）
openssl pkcs12 -in wxpay/apiclient_cert.p12  -out aa.crt -clcerts -nokeys
# 证书提取公钥
openssl x509 -in aa.crt -pubkey -noout > public.pem

```

##### p7
证书信任链

```
# 二进制der转化为 text
openssl pkcs7 -in Downloads/CertTrustChain.p7b  -inform der -print_certs -out chain.cer
# 验证商户证书 最后的是叶子证书
openssl verify -CAfile chain.cer cert/wxpay/apiclient_cert.pem
```
