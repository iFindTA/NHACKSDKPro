//
//  ACKApi.m
//  ACKSDK
//
//  Created by hu jiaju on 16/2/19.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "ACKApi.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <AdSupport/ASIdentifierManager.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@interface ACKApi ()

+ (ACKApi *)shared;

@property (nullable, nonatomic, strong) NSString *appkey;
@property (nonatomic, assign) BOOL logable,encyptable;
@property (nonatomic, strong, nullable) Reachability *reachManager;

@end

#define ACKV_major 1
#define ACKV_middl 2
#define ACKV_last  2

static ACKApi *instance = nil;
static NSString *domain = @"www.baidu.com";
static NSString *hosts  = @"https://ack.gongshidai.com/v1";

@implementation ACKApi

+ (ACKApi *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[ACKApi alloc] init];
        }
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.logable = true;
        self.encyptable = true;
    }
    return self;
}

- (Reachability *)reachManager {
    if (!_reachManager) {
        _reachManager = [Reachability reachabilityWithHostname:domain];
        sleep(0.02);
    }
    return _reachManager;
}

- (BOOL)netEnable {
    return [self.reachManager isReachable];
}

+ (NSString *)idfa {
    return [[ACKApi shared] idfa];
}

+ (void)enableLog:(BOOL)enable {
    [[ACKApi shared] setLogable:enable];
}

+ (void)enableEncryptTransfer:(BOOL)enable {
    [[ACKApi shared] setEncyptable:enable];
}

- (NSString *)idfa {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSString *)common:(NSString *)extend {
    NSString *idfa = [self idfa];
    NSString *infoParam = [NSString stringWithFormat:@"mobile=iphone&token=%@&%@",idfa,extend];
    return infoParam;
}

- (NSString *)encryptBody:(NSString *)info {
    
    //TODO::加密传输数据
    return info;
}

/*!
 *  @brief 用户下载应用后启动
 *
 *  @param appkey 商户appkey
 *
 *  @return 成功与否
 */
+ (BOOL)startWithAppkey:(NSString *)appkey {
    return [[self class] startWithAppkey:appkey withDescription:nil];
}

/*!
 *  @brief 用户下载应用后启动
 *
 *  @param appkey 商户appkey
 *  @param desc   附加信息，长度不超过1024字节
 *
 *  @return 成功与否
 */
+ (BOOL)startWithAppkey:(NSString *)appkey withDescription:(NSString *)desc {
    return [[ACKApi shared] startLaunchPartnersAppkey:appkey withInfo:desc];
}

- (BOOL)startLaunchPartnersAppkey:(NSString *)appkey withInfo:(NSString *)info {
    //设置appkey
    self.appkey = appkey;
    
    BOOL ret = false;
    NSMutableString *tmpInfo = [NSMutableString stringWithFormat:@"appkey=%@",appkey];
    if (info) {
        [tmpInfo appendFormat:@"&desc=%@",info];
    }
    NSString *infoParam = [tmpInfo copy];
    infoParam = [self common:[infoParam copy]];
    ret = [self post:@"/m_download" params:infoParam];
    return ret;
}

/*!
 *  @brief 第三方应用用户注册行为
 *
 *  @param appkey  商户appkey
 *  @param account 用户账号
 *
 *  @return 成功与否
 */
+ (BOOL)startRegisterWithUserAccount:(NSString *)account {
    return false;
}

/*!
 *  @brief 用户实名认证
 *
 *  @param name  用户真实姓名
 *  @param phone 用户真实手机号
 *  @param nid   用户身份证id
 *
 *  @return 成功与否
 */
+ (BOOL)startAuthenticationWithName:(NSString *)name withPhone:(NSString *)phone withID:(NSString *)nid {
    return [[ACKApi shared] startAuthenticationWithName:name withPhone:phone withID:nid];
}

