---
title: "微信支付 👀️ 支付宝支付"
date: 2022-12-15T17:54:48+08:00
tags: ["微信","支付宝","支付"]
cover:
    image: "https://cn.bing.com/th?id=OHR.DudhsagarFallsGoa_ZH-CN0466471017_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp"
    hidden: true 
---
#### 微信支付

https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_4

https://github.com/Wechat-Group/WxJava

https://pay.weixin.qq.com/wiki/doc/api/wxa/wxa_api.php?chapter=2_2

微信平台介绍：
1. 公众号平台
2. 商户平台
3. 开放平台

支付产品名字变更：

1. 公众号支付-变更为-JSAPI支付。 微信浏览器
2. 扫码支付-变更为-Native支付   系统按微信支付协议生成支付二维码，非移动支付
3. 刷卡支付-变更为-付款码支付 线下收银
4. APP支付。移动端sdk
5. H5支付  移动浏览器，区分不同微信浏览器
6. 小程序支付  小程序环境中支付

#### 其他待应用
1. 企业付款接口 ？
2. 付款到零钱-商户
3. 付款到银行卡-商户
4. 电子发票
5. 合单支付
6. 报关

https://api.mch.weixin.qq.com/v3/refund/domestic/refunds

#### 疑问
1. 商户证书 vs 平台证书 （可以理解客户端和服务端）
2. 证书过期问题（商户和平台），支付宝有提醒，微信无，过期需要开发手动替换

#### 支付宝支付

https://opendocs.alipay.com/open/204/01dcc0?ref=api


开放平台


AlipayConfig

CN=Ant Financial Certification Authority Class 1 R1, OU=Certification Authority, O=Ant Financial, C=CN
CN=2088421377101215-2021002127627083, OU=Alipay, O=鸿海（苏州）食品科技股份有限公司, C=CN

CN=支付宝(中国)网络技术有限公司-2088421377101215, OU=Alipay, O=鸿海（苏州）食品科技股份有限公司, C=CN
CN=Ant Financial Certification Authority Class 2 R1, OU=Certification Authority, O=Ant Financial, C=CN
CN=Ant Financial Certification Authority R1, OU=Certification Authority, O=Ant Financial, C=CN


signatuere alg:SHA384withECDSA    publickey : EC
CN=Ant Financial Certification Authority E1, OU=Certification Authority, O=Ant Financial, C=CN

signatuere alg:SHA256withRSA     publicKey: RSA (4,096 bits)
CN=Ant Financial Certification Authority R1, OU=Certification Authority, O=Ant Financial, C=CN

signatuere alg:SHA1withRSA  publicKey: RSA(2048)
CN=iTrusChina Class 2 Root CA - G3, OU=China Trust Network, O=iTrusChina, C=CN


签名主要包含两个过程：摘要和非对称加密，首先对需要签名的数据做摘要（类似于常见的MD5）后得到摘要结果，然后通过签名者的私钥对摘要结果进行非对称加密即可得到签名结果。

RSA2(SHA256WithRSA):（强烈推荐使用），强制要求RSA密钥的长度至少为2048.
RSA(SHA1WithRSA):对RSA密钥的长度不限制，推荐使用2048位以上

