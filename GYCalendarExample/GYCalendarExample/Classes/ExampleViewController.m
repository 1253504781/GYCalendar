//
//  ExampleViewController.m
//  GYCalendarExample
//
//  Created by 高言 on 16/3/6.
//  Copyright © 2016年 高言. All rights reserved.
//

#import "ExampleViewController.h"
#import "EazyDemo.h"
#import "MultiMonthDemo.h"
#import "CustomHeaderDemo.h"
#import "CustomCellDemo.h"


@interface ExampleViewController ()
@property (nonatomic , strong) NSMutableArray *demos;
@end

@implementation ExampleViewController

- (NSMutableArray *)demos {
    if (!_demos) {
        _demos = [NSMutableArray array];
        [_demos addObject:@{@"className":@"EazyDemo",@"title":@"简易日历"}];
        [_demos addObject:@{@"className":@"MultiMonthDemo",@"title":@"多月样式日历"}];
        [_demos addObject:@{@"className":@"CustomHeaderDemo",@"title":@"自定义Header日历"}];
        [_demos addObject:@{@"className":@"CustomCellDemo",@"title":@"自定义Cell日历"}];
    }
    
    return _demos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Demo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSDictionary *dic = self.demos[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.demos[indexPath.row];
    UIViewController *vc = [[NSClassFromString(dic[@"className"]) alloc] init];
    vc.title = dic[@"title"];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
