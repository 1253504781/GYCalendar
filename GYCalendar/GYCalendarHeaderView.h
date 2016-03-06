//
//  GYCalendarHeaderView.h
//  GYCalendar
//
//  Created by 高言 on 16/3/1.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYCalendarHeaderView : UIView

/** 头部视图左侧的月份label */
@property (nonatomic , weak , readonly) UILabel *monthLabel;

/** 头部视图右侧的年份label */
@property (nonatomic , weak , readonly) UILabel *yearLabel;

+ (instancetype)calendarHeaderView:(NSDate *)startDate;

@end