- (BOOL)startAuthenticationWithName:(NSString *)name withPhone:(NSString *)phone withID:(NSString *)nid {
    BOOL ret = false;
    NSMutableString *tmpInfo = [NSMutableString stringWithFormat:@"appkey=%@&phone=%@&name=%@&idc=%@",self.appkey,phone,name,nid];
    NSString *infoParam = [tmpInfo copy];
    infoParam = [self common:[infoParam copy]];
    ret = [self post:@"/m_realname" params:infoParam];
    return ret;
}

/*!
 *  @brief 用户投资购买
 *
 *  @param amount  购买金额
 *  @param account 购买者账号
 *
 *  @return 成功与否
 */
+ (BOOL)startPurchase:(NSNumber *)amount forAccount:(NSString *)account {
    return [[ACKApi shared] startPurchase:amount forAccount:account];
}

- (BOOL)startPurchase:(NSNumber *)amount forAccount:(NSString *)account {
    BOOL ret = false;
    NSMutableString *tmpInfo = [NSMutableString stringWithFormat:@"appkey=%@&phone=%@&amount=%@",self.appkey,account,amount];
    NSString *infoParam = [tmpInfo copy];
    infoParam = [self common:[infoParam copy]];
    ret = [self post:@"/m_investment" params:infoParam];
    return ret;
}

- (BOOL)netWorkFine {
    //    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [domain UTF8String]);
    //    SCNetworkReachabilityFlags flags;
    //    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    //    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) &&
    //    !(flags & kSCNetworkFlagsConnectionRequired);
    //    CFRelease(reachability);
    //
    //    return isAvailable;
    
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // SCNetworkReachabilityCreateWithAddress：根据传入的IP地址测试连接状态，当为0.0.0.0时则可以查询本机的网络连接状态。
    // 使用SCNetworkReachabilityCreateWithAddress：可以根据传入的网址地址测试连接状态
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags){
        printf("Error. Could not recover network reachability flags\n");
        return false;
    }
    
    // kSCNetworkReachabilityFlagsReachable：能够连接网络
    // kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
    // kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? true : false;
}

- (BOOL)post:(NSString *)path params:(NSString *)params {
    __block BOOL ret = false;
    //网络联通性检测
//    if (![self netWorkFine]) {
//        [self loggedInfo:@"貌似木有网了"];
//        return ret;
//    }
    
    if (_reachManager == nil) {
        [self.reachManager reachabilityFlags];
        if (![self netWorkFine]) {
            [self loggedInfo:@"貌似木有网了"];
            return ret;
        }
    }else{
        if (![self netEnable]) {
            [self loggedInfo:@"貌似您木有网络链接了"];
            return ret;
        }
    }
    
    NSAssert(path != nil, @"ack request path can not be nil !");
    NSAssert(params != nil, @"ack request params can not be nil !");
    if (self.appkey && path && params) {
        
        if (self.encyptable) {
            //TODO:Body数据加密
            params = [self encryptBody:params];
        }
        NSMutableString *urlPath = [NSMutableString stringWithString:hosts];
        [urlPath appendString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        //开始请求
//        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSession *session = [NSURLSession sharedSession];
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [self loggedInfo:[NSString stringWithFormat:@"ack response failed by :%@",error.localizedDescription]];
            }else{
                if (data) {
                    NSError *err;
                    NSDictionary *retDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    NSString *logger ;
                    if (err) {
                        logger = [err localizedDescription];
                    }else{
                        logger = [retDict description];
                        NSNumber *code = [retDict objectForKey:@"code"];
                        ret = [code isEqualToNumber:@0];
                    }
                    [self loggedInfo:[NSString stringWithFormat:@"ack response failed by :%@",logger]];
                }else{
                    [self loggedInfo:@"ack response nothing else !, please contact to developer !"];
                }
            }
            
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        [self loggedInfo:@"appkey was set by nil value! please set appkey with method:startWithAppkey: !"];
    }
    
    return ret;
}

+ (NSString *)version {
    return [NSString stringWithFormat:@"%zd.%zd.%zd",ACKV_major,ACKV_middl,ACKV_last];
}

- (void)loggedInfo:(NSString *)info {
    if (self.logable) {
        NSLog(@"%@",info);
    }
}

@end
