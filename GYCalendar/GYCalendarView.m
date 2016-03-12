//
//  GYCalendarView.m
//  GYCalendar
//
//  Created by GY on 16/2/28.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYCalendarView.h"
#import "GYDateHeader.h"
#import "GYWeekView.h"
#import "GYCalendarHeaderView.h"

// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 随机色
#define RandomColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define MAXGroup 12

@interface GYCalendarView()<UICollectionViewDataSource,UICollectionViewDelegate>
/** 数据源 */
@property (nonatomic , strong) NSMutableArray *group;
/** collectionView的流水布局 */
@property (nonatomic , weak) UICollectionViewFlowLayout *flowLayout;
/** 日期面板 */
@property (nonatomic , weak) UICollectionView *collectionView;
/** 头部视图 */
@property (nonatomic , weak) GYCalendarHeaderView *headerView;
/** 星期视图 */
@property (nonatomic , weak) GYWeekView *weekView;
/** 起始日期，随滚动而改变 */
@property (nonatomic , strong) NSDate *startDate;
/** 最大显示的年份数量 */
@property (nonatomic , assign) NSInteger maxYearCount;
/** 原始frame */
@property (nonatomic , assign) CGRect orgFrame;
/** 是否在切换日历样式中 */
@property (nonatomic , assign) BOOL isChanging;
/** 是否正在加载更多年的数据 */
@property (nonatomic , assign) BOOL isLoadingMore;
@end

@implementation GYCalendarView

static NSString * const ID = @"DateCell";
static NSString * const headerID = @"DateHeader";

+ (instancetype)calendarView {
    GYCalendarView *calendarView = [[GYCalendarView alloc] init];
    return calendarView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews
{
    // 初始化数据
    [self setupData];
    // 创建一个scrollView 防止系统在有导航的情况下让collectionView自动改变inset
    [self setupScapegoat];
    // 初始化collectionView
    [self setupCollectionView];
    // 初始化“星期”标签
    [self setupWeekView];
    // 初始化头部视图
    [self setupHeaderView];
}

// 初始化数据
- (void)setupData
{
    // 默认样式
    self.calendarViewStyle = GYCalendarViewStyleMonth;
    self.isChanging = NO;
    // 默认显示10年数据
    self.maxYearCount = 10;
    // 默认开始时间为今天
    self.startDate = [NSDate date];
    self.fireDate = self.startDate;
    // 获取日期数据
    [self getDates:0];
}

// 初始化scrollView，替代日历视图改变inset
- (void)setupScapegoat
{
    UIScrollView *noneScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    noneScrollView.alpha = 0.001;
    noneScrollView.userInteractionEnabled = NO;
    [self addSubview:noneScrollView];
}

// 初始化collectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 默认cell大小
    CGFloat wh = 40;
    // collectionView大小为正好填充cell
    CGRect rect;
    BOOL pageEnable;
    NSInteger scrollToSection;
    // 默认样式
    if (self.calendarViewStyle == GYCalendarViewStyleMonth) {
        rect = CGRectMake(0, 0, wh * 7, wh * 6);
        pageEnable = YES;
        scrollToSection = MAXGroup/2;
    } else if (self.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        rect = CGRectMake(0, 0, wh * 7, wh * 6 * 2);
        pageEnable = NO;
        scrollToSection = MAXGroup * self.maxYearCount/2;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        flowLayout.headerReferenceSize = CGSizeMake(rect.size.width, 20);
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    self.flowLayout = flowLayout;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // 注册基础展示日期cell
    [collectionView registerClass:[GYDateCell class] forCellWithReuseIdentifier:ID];
//    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYDateCell class]) bundle:[NSBundle bundleForClass:[GYDateCell class]]] forCellWithReuseIdentifier:ID];
    [collectionView registerClass:[GYDateHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
//    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYDateHeader class]) bundle:[NSBundle bundleForClass:[GYDateHeader class]]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = pageEnable;
    collectionView.showsVerticalScrollIndicator = NO;
    
    flowLayout.itemSize = CGSizeMake(wh, wh);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 初始滚动到中间组的位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:scrollToSection];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}

// 初始化“星期”标签
- (void)setupWeekView
{
    GYWeekView *weekView = [GYWeekView weekView];
    [self addSubview:weekView];
    self.weekView = weekView;
}

// 初始化头部视图
- (void)setupHeaderView
{
    // 头部视图
    GYCalendarHeaderView *headerView = [GYCalendarHeaderView calendarHeaderView:self.startDate];
    [self addSubview:headerView];
    _headerView = headerView;
}

// 隐藏头部视图
- (void)hideHeaderView
{
    self.headerView = nil;
}

// 禁止日历滚动
- (void)calendarScrollEnable:(BOOL)enabel
{
    self.collectionView.scrollEnabled = enabel;
}

/** 跳到/获取上个月 */
- (NSDate *)preMonth {
    CGPoint currentPoint = self.collectionView.contentOffset;
    currentPoint.y -= self.collectionView.bounds.size.height;
    CGPoint proPoint = currentPoint;
    [self.collectionView setContentOffset:proPoint animated:YES];
    return [self.startDate gy_nextDateForchangeY:0 changeM:-1 changeD:0];
}

/** 跳到/获取下个月 */
- (NSDate *)nextMonth; {
    CGPoint currentPoint = self.collectionView.contentOffset;
    currentPoint.y += self.collectionView.bounds.size.height;
    CGPoint proPoint = currentPoint;
    [self.collectionView setContentOffset:proPoint animated:YES];
    
    return [self.startDate gy_nextDateForchangeY:0 changeM:1 changeD:0];
}

// 改变样式
- (void)setCalendarViewStyle:(GYCalendarViewStyle)calendarViewStyle
{
    _calendarViewStyle = calendarViewStyle;
    if (_calendarViewStyle == GYCalendarViewStyleMulMonth) {
        self.collectionView.scrollEnabled = YES;
    }
    self.isChanging = YES;
    
    [self reset];
    [self reload];
}

// 重置数据
- (void)reset
{
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.monthLabel.transform = CGAffineTransformIdentity;
        self.headerView.yearLabel.transform = CGAffineTransformIdentity;
    }];
    [self getDates:0];
}

- (void)reload
{
    [self setNeedsLayout];
}

// 懒加载数组
- (NSMutableArray *)group {
    if (!_group) {
        _group = [[NSMutableArray alloc] init];
    }
    
    return _group;
}

- (void)setFireDate:(NSDate *)fireDate
{
    _fireDate = fireDate;
    self.startDate = fireDate;
    [self getDates:0];
}

// 获取当前日期上个月、当前月和下个月的数据，每次滚动重新获取当前日期的3个月数据
- (NSArray *)getDates:(NSInteger)direction
{
    // 获取当前月的日期
    NSDate *date = [self.startDate gy_nextDateForchangeY:0 changeM:direction changeD:0];
    // 更新当前日期
    self.startDate = date;
    // 重置月份
    self.headerView.monthLabel.text = self.startDate.gy_month;
    // 重置年份
    self.headerView.yearLabel.text = self.startDate.gy_year;
    // 移除上次的数据
    [self.group removeAllObjects];
    
    if (self.calendarViewStyle == GYCalendarViewStyleMonth) {
        // 单月数据
        [self setupMonthDates:date];
    } else if (self.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        // 多月数据
        [self.group addObjectsFromArray:[self setupMutMonthDates:date]];
    }
    
    [self.collectionView reloadData];
    return self.group;
}

// 获取单月数据
- (void)setupMonthDates:(NSDate *)date
{
    // 上个月
    NSArray *preDates = [date gy_nextDateForchangeY:0 changeM:-1 changeD:0].gy_dates42OfMonth;
    NSMutableArray *tempPreDates = [NSMutableArray array];
    for (NSDate *date in preDates) {
        GYDateModel *dateModel = [GYDateModel dateModelWithDate:date andMiddelDate:preDates[preDates.count/2]];
        [tempPreDates addObject:dateModel];
    }
    [self.group addObject:tempPreDates];
    
    // 当前月
    NSArray *currentDates = date.gy_dates42OfMonth;
    NSMutableArray *tempCurrentDates = [NSMutableArray array];
    for (NSDate *date in currentDates) {
        GYDateModel *dateModel = [GYDateModel dateModelWithDate:date andMiddelDate:currentDates[currentDates.count/2]];
        [tempCurrentDates addObject:dateModel];
    }
    [self.group addObject:tempCurrentDates];
    
    // 下个月
    NSArray *nextDates = [date gy_nextDateForchangeY:0 changeM:1 changeD:0].gy_dates42OfMonth;
    NSMutableArray *tempNextDates = [NSMutableArray array];
    for (NSDate *date in nextDates) {
        GYDateModel *dateModel = [GYDateModel dateModelWithDate:date andMiddelDate:nextDates[nextDates.count/2]];
        [tempNextDates addObject:dateModel];
    }
    [self.group addObject:tempNextDates];
}

