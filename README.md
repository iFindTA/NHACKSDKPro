# 爱财客终端SDK文档（for iOS）
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://ack.gongshidai.com/backstage/index.html#/access/home)
[![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)](https://ack.gongshidai.com/backstage/index.html#/access/home)
[![Build](https://img.shields.io/badge/Build-Passed-green.svg)](https://ack.gongshidai.com/backstage/index.html#/access/home)
#### 接入指南
注：本文为爱财客iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉Xcode开发工具的基本使用方法，以及具有一定的编程知识基础等。
##### 1.向爱财客注册你的应用程序appkey
请到 [商家应用登记页面](https://ack.gongshidai.com/getappkey) 进行登记，登记并选择移动应用进行设置后，将获得Appkey，可立即用于开发。但应用登记完成后还需要提交审核，只有审核通过的应用才能正式发布使用。
##### 2.下载爱财客终端SDK文件
SDK文件包括 libACKSDK.a，ACKApi.h 二个。
请前往“[资源下载页](https://github.com/iFindTA/NHACKSDKPro)”下载最新SDK包
##### 3.搭建开发环境
[1] 在XCode中建立你的工程。

[2] 将SDK文件中包含的libACKSDK.a，ACKApi.h 两个文件添加到你所建的工程中（如下图所示，建立了一个名为NHACKSDKPro 的工程，并把以上两个文件添加到NHACKSDKPro文件夹下）。
(注：请使用Xcode4.5及以上版本)
![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/ack_0.png)

[3]开发者需要在工程中链接系统库:
<code>
SystemConfiguration.framework,AdSupport.framework。
</code>

[4]由于使用了HTTPS安全链接，需要在info.plist文件中设置ATS项：
![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/ack_1.png)

[5] 在你需要使用爱财客终端API的文件中import ACKApi.h 头文件。
![image](https://raw.githubusercontent.com/iFindTA/screenshots/master/ack_2.png)

##### 4.在代码中使用开发工具包
[1] 要使你的程序启动后爱财客后台记录到用户下载完毕动作，必须在代码中向爱财客服务端注册你的appkey。（如下图所示，在 AppDelegate 的 didFinishLaunchingWithOptions 函数中向爱财客注册appkey）
```ObjectiveC
/*!
 *  @brief 需替换为自己的appkey
 */
static NSString *ACK_APP_KEY   = @"4FCUND77NX2C4S";
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //default is YES
    [ACKApi enableLog:true];
    [ACKApi startWithAppkey:ACK_APP_KEY];
    
    return YES;
}
```

[2] 现在，你的程序要实现用户注册、实名、投资等动作记录同步到爱财客服务端需要调用如下列方法：
用户注册：
```ObjectiveC
- (void)registerEvent {
    NSString *m_phone = [NSString stringWithFormat:@"1302362xxxx"];
    BOOL ret = [ACKApi registerWithUserAccount:m_phone];
    [self.label setText:ret?@"1":@"0"];
    NSLog(@"result : %zd",ret);
}
```

实名认证：
```ObjectiveC
- (void)authenticationEvent {
    NSString *m_phone = [NSString stringWithFormat:@"1302362xxxx"];
    BOOL ret = [ACKApi authenticationWithName:@"张三" withPhone:m_phone withID:@"410222xxxxxxxx1552"];
    [self.label setText:ret?@"1":@"0"];
    NSLog(@"result : %zd",ret);
}
```

用户投资：
```ObjectiveC
- (void)purchaseEvent {
    NSString *m_phone = [NSString stringWithFormat:@"1302362xxxx"];
    BOOL ret = [ACKApi purchase:@1000 forAccount:m_phone];
    [self.label setText:ret?@"1":@"0"];
    NSLog(@"result : %zd",ret);
}
```

[3] 如果方法返回false，可打开终端SDK的log功能查看
```ObjectiveC
	//default is YES
    [ACKApi enableLog:true];
```
具体在方法中所要完成的内容由你定义，具体可参考爱财客开发工具包中的[SDK Sample Demo](https://github.com/iFindTA/NHACKSDKPro)源码。

* * *
#### Response Code:

```
|   code   |   description   |
|----------|-----------------|
|    0     |    操作成功		
|    1     |    参数异常		
|    2     |    系统异常		
|    3     |    状态异常		
|    4     |    方法未实现		
|    5     |    不正当入侵		
|    6     |    操作超时		
|    7     |    请稍后再试		
|   401    |    没有权限		
|   503    |    没有方法		
|  90000   |    未找到商家		
|  90001   |    不是平台下载		
|  90002   |    任务已完成		
|  90003   |    任务异常		
```

* * *

#### 更新日志:

###### 版本:V1.3.2
```
减小SDK大小
```

###### 版本:V1.3.1-Beta
```
引入RealReachability库，防止在网络假链接的情形下判断失败
```

###### 版本:V1.2.3
```
* remove Reachability framework, judge the network by native code.
* make the interface more simple
```

###### 版本:V1.2.2
```
增加Reachability库依赖，需要导入此第三方库
```

###### 版本:V1.2.1
```
优化网络模块，原生判断
```

###### 版本:V1.1.1
```
简化API访问接口
```

###### 版本:V0.1.1
```
new project for sdk
```

* * *
###### contact:
**mail:nanhujiaju@gmail.com**