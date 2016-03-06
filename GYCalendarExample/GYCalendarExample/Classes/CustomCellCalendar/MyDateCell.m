//
//  MyDateCell.m
//  GYCalendar
//
//  Created by 高言 on 16/3/1.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "MyDateCell.h"

@interface MyDateCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MyDateCell

- (void)setDateModel:(GYDateModel *)dateModel
{
    [super setDateModel:dateModel];
    
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"";
    self.dateLabel.text = [NSString stringWithFormat:@"%ld",dateModel.date.gy_day];
    
    if (dateModel.cellDay == GYDateCellDayWorkDay) {
        self.dateLabel.textColor = [UIColor blackColor];
    } else if (dateModel.cellDay == GYDateCellDayWeekDay) {
        self.dateLabel.textColor = [UIColor grayColor];
    } else {
        self.dateLabel.textColor = [UIColor lightGrayColor];
    }
    
    if ([dateModel.date gy_isEqualDay:[NSDate date]]) {
        self.dateLabel.text = @"今天";
        self.dateLabel.textColor = [UIColor blueColor];
    }
}

- (void)setMyDateModel:(MyDateModel *)myDateModel
{
    _myDateModel = myDateModel;
    
    if ([self.dateModel.date gy_isEqualDay:myDateModel.date]) {
        self.titleLabel.text = @"有票";
        self.userInteractionEnabled = YES;
    } else {
        self.titleLabel.text = @"";
        self.userInteractionEnabled = NO;
    }
    
    if (myDateModel.isSelected) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}


@end
