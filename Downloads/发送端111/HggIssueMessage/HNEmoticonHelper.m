//
//  HNEmoticonHelper.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/7.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNEmoticonHelper.h"

@implementation HNEmoticonHelper
+ (NSDictionary *)emoticonMapper {
    return @{
             @"[玫瑰]":       [UIImage imageNamed:@"073"],
             @"[赞]":         [UIImage imageNamed:@"084"],
             @"[泪奔]":       [UIImage imageNamed:@"057"],
             @"[小鼓掌]":      [UIImage imageNamed:@"039"],
             @"[可爱]":       [UIImage imageNamed:@"059"],
             @"[灵光一闪]":    [UIImage imageNamed:@"063"],
             @"[呲牙]":       [UIImage imageNamed:@"014"],
             @"[捂脸]":       [UIImage imageNamed:@"066"],
             @"[抠鼻]":       [UIImage imageNamed:@"038"],
             @"[机智]":       [UIImage imageNamed:@"052"],
             @"[许愿]":       [UIImage imageNamed:@"049"],
             @"[送心]":       [UIImage imageNamed:@"076"],
             @"[耶]":         [UIImage imageNamed:@"087"]
             };
}

//获取当前时间戳有两种方法(以秒为单位)

+ (NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)interval format:(NSString *)formating
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formating];
    return [dateFormatter stringFromDate:date];
}
@end
