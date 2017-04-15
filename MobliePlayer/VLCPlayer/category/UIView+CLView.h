//
//  UIView+CLView.h
//  myCategary
//
//  Created by zyyt on 16/9/5.
//  Copyright © 2016年 丛蕾. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CLGestureActionBlock)(UIGestureRecognizer * _Nullable gestureRecoginzer);

@interface UIView (CLView)

@property (assign,nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (assign,nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (assign,nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (assign,nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (assign,nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (assign,nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (assign,nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (assign,nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (assign,nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (assign,nonatomic) CGSize  size;        ///< Shortcut for frame.size.
/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;
/**
 *  移除所有view
 */
- (void)CL_removeAllSubviews;
/**
 *  得到圆形搜索框
 *
 *  @param myColor <#myColor description#>
 */
- (void)CL_getSearchImage:(UIColor *__nonnull)newColor;
/**
 *  增加毛玻璃
 *
 *  @param frame 大小
 *  @param alpha 透明度
 */
- (void)CL_addGlasses:(CGRect)frame alpha:(CGFloat)alpha;
/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)cl_addTapActionWithBlock:(CLGestureActionBlock _Nullable)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)cl_addLongPressActionWithBlock:(CLGestureActionBlock _Nullable)block;
/**
 *  @brief  截图指定view成图片
 *
 *  @param view 一个view
 *
 *  @return 图片
 */
- (UIImage *__nonnull)cl_captureWithView;
/**
 *  @brief  找到当前view所在的viewcontroler
 */
- (UIViewController *__nonnull)cl_viewController;
/**
 *  @brief  找到指定类名的view对象
 *
 *  @param clazz view类名
 *
 *  @return view对象
 */
- (id __nonnull)cl_findSubViewWithSubViewClass:(Class __nonnull)clazz;
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id __nonnull)cl_findSuperViewWithSuperViewClass:(Class __nonnull)clazz;
@end
