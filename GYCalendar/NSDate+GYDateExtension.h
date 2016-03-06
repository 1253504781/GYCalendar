//
//  NSDate+GYDateExtension.h
//  GYCalendar
//
//  Created by GY on 16/2/27.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GYDateExtension)

/** 将date转为"format"格式的字符串 */
- (NSString *)gy_dateByFormat:(NSString *)format;

/** 通过字符串获取date */
+ (instancetype)gy_dateWithStr:(NSString *)dateStr;

/** 获取给定日期的当月有多少天 */
- (NSInteger)gy_dayLength;

/** 获取给定日期是周几 (周日＝0) */
- (NSInteger)gy_weekday;

/** 获取给定日期的当月第一天的日期 */
- (instancetype)gy_firstDate;

/** 获取给定日期的本月日期数组 */
- (NSArray *)gy_datesOfMonth;

/**
 * 获取某个日期的
 * 上x年/下x年
 * 上x月/下x月
 * 上x天/下x天  的日期
 */
- (instancetype)gy_nextDateForchangeY:(NSInteger)year changeM:(NSInteger)month changeD:(NSInteger)day;

/** 获取给定日期的本月42天的日期数组 */
- (NSArray *)gy_dates42OfMonth;

/** 获取指定日期的是几号 */
- (NSInteger)gy_day;

/** 获取指定日期的是几月 */
- (NSString *)gy_month;

/** 获取指定日期的是几年 */
- (NSString *)gy_year;

/** 判断两个日期是否是同一天 */
- (BOOL)gy_isEqualDay:(NSDate *)date;

@end
