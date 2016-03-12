//
//  GYDateHeader.m
//  GYCalendar
//
//  Created by GY on 16/3/1.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYDateHeader.h"
#import "NSDate+GYDateExtension.h"

@interface GYDateHeader()
@property (weak, nonatomic) UILabel *monthLabel;
@property (weak, nonatomic) UILabel *yearLabel;



@end

@implementation GYDateHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *monthLabel = [[UILabel alloc] init];
        monthLabel.font = [UIFont systemFontOfSize:17];
        monthLabel.textColor = [UIColor redColor];
        monthLabel.textAlignment = NSTextAlignmentLeft;
        self.monthLabel = monthLabel;
        
        UILabel *yearLabel = [[UILabel alloc] init];
        yearLabel.font = [UIFont systemFontOfSize:17];
        yearLabel.textColor = [UIColor redColor];
        yearLabel.textAlignment = NSTextAlignmentRight;
        self.yearLabel = yearLabel;
        
        [self addSubview:monthLabel];
        [self addSubview:yearLabel];
    }
    
    return self;
}

- (void)setDateModel:(GYDateModel *)dateModel
{
    _dateModel = dateModel;
    
    self.monthLabel.text = dateModel.date.gy_month;
    self.yearLabel.text = dateModel.date.gy_year;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.monthLabel.frame = CGRectMake(5, 0, 200, self.bounds.size.height);
    self.yearLabel.frame = CGRectMake(self.bounds.size.width - 200 - 5, 0, 200, self.bounds.size.height);
}

@end
