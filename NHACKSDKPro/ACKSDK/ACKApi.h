//
//  ACKApi.h
//  ACKSDK
//
//  Created by hu jiaju on 16/2/19.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief SDK's Api
 *
 *  @attention tobe use please import:
 *  system framework :AdSupport.framework SystemConfiguration.framework
 *
 */
@interface ACKApi : NSObject

/*!
 *  @brief get device's idfa
 *
 *  @return the device's idfa
 */
+ (NSString *)idfa;

/*!
 *  @brief log function, default is YES
 *
 *  @param enable wether enabled
 */
+ (void)enableLog:(BOOL)enable;

/*!
 *  @brief encypt data that transfer to server, default is YES
 *
 *  @attention this function has not been implemented !!!
 *  @warning   this function has not been implemented !!!
 *
 *  @param enable wether enabled
 */
+ (void)enableEncryptTransfer:(BOOL)enable;

/*!
 *  @brief start method for partber's app
 *  
 *  @Usage when the user has been dowload the partner's app and launch it then
 *  must should call this function in :
 *  application: didFinishLaunchingWithOptions: method
 *
 *  @param appkey the partner's appkey
 *  @see   startWithAppkey: withDescription:
 *  @return YES if successfully, otherwise NO
 */
+ (BOOL)startWithAppkey:(NSString *)appkey;

/*!
 *  @brief start method
 *
 *  @Usage when the user has been dowload the partner's app and launch it then
 *  must should call this function in :
 *  application: didFinishLaunchingWithOptions: method
 *
 *  @param appkey the partner's appkey
 *  @param desc   the extend infomation for app, no morethan 1024 Bits
 *  @see   startWithAppkey:
 *  @return YES if successfully, otherwise NO
 */
+ (BOOL)startWithAppkey:(NSString *)appkey withDescription:(NSString *)desc;

/*!
 *  @brief register action for application
 *
 *  @param account the user's account
 *
 *  @return result for register
 */
+ (BOOL)registerWithUserAccount:(NSString *)account;

/*!
 *  @brief authentication for user
 *
 *  @param name  user's real name
 *  @param phone user's mobile phone
 *  @param nid   user's card id
 *
 *  @return result for authentication
 */
+ (BOOL)authenticationWithName:(NSString *)name withPhone:(NSString *)phone withID:(NSString *)nid;

/*!
 *  @brief purchase or investment for user
 *
 *  @param amount  the money user puchased
 *  @param account the user's account eg. phone
 *
 *  @return result for user puchase
 */
+ (BOOL)purchase:(NSNumber *)amount forAccount:(NSString *)account;

/*!
 *  @brief SDK's version
 *
 *  @return the libACKSDK's current version
 */
+ (NSString *)version;

@end
