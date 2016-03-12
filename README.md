# GYCalendar
* 一个轻量级日历小框架。
* 可随意插拔部分视图、任意修改日历展现样式。

### Tips:
* 1.该日历提供单月、多月两种样式可随意切换。
* 2.自定义样式时就像给tableView自定义cell一样简单。
* 3.日历面板的宽和高是由内部cell决定的，随着改变cell大小，日历面板的大小也会跟着改变。
* 4.有关日历的获取方法都抽取在NSDate+GYDateExtension分类里，应用该分类还可以轻松操作日期数据。

#GYCalendar的使用
* 方法一:通过cocoapods -> pod 'GYCalendar'
* 方法二:Download ZIP -> 把GYCalendar文件夹中的所有文件拽入项目中,主头文件为：#import "GYCalendar.h"


# Example
## 1.最简单的日历
![最简单的日历](https://raw.githubusercontent.com/ShinyG/GYCalendar/master/gif/EazyCalendar.gif)

```objc    
    // 初始化
    GYCalendarView *calendarView = [GYCalendarView calendarView];
    calendarView.frame = CGRectMake(HMargin, VMargin - 40, 0, 0);
    [self.view addSubview:calendarView];
```

## 2.多月样式的日历
![多月样式的日历](https://raw.githubusercontent.com/ShinyG/GYCalendar/master/gif/MultiCalendar.gif)

```objc
    GYCalendarView *calendarView = [GYCalendarView calendarView];
    // 设置为多月样式
    calendarView.calendarViewStyle = GYCalendarViewStyleMulMonth;
    calendarView.frame = CGRectMake(HMargin, 65, 0, 0);
    [self.view addSubview:calendarView];
```

## 3.自定义日历的头部样式
![自定义日历的头部样式](https://raw.githubusercontent.com/ShinyG/GYCalendar/master/gif/CustomHeaderCalendar.gif)

```objc
    // 初始化
    GYCalendarView *calendarView = [GYCalendarView calendarView];
    calendarView.frame = CGRectMake(HMargin, VMargin, 0, 0);
    [self.view addSubview:calendarView];
    self.calendarView = calendarView;
    // 自定义HeaderView
    [self setupCustomHeaderView];       
```


//自定义headerView

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


// 初始化左/右Label (UILabel *)setupLabel:(NSString *)labelText isLeft:(BOOL)isLeft

    UILabel *label = [[UILabel alloc] init];
    label.text = labelText;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blueColor];
    CGFloat x = isLeft ? 0 : (315 - 60);
    label.frame = CGRectMake(x, 0, 60, 40);
    label.userInteractionEnabled = YES;
    
    return label;

// 左侧label点击事件 (void)preTap:(UITapGestureRecognizer *)tap

    UILabel *headerView = [self.view viewWithTag:headerTag];
    headerView.text = [NSString stringWithFormat:@"%@",[[self.calendarView preMonth] gy_dateByFormat:@"yyyy-MM-dd"]];
}

// 右侧label点击事件 (void)nextTap:(UITapGestureRecognizer *)tap

    UILabel *headerView = [self.view viewWithTag:headerTag];
    headerView.text = [NSString stringWithFormat:@"%@",[[self.calendarView nextMonth] gy_dateByFormat:@"yyyy-MM-dd"]];
    

## 4.自定义日历Cell
![自定义日历Cell](https://raw.githubusercontent.com/ShinyG/GYCalendar/master/gif/CustomCellCalendar.gif)

	GYCalendarView *calendarView = [GYCalendarView calendarView];
    // 设置起始日期
    calendarView.fireDate = [NSDate dateWithTimeIntervalSinceNow:40 * 24 * 60 * 60];
    calendarView.frame = CGRectMake(HMargin, 65, 0, 0);
    // 称为代理
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
    
    
// 设置cell大小 (CGSize)calendarViewCellSize
   
    return CGSizeMake(45, 55);

// 返回自定义cell (GYDateCell *)calendarView:(GYCalendarView *)calenderView dateModel:(GYDateModel *)dateModel cellForItemAtIndexPath:(NSIndexPath *)indexPath

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

// 选中cell事件 (void)calendarView:(MyDateCell *)dateCell didSelectItemAtIndexPath:(NSIndexPath *)indexPath

    MyDateModel *myDateModel = dateCell.myDateModel;
    myDateModel.isSelected = !myDateModel.isSelected;
    dateCell.myDateModel = myDateModel;

// 切换样式 (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event

    if (self.calendarView.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        self.calendarView.calendarViewStyle = GYCalendarViewStyleMonth;
    } else {
        self.calendarView.calendarViewStyle = GYCalendarViewStyleMulMonth;
    }
