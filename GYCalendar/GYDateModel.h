//
//  GYDateModel.h
//  GYCalendar
//
//  Created by 高言 on 16/2/28.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    GYDateCellDayWorkDay, // 工作日
    GYDateCellDayWeekDay, // 周末
    GYDateCellDayOtherDay, // 非本月日期
} GYDateCellDay;

@interface GYDateModel : NSObject

/** 日期 */
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , assign) GYDateCellDay cellDay;

- (instancetype)initWithDate:(NSDate *)date andMiddelDate:(NSDate *)middleDate;
+ (instancetype)dateModelWithDate:(NSDate *)date andMiddelDate:(NSDate *)middleDate;


@end
