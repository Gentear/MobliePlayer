//
// Created by zyyt on 2018/1/2.
// Copyright (c) 2018 gentear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIView;
@protocol ScreenRotationDeleagte <NSObject>
/**
 * 横屏旋转成竖屏
 */
- (void)rotatingIntoVerticalScreen;

/**
 * 竖屏旋转成横屏
 */
- (void)rotatingIntoLandscape;

/**
 * view上视图旋转
 */
- (void)itsRotation;
@end

@interface UIView (ScreenRotation)

@property (weak, nonatomic) id<ScreenRotationDeleagte>delegate;
/**
 * view自动旋转方法
 */
- (void)screenRotation;
/**
 * 手动旋转方法
 * @param interfaceOrientation
 */
- (void)transform:(UIInterfaceOrientation)interfaceOrientation;
/**
 * view上视图旋转中需要执行的方法
 * @return
 */
- (CGAffineTransform)getTransformRotationAngle;
@end