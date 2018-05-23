//
//  HNEmoticonHelper.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/7.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CommonCrypto/CommonDigest.h>
@interface HNEmoticonHelper : NSObject
+ (NSDictionary *)emoticonMapper;
//获取当前时间戳
+ (NSString *)getNowTimeTimestamp;
//MD5加密
+ (NSString *)md5:(NSString *)inpu;
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)interval format:(NSString *)formating;
@end