// 获取多月数据
- (NSArray *)setupMutMonthDates:(NSDate *)date
{
    NSMutableArray *group = @[].mutableCopy;
    for (int i = -self.maxYearCount * 0.5 ; i < self.maxYearCount * 0.5; i++) {
        // 每年
        for (int j = 0; j < MAXGroup; j++) {
            // 每个月
            NSArray *currentDates = [date gy_nextDateForchangeY:i changeM:j changeD:0].gy_dates42OfMonth;
            NSMutableArray *tempCurrentDates = [NSMutableArray array];
            for (NSDate *date in currentDates) {
                GYDateModel *dateModel = [GYDateModel dateModelWithDate:date andMiddelDate:currentDates[currentDates.count/2]];
                [tempCurrentDates addObject:dateModel];
            }
            [group addObject:tempCurrentDates];
        }
    }
    
    return group;
}

#pragma mark - collectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count;
    if (self.calendarViewStyle == GYCalendarViewStyleMonth) {
        count =  MAXGroup;
    } else if (self.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        count =  MAXGroup * self.maxYearCount;
    }
    
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYDateModel *dateModel;
    NSDate *startDate;
    if (self.calendarViewStyle == GYCalendarViewStyleMonth) {
        // index的取值范围为0，1，2. 只做滚动时能够展示下上个月和下个月的cell 反正最终都会滚动到最中央
        NSInteger index = indexPath.section/((int)MAXGroup/2) + indexPath.section%((int)MAXGroup/2);
        if (indexPath.section< (MAXGroup*0.5)) {
            index = 0;
        } else if (index >= 3) {
            index = 2;
        }
        NSArray *dates = self.group[index];
        dateModel = dates[indexPath.row];
        startDate = self.startDate;
    } else if (self.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        NSArray *dates = self.group[indexPath.section];
        dateModel = dates[indexPath.row];
        startDate = [dates[dates.count/2] date];
    }

    GYDateCell *cell;
    if ([self.delegate respondsToSelector:@selector(calendarView:dateModel:cellForItemAtIndexPath:)]) {
        return [self.delegate calendarView:self dateModel:dateModel cellForItemAtIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.startDate = startDate;
        cell.dateModel = dateModel;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GYDateHeader *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
    NSArray *dates = self.group[indexPath.section];
    GYDateModel *dateModel = dates[dates.count/2];
    reusableView.dateModel = dateModel;
    
    return reusableView;
}

#pragma mark - collectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectItemAtIndexPath:)]) {
        GYDateCell *cell = (GYDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate calendarView:cell didSelectItemAtIndexPath:indexPath];
        [self.collectionView reloadData];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}


