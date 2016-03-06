//
//  GYDateCell.m
//  GYCalendar
//
//  Created by GY on 16/2/28.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYDateCell.h"

@interface GYDateCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GYDateCell

- (void)awakeFromNib
{
    self.dateLabel.font = [UIFont boldSystemFontOfSize:14];
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

@end
