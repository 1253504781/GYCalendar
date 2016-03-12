//
//  GYDateCell.m
//  GYCalendar
//
//  Created by GY on 16/2/28.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYDateCell.h"

@interface GYDateCell()

@property (weak, nonatomic) UILabel *dateLabel;

@end

@implementation GYDateCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *dateLable = [[UILabel alloc] init];
        [self.contentView addSubview:dateLable];
        self.dateLabel = dateLable;
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    return self;
}

- (void)setDateModel:(GYDateModel *)dateModel
{
    _dateModel = dateModel;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld",dateModel.date.gy_day];
    if ([dateModel.date.gy_month isEqualToString:self.startDate.gy_month]) {
        self.dateLabel.textColor = [UIColor blackColor];
        if (dateModel.date.gy_weekday == 0 || dateModel.date.gy_weekday == 6) {
            self.dateLabel.textColor = [UIColor grayColor];
        }
    } else {
        self.dateLabel.textColor = [UIColor lightGrayColor];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.dateLabel.textColor = textColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dateLabel.frame = self.bounds;
}

@end
