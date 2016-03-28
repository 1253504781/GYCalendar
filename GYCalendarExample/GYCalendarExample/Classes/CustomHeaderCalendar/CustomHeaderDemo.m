//
//  CustomHeaderDemo.m
//  GYCalendarExample
//
//  Created by GY on 16/3/6.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "CustomHeaderDemo.h"
#import "GYCalendarView.h"

@interface CustomHeaderDemo ()
@property (nonatomic , assign) GYCalendarView *calendarView;
@end

@implementation CustomHeaderDemo

static CGFloat const headerTag = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    GYCalendarView *calendarView = [GYCalendarView calendarView];
    calendarView.frame = CGRectMake(HMargin, VMargin, 0, 0);
    [calendarView hideHeaderView];
    [self.view addSubview:calendarView];
    self.calendarView = calendarView;
    
    // 自定义HeaderView
    [self setupCustomHeaderView];
}

// 自定义headerView
- (void)setupCustomHeaderView
{
    [self.calendarView hideHeaderView];
    [self.calendarView calendarScrollEnable:NO];
    
    UILabel *headerView = [[UILabel alloc] init];
    headerView.userInteractionEnabled = YES;
    headerView.tag = headerTag;
    headerView.backgroundColor = [UIColor redColor];
    headerView.frame = CGRectMake(HMargin, VMargin - 40, 315, 40);
    headerView.text = [NSString stringWithFormat:@"%@",[self.calendarView.fireDate gy_dateByFormat:@"yyyy-MM-dd"]];
    headerView.textColor = [UIColor whiteColor];
    headerView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:headerView];
    
    // 初始化左/右Label
    UILabel *preLabel = [self setupLabel:@"上个月" isLeft:YES];
    UILabel *nextLabel = [self setupLabel:@"下个月" isLeft:NO];
    
    // 点击事件
    UITapGestureRecognizer *preTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preTap:)];
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTap:)];
    [preLabel addGestureRecognizer:preTap];
    [nextLabel addGestureRecognizer:nextTap];
    
    [headerView addSubview:preLabel];
    [headerView addSubview:nextLabel];
}

// 初始化左/右Label
- (UILabel *)setupLabel:(NSString *)labelText isLeft:(BOOL)isLeft
{
    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blueColor];
    CGFloat x = isLeft ? 0 : (315 - 60);
    label.frame = CGRectMake(x, 0, 60, 40);
    label.userInteractionEnabled = YES;
    
    return label;
}

// 点击事件
- (void)preTap:(UITapGestureRecognizer *)tap
{
    UILabel *headerView = [self.view viewWithTag:headerTag];
    headerView.text = [NSString stringWithFormat:@"%@",[[self.calendarView preMonth] gy_dateByFormat:@"yyyy-MM-dd"]];
}

- (void)nextTap:(UITapGestureRecognizer *)tap
{
    UILabel *headerView = [self.view viewWithTag:headerTag];
    headerView.text = [NSString stringWithFormat:@"%@",[[self.calendarView nextMonth] gy_dateByFormat:@"yyyy-MM-dd"]];
}


@end
