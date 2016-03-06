//
//  GYWeekView.m
//  GYCalendar
//
//  Created by GY on 16/3/1.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYWeekView.h"

@implementation GYWeekView

+ (instancetype)weekView
{
    GYWeekView *weekView = [[GYWeekView alloc] init];
    [weekView setupWeekLabels];
    
    return weekView;
}

- (void)setupWeekLabels
{
    
    for (int i = 0; i < 7; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        NSString *title;
        switch (i) {
            case 0:
                title = @"日";
                break;
                
            case 1:
                title = @"一";
                break;
                
            case 2:
                title = @"二";
                break;
                
            case 3:
                title = @"三";
                break;
                
            case 4:
                title = @"四";
                break;
                
            case 5:
                title = @"五";
                break;
                
            case 6:
                title = @"六";
                break;
                
            default:
                break;
        }
        titleLabel.text = title;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
}

- (void)layoutSubviews
{
    CGFloat w = self.bounds.size.width / 7;
    CGFloat h = self.bounds.size.height;
    for (int i = 0; i < self.subviews.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.frame = CGRectMake(i * w, 0, w, h);
    }
}

@end
