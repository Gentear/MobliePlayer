//
//  MPPanGestureRecognizer.h
//  MobliePlayer
//
//  Created by zyyt on 17/4/15.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import <UIKit/UIKit.h>

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};
@interface MPPanGestureRecognizer : UIPanGestureRecognizer
/** 手势方向 */
@property (nonatomic, assign) PanDirection panDirection;
@end
