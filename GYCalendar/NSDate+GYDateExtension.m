//
//  NSDate+GYDateExtension.m
//  GYCalendar
//
//  Created by GY on 16/2/27.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "NSDate+GYDateExtension.h"

@implementation NSDate (GYDateExtension)

/** 将date转为"format"格式的字符串 */
- (NSString *)gy_dateByFormat:(NSString *)formator
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = formator;
    //避免时区误差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *date = [self dateByAddingTimeInterval:interval];
    
    return [format stringFromDate:date];
}

/** 通过字符串获取date */
+ (instancetype)gy_dateWithStr:(NSString *)dateStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [format dateFromString:dateStr];
    //避免时区误差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date dateByAddingTimeInterval:interval];
    
    return date;
}

/** 获取给定日期的当月有多少天 */
- (NSInteger)gy_dayLength
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    return days.length;
}

/** 获取给定日期是周几 (周日＝0) */
- (NSInteger)gy_weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return components.weekday - 1;
}

/** 获取给定日期的当月第一天的日期 */
- (instancetype)gy_firstDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    components.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:components];
    //得到本地时间，避免时区问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:firstDate];
    return [firstDate dateByAddingTimeInterval:interval];
}

/** 获取给定日期的本月日期数组 */
- (NSArray *)gy_datesOfMonth
{
    NSMutableArray *datesOfMonth = @[].mutableCopy;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    for (int i = 1; i <= self.gy_dayLength; i++) {
        components.day = i;
        NSDate *date = [calendar dateFromComponents:components];
        //得到本地时间，避免时区问题
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        [datesOfMonth addObject:[date dateByAddingTimeInterval:interval]];
    }
    
    return datesOfMonth.copy;
}

/**
 * 获取某个日期的
 * 上x年/下x年
 * 上x月/下x月
 * 上x天/下x天  的日期
 */
- (instancetype)gy_nextDateForchangeY:(NSInteger)year changeM:(NSInteger)month changeD:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    [newComponents setYear:year];
    [newComponents setMonth:month];
    [newComponents setDay:day];
    return [calendar dateByAddingComponents:newComponents toDate:self options:0];
}

/** 获取给定日期的本月42天的日期数组 */
- (NSArray *)gy_dates42OfMonth
{
    NSMutableArray *newDates = [self gy_datesOfMonth].mutableCopy;
    NSInteger count = newDates.count;
    for (int i = 0; i < 42 - count; i++) {
        NSDate *date = newDates.firstObject;
        if (date.gy_weekday != 0) {
            NSDate *newDate = [date gy_nextDateForchangeY:0 changeM:0 changeD:-1];
            [newDates insertObject:newDate atIndex:0];
        } else if (newDates.count != 42) {
            NSDate *date = newDates.lastObject;
            NSDate *newDate = [date gy_nextDateForchangeY:0 changeM:0 changeD:1];
            [newDates insertObject:newDate atIndex:newDates.count];
        }
    }
    return newDates.copy;
}

/** 获取指定日期的是几号 */
- (NSInteger)gy_day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

/** 获取指定日期的是几月 */
- (NSString *)gy_month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    NSString *month;
    switch ([components month]) {
        case 1:
            month = @"一月";
            break;
            
        case 2:
            month = @"二月";
            break;
            
        case 3:
            month = @"三月";
            break;
            
        case 4:
            month = @"四月";
            break;
            
        case 5:
            month = @"五月";
            break;
            
        case 6:
            month = @"六月";
            break;
            
        case 7:
            month = @"七月";
            break;
            
        case 8:
            month = @"八月";
            break;
            
        case 9:
            month = @"九月";
            break;
            
        case 10:
            month = @"十月";
            break;
            
        case 11:
            month = @"十一月";
            break;
            
        case 12:
            month = @"十二月";
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"   %@",month];
}

/** 获取指定日期的是几年 */
- (NSString *)gy_year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return [NSString stringWithFormat:@"%ld年",[components year]];
}

/** 判断两个日期是否是同一天 */
- (BOOL)gy_isEqualDay:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [[formatter stringFromDate:self] isEqualToString:[formatter stringFromDate:date]];
}


@end
