//
//  GYDateModel.m
//  GYCalendar
//
//  Created by GY on 16/2/28.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYDateModel.h"
#import "NSDate+GYDateExtension.h"

@implementation GYDateModel

- (instancetype)initWithDate:(NSDate *)date andMiddelDate:(NSDate *)middleDate
{
    if (self = [super init]) {
        self.date = date;
        switch (date.gy_weekday) {
            case 0:
            case 6:
            {
                if ([date.gy_month isEqualToString:[middleDate gy_month]]) {
                    self.cellDay = GYDateCellDayWeekDay;
                } else {
                    self.cellDay = GYDateCellDayOtherDay;
                }
                
                break;
            }
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                if ([date.gy_month isEqualToString:[middleDate gy_month]]) {
                    self.cellDay = GYDateCellDayWorkDay;
                } else {
                    self.cellDay = GYDateCellDayOtherDay;
                }
                
                break;
                
            default:
                break;
        }
        
    }
    
    return self;
}

+ (instancetype)dateModelWithDate:(NSDate *)date andMiddelDate:(NSDate *)middleDate
{
    GYDateModel *dateModel = [[self alloc] initWithDate:date andMiddelDate:middleDate];
    return dateModel;
}

@end
