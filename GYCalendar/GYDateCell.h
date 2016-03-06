//
//  GYDateCell.h
//  GYCalendar
//
//  Created by 高言 on 16/2/28.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYDateModel.h"
#import "NSDate+GYDateExtension.h"

@interface GYDateCell : UICollectionViewCell
@property (nonatomic , strong) GYDateModel *dateModel;
@property (nonatomic , strong) NSDate *startDate;
@property (nonatomic , strong) UIColor *textColor;
@end
