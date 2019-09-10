//
//  NSDateFormatter+Helper.m
//  Location
//
//  Created by BIN on 2017/12/21.
//  Copyright © 2017年 Location. All rights reserved.
//

#import "NSDateFormatter+Helper.h"
#import "NNGloble.h"

const NSInteger kDate_second = 1 ;
const NSInteger kDate_minute = 60 ;
const NSInteger kDate_hour = 3600 ;
const NSInteger kDate_day = 86400 ;
const NSInteger kDate_week = 604800 ;
const NSInteger kDate_year = 31556926;

NSString * const kFormatDate = @"yyyy-MM-dd HH:mm:ss";
NSString * const kFormatDate_mm = @"yyyy-MM-dd HH:mm";
NSString * const kFormatDate_dd = @"yyyy-MM-dd";

NSString * const kFormatDate_two = @"yyyyMMdd";
NSString * const kFormatDate_five = @"yyyyMMddHHmmss";
NSString * const kFormatDate_Six = @"EEE, dd MMM yyyy HH:mm:ss 'GMT'";

@implementation NSDateFormatter (Helper)

+ (NSDateFormatter *)dateFormat:(NSString *)formatStr{
    // 版本2 ，使用当前线程字典来保存对象
    NSMutableDictionary *threadDic = NSThread.currentThread.threadDictionary;
    NSDateFormatter *formatter = [threadDic objectForKey:formatStr];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = formatStr;
        formatter.locale = [NSLocale localeWithLocaleIdentifier:kLanguageCN];
        formatter.timeZone = NSTimeZone.systemTimeZone;
        if ([formatStr containsString:@"GMT"]) {
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        }

        [threadDic setObject:formatter forKey:formatStr];
    }
    return formatter;
}

/**
 NSDate->日期字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter * fmt = [NSDateFormatter dateFormat:format];
    return [fmt stringFromDate:date];
}
/**
 日期字符串->NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateStr format:(NSString *)format{
    NSDateFormatter * fmt = [NSDateFormatter dateFormat:format];
    return [fmt dateFromString:dateStr];
}

/**
 时间戳->日期字符串
 */
+ (NSString *)stringFromInterval:(NSString *)interval format:(NSString *)format{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval.doubleValue];
    return [NSDateFormatter stringFromDate:date format:format];
}

/**
 日期字符串->时间戳字符串
 */
+ (NSString *)intervalFromDateStr:(NSString *)dateStr format:(NSString *)format{
    NSDate * date = [NSDateFormatter dateFromString:dateStr format:format];
    NSString *intervalStr = [@(date.timeIntervalSince1970) stringValue];
    intervalStr = [intervalStr stringByReplacingOccurrencesOfString:@".00" withString:@""];
    return intervalStr;
}

/**
 时间戳->NSDate
 */
+ (NSDate *)dateFromInterval:(NSString *)interval{
    return [NSDate dateWithTimeIntervalSince1970:interval.doubleValue];
}

/**
 NSDate->时间戳
 */
+ (NSString *)intervalFromDate:(NSDate *)date{
    return [@(date.timeIntervalSince1970) stringValue];
}

//+ (NSString *)currentGMT {
//
//    NSDate *date = NSDate.date;
//    NSTimeZone.defaultTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];;
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss 'GMT'";
//    formatter.locale = [NSLocale localeWithLocaleIdentifier:kLanguageCN];
//    return [formatter stringFromDate:date];
//}

@end