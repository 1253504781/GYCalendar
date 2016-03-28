//
//  CustomCellDemo.m
//  GYCalendarExample
//
//  Created by GY on 16/3/6.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "CustomCellDemo.h"
#import "GYCalendarView.h"
#import "MyDateCell.h"

@interface CustomCellDemo () <GYCalendarViewDelegate>
@property (nonatomic , weak) GYCalendarView *calendarView;
@property (nonatomic , strong) NSMutableArray *tickets;
@end

@implementation CustomCellDemo


- (NSMutableArray *)tickets {
    if (!_tickets) {
        _tickets = [[NSMutableArray alloc] init];
    }
    
    return _tickets;
}

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GYCalendarView *calendarView = [GYCalendarView calendarView];
    // 设置起始日期
    calendarView.fireDate = [NSDate dateWithTimeIntervalSinceNow:40 * 24 * 60 * 60];
    calendarView.frame = CGRectMake(HMargin, 65, 0, 0);
    // 设置代理
    calendarView.delegate = self;
    // 注册cell
    [calendarView registerNib:[UINib nibWithNibName:NSStringFromClass([MyDateCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:calendarView];
    self.calendarView = calendarView;
    
    // 自定义日历Cell展现逻辑
    for (int i = 0; i < 10; i++) {
        MyDateModel *myDateModel = [[MyDateModel alloc] init];
        myDateModel.date = [NSDate dateWithTimeIntervalSinceNow:i * 24 * 60 * 60];
        [self.tickets addObject:myDateModel];
    }
}

#pragma mark - GYCalendarViewDelegate
// 设置cell大小
- (CGSize)calendarViewCellSize
{
    return CGSizeMake(45, 55);
}

// 返回自定义cell
- (GYDateCell *)calendarView:(GYCalendarView *)calenderView dateModel:(GYDateModel *)dateModel cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 取cell
    MyDateCell *dateCell = (MyDateCell *)[calenderView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    dateCell.dateModel = dateModel;
    
    for (MyDateModel *myDateModel in self.tickets) {
        if ([myDateModel.date gy_isEqualDay:dateModel.date]) {
            dateCell.myDateModel = myDateModel;
            return dateCell;
        }
    }
    return dateCell;
}

// 选中cell事件
- (void)calendarView:(MyDateCell *)dateCell didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyDateModel *myDateModel = dateCell.myDateModel;
    myDateModel.isSelected = !myDateModel.isSelected;
    dateCell.myDateModel = myDateModel;
}

// 切换样式
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.calendarView.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        self.calendarView.calendarViewStyle = GYCalendarViewStyleMonth;
    } else {
        self.calendarView.calendarViewStyle = GYCalendarViewStyleMulMonth;
    }
    
}

@end
