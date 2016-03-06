//
//  GYCalendarView.h
//  GYCalendar
//
//  Created by 高言 on 16/2/28.
//  Copyright © 2016年 高言. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+GYDateExtension.h"
#import "GYDateCell.h"
#import "GYDateModel.h"

typedef enum : NSUInteger {
    GYCalendarViewStyleMulMonth, // 显示多月
    GYCalendarViewStyleMonth // 显示一个月
} GYCalendarViewStyle;

@class GYDateCell;
@class GYCalendarView;

@protocol GYCalendarViewDelegate <NSObject>

@optional
/** 设置cell的大小 */
- (CGSize)calendarViewCellSize;
/** 返回cell */
- (GYDateCell *)calendarView:(GYCalendarView *)calenderView dateModel:(GYDateModel *)dateModel cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/** 选了哪个cell */
- (void)calendarView:(GYDateCell *)dateCell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GYCalendarView : UIView

/** 初始化方法 */
+ (instancetype)calendarView;

/** 刷新UI */
- (void)reload;

/** 起始日期 */
@property (nonatomic , strong) NSDate *fireDate;

/** 禁止日历滚动 */
- (void)calendarScrollEnable:(BOOL)enabel;

/** 隐藏头部视图 */
- (void)hideHeaderView;

/** 跳到/获取上个月 */
- (NSDate *)preMonth;

/** 跳到/获取下个月 */
- (NSDate *)nextMonth;

/** 注册cell */
- (void)registerClass:(Class)cls forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (GYDateCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/** 日历样式 赋值即切换 */
@property (nonatomic,assign) GYCalendarViewStyle calendarViewStyle;

@property (nonatomic,weak) id<GYCalendarViewDelegate> delegate;

@end
