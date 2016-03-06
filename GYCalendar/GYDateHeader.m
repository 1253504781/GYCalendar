//
//  GYDateHeader.m
//  GYCalendar
//
//  Created by 高言 on 16/3/1.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "GYDateHeader.h"
#import "NSDate+GYDateExtension.h"

@interface GYDateHeader()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;



@end

@implementation GYDateHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDateModel:(GYDateModel *)dateModel
{
    _dateModel = dateModel;
    
    self.monthLabel.text = dateModel.date.gy_month;
    self.yearLabel.text = dateModel.date.gy_year;
}

@end
