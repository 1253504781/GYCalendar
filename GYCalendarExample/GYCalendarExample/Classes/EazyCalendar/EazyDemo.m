//
//  EazyDemo.m
//  GYCalendarExample
//
//  Created by 高言 on 16/3/6.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "EazyDemo.h"
#import "GYCalendarView.h"

@interface EazyDemo ()

@end

@implementation EazyDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GYCalendarView *calendarView = [GYCalendarView calendarView];
    calendarView.frame = CGRectMake(HMargin, VMargin - 40, 0, 0);
    [self.view addSubview:calendarView];
    
}

@end
