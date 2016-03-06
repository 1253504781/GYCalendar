//
//  GYCalendarHeaderView.m
//  GYCalendar
//
//  Created by GY on 16/3/1.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYCalendarHeaderView.h"
#import "NSDate+GYDateExtension.h"

@interface GYCalendarHeaderView()
@property (nonatomic , strong) NSDate *startDate;
@end

@implementation GYCalendarHeaderView

+ (instancetype)calendarHeaderView:(NSDate *)startDate
{
    GYCalendarHeaderView *headerView = [[GYCalendarHeaderView alloc] init];
    headerView.startDate = startDate;
    [headerView setupMonthLabel];
    [headerView setupYearLabel];
    return headerView;
}

- (void)setupMonthLabel

{    // 月份label
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.textColor = [UIColor redColor];
    monthLabel.text = self.startDate.gy_month;
    monthLabel.font = [UIFont systemFontOfSize:22];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.layer.anchorPoint = CGPointMake(0, 0.5);
    [self addSubview:monthLabel];
    _monthLabel = monthLabel;
}

- (void)setupYearLabel
{
    // 年份label
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.textColor = [UIColor redColor];
    yearLabel.text = self.startDate.gy_year;
    yearLabel.textAlignment = NSTextAlignmentRight;
    yearLabel.font = [UIFont systemFontOfSize:22];
    yearLabel.layer.anchorPoint = CGPointMake(1, 0.5);
    [self addSubview:yearLabel];
    _yearLabel = yearLabel;
}

- (void)layoutSubviews
{
    self.monthLabel.frame = CGRectMake(5, 0, self.bounds.size.width * 0.5, self.bounds.size.height);
    self.yearLabel.frame = CGRectMake(self.bounds.size.width - 90, 0, 80, self.bounds.size.height);
}

@end