// 结束滚动时重置为当前月/上/下三个月的数据
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.calendarViewStyle == GYCalendarViewStyleMonth) {
        // 计算以中间的组为基准，滚动了几个月
        NSInteger direction = (NSInteger)(scrollView.contentOffset.y / scrollView.bounds.size.height - MAXGroup/2);
        if (self.isChanging && ABS(direction) != 1) {
            // 切换状态时置换数据
            direction = 0;
            self.isChanging = NO;
        }
        // 重置数据
        [self getDates:direction];
        // 滚回中间
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:MAXGroup/2];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(0, scrollView.contentOffset.y)];
        NSInteger currentSection = indexPath.section;
        if (!indexPath) {
            return;
        }
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        // 获取"本月"里的任意天日期
        GYDateModel *dateModel = self.group[currentSection][15];
        if ((currentSection != 0 && contentOffsetY > 0) || (currentSection == 0 && contentOffsetY < self.collectionView.bounds.size.height)) {
            // 月份label更新日期和动画
            BOOL isEarly = [self.startDate compare:dateModel.date] == NSOrderedAscending;
            CGFloat scale;
            if (!isEarly) {
                scale = 0.8;
            } else {
                scale = 1.2;
            }
            if (![self.headerView.monthLabel.text isEqualToString:dateModel.date.gy_month]) {
                self.headerView.monthLabel.text = dateModel.date.gy_month;
                self.headerView.monthLabel.transform = CGAffineTransformMakeScale(scale, scale);
                [UIView animateWithDuration:0.7 animations:^{
                    self.headerView.monthLabel.transform = CGAffineTransformIdentity;
                }];
            }
            // 年份label更新日期和动画
            if (![self.headerView.yearLabel.text isEqualToString:dateModel.date.gy_year]) {
                self.headerView.yearLabel.text = dateModel.date.gy_year;
                self.headerView.yearLabel.transform = CGAffineTransformMakeScale(scale, scale);
                [UIView animateWithDuration:0.7 animations:^{
                    self.headerView.yearLabel.transform = CGAffineTransformIdentity;
                }];
            }

            // 重置起始日期
            self.startDate = dateModel.date;
        }
        

        // 获取当前可滚动总共偏移量
        CGFloat totalContentOffSetY = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
        // 以当前的日期为中间点置换成新的日期数据
        if (contentOffsetY <= 0.25 * totalContentOffSetY && !self.isLoadingMore){
            [self setCalendarViewStyle:GYCalendarViewStyleMulMonth];
            self.isLoadingMore = YES;
        } else if (contentOffsetY >= 0.75 * totalContentOffSetY && !self.isLoadingMore) {
            [self setCalendarViewStyle:GYCalendarViewStyleMulMonth];
            self.isLoadingMore = YES;
        } else {
            self.isLoadingMore = NO;
        }
    }
}

// 注册class
- (void)registerClass:(Class)cls forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
}

// 注册nib
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

// 取循环利用cell
- (GYDateCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return (GYDateCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

// 屏蔽外部设置size
- (void)setFrame:(CGRect)frame
{
    self.orgFrame = frame;
    [super setFrame:frame];
}

// 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = CGSizeMake(45, 45);
    if ([self.delegate respondsToSelector:@selector(calendarViewCellSize)]) {
        size = [self.delegate calendarViewCellSize];
    }
    self.flowLayout.itemSize = size;
    
    CGRect rect;
    BOOL pageEnable;
    NSInteger scrollToSection = 0;
    if (self.calendarViewStyle == GYCalendarViewStyleMonth) {
        rect = CGRectMake(0, 0, size.width * 7, size.height * 6);
        pageEnable = YES;
        scrollToSection = MAXGroup/2;
        self.flowLayout.sectionInset = UIEdgeInsetsZero;
        self.flowLayout.headerReferenceSize = CGSizeZero;
    } else if (self.calendarViewStyle == GYCalendarViewStyleMulMonth) {
        CGFloat h = size.height * 6 * 2;
        if (h >= [UIScreen mainScreen].bounds.size.height) {
            h = [UIScreen mainScreen].bounds.size.height -CGRectGetMaxY(self.weekView.frame) - 2 * self.orgFrame.origin.y;
        }
        rect = CGRectMake(0, 0, size.width * 7, h);
        pageEnable = NO;
        scrollToSection = MAXGroup * self.maxYearCount/2;
        self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        self.flowLayout.headerReferenceSize = CGSizeMake(rect.size.width, 20);
    }
    
    self.collectionView.pagingEnabled = pageEnable;
    
    self.headerView.frame = CGRectMake(0, 0, rect.size.width, WEEKHEADERH);

    self.weekView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), rect.size.width, WEEKHEADERH);
    CGFloat w = self.weekView.bounds.size.width / 7;
    CGFloat h = self.weekView.bounds.size.height;
    // 外部大小改变，子视图随之重新计算
    for (int i = 0; i < self.weekView.subviews.count; i++) {
        UILabel *titleLabel = self.weekView.subviews[i];
        titleLabel.frame = CGRectMake(i * w, 0, w, h);
    }
    
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.weekView.frame), rect.size.width, rect.size.height);
    self.frame = CGRectMake(self.orgFrame.origin.x, self.orgFrame.origin.y, rect.size.width, CGRectGetMaxY(self.collectionView.frame));
    
    
    
    // 每次调整样式后滚动到中间
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:scrollToSection];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    
    // 动画
    CATransition *anim = [CATransition animation];
    anim.type = @"fade";
    anim.subtype = @"fromTop";
    anim.duration = 0.25;
    [self.layer addAnimation:anim forKey:nil];
}


@end