```
biz_content -> {"out_request_no":"HZ01RF003","out_trade_no":"DH-O-2022-12-08-978069","refund_amount":"0.01","refund_reason":"不想要了"}

{
    "alipay_trade_refund_response": {
        "code": "10000",
        "msg": "Success",
        "buyer_logon_id": "xia***@gmail.com",
        "buyer_user_id": "2088202345875734",
        "fund_change": "Y",
        "gmt_refund_pay": "2022-12-10 14:21:19",
        "out_trade_no": "DH-O-2022-12-08-978069",
        "refund_fee": "0.02",
        "send_back_fee": "0.00",
        "trade_no": "2022121022001475731434706311"
    },
    "alipay_cert_sn": "421f39ba4d8149cde08b15a426a12734",
    "sign": "C1tH+ax0yAMdWHNcBiHi7BLjHeNttrBA4X3hsgoftsQrrTvQogL2t/ZBS+wB8iuwfPddqyDkPdIMeKN7yjVSYNCdij8ufx1Kpk1i1RgIlzNUdH9zAO0lyCH5q6eHaRDwQBuY/BlCLc7Q5iZuW0fTkcz+UvQ+hMA++UMGh+gk2rq+89ZglZDuY8CC7zxxFuVD7pRdSE+tmoGwXi2HYmmZg0d0OYPhgI+MfnA+9vG+juLrYmHBWjyQrpQmXJecFzwWcKP3M0S9dLMSinHbfVyw7/2RG+vu3rBcDUYXjaghoTx8pVo7+wul+hr3+m7soG/RBaoV6nufCefu5pWyUbz4ZA=="
}

{"alipay_trade_refund_response":{"code":"10000","msg":"Success","buyer_logon_id":"xia***@gmail.com","buyer_user_id":"2088202345875734","fund_change":"Y","gmt_refund_pay":"2022-12-12 12:45:08","out_trade_no":"DH-O-2022-12-08-978069","refund_fee":"0.04","send_back_fee":"0.00","trade_no":"2022121022001475731434706311"},"alipay_cert_sn":"421f39ba4d8149cde08b15a426a12734","sign":"aaEbzHRSRbPfWdbuJ7rLTNCVNXqILvp28F/8p7d85D9xEcDa45MwbxSJsb0gx7zARBvQZT9+SPPPLoCEyLO3hWmmxGe6vO7C2G0AcEDxOhjgOGOyd40SmmagV2UkcpdmW18Wxu8yUM3bwGcuL8HxX8MMruunmNmk77NIyW4oDE/9miNMsoeUucUGA79FvrfnY7Xs4XPloGLIHhmrasJfsMh5+TMk3hjncLs9SVBtKGtg1LlVwyUT88cA4uF8eWmSHVxQ3kPCdRqB4lV18u2xlSVw0eT1zZ9+1blm0BXoi16B21S4Jn+xqBIFqRAVt3OabIzfFF4J7NMgRnoWiDfXXQ=="}

{
    "alipay_trade_refund_response": {
        "code": "40004",
        "msg": "Business Failed",
        "sub_code": "ACQ.DISCORDANT_REPEAT_REQUEST",
        "sub_msg": "退款金额不一致",
        "refund_fee": "0.00",
        "send_back_fee": "0.00"
    },
    "alipay_cert_sn": "421f39ba4d8149cde08b15a426a12734",
    "sign": "AbN/lkHQIYOqdfKkUo45fxsxCkiiq2+NLiOBaVrsoGp83ptbHFTZmHqRnFI7EzsKdkVQD1i5jP+5vUPLMpHqM6vTM8zMBco17BQhS2pqUZe8wVKBTKj2lalpbWurJNYIFgwt33Gl39c81YywtpXwzt/2oLoBnaj8CHlEioVVSof/USD8ikN/VwjllfinuiDjYKs7JB3MPk3275RPTSoP7tB8Vmz4Z0YD2b00txwxYa2S2w8pVS6/dAW5runCGws8o+GMgQqMw9Gpjuewt9DmhdbY+nUBo0wu4ojpUHA6ld9bDuhgH861WGvQz1pf1QXtYzV3kjDqyFsZU0OHVrKTfg=="
}
```

#### 测试

```
    @Test
    public void aliRefund() throws Exception{
        AlipayClient alipayClient = AlipayConfig.getAlipayClient();

        AlipayTradeRefundRequest request = new AlipayTradeRefundRequest();
        AlipayTradeRefundModel model = new AlipayTradeRefundModel();
        String orderNo = "SO-20221208-978060";
        model.setOutTradeNo(orderNo);
        model.setRefundAmount("0.03");
        model.setOutRequestNo("HZ01RF004");
        model.setRefundReason("不想要了");
        request.setBizModel(model);

        RdPayLog payLog = new RdPayLog();
        payLog.setOrderId(orderNo);
        payLog.setPaytype("支付宝退款");
        payLog.setRequestParam(JSON.toJSONString(model));
        try {
            AlipayTradeRefundResponse response = alipayClient.certificateExecute(request);
            payLog.setResponseParam(response.getBody());
            if (!response.isSuccess()) {
                throw new BizException(response.getSubMsg());
            }
        } catch (AlipayApiException e) {
            payLog.setResponseParam(e.getErrCode()+"==="+e.getErrMsg());
        }finally {
            payLogMapper.insert(payLog);
        }
    }


    @Test
    public void wxRefund() {
        String orderNo = "SO-20221208-978060";

        WxPayRefundRequest wxPayRefundRequest = new WxPayRefundRequest();
        wxPayRefundRequest.setOutTradeNo(orderNo);
        wxPayRefundRequest.setOutRefundNo("22222");
        wxPayRefundRequest.setRefundFee(2);
        wxPayRefundRequest.setRefundDesc("不好看 退货");
        wxPayRefundRequest.setTotalFee(2100);

        RdPayLog payLog = new RdPayLog();
        payLog.setOrderId(orderNo);
        payLog.setPaytype("微信退款");
        payLog.setRequestParam(wxPayRefundRequest.toXML());

        try {
            WxPayRefundResult result = wxService.refund(wxPayRefundRequest);
            payLog.setResponseParam(result.getXmlString());
        } catch (WxPayException e) {
            payLog.setResponseParam(e.getXmlString());
            throw new BizException(e.getMessage());
        }finally {
            payLogMapper.insert(payLog);
        }

    }
```



