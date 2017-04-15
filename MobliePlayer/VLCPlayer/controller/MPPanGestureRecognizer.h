//
//  MPPanGestureRecognizer.h
//  MobliePlayer
//
//  Created by zyyt on 17/4/15.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import <UIKit/UIKit.h>
// 枚举值，手势开始
typedef NS_ENUM(NSInteger, PanMoved){
    PanBeganMoved, // 开始移动
    PanChangeMoved, // 正在移动
    PanEndMoved  // 完成移动
};


@protocol MPPanGestureRecognizerDelegates <NSObject>
/** 进度 */
- (void)panHorizontalMoved:(PanMoved)moved position:(CGFloat)position;
/** 声音 亮度*/
- (void)panVerticalMovedVolum:(PanMoved)moved position:(CGFloat)position isVolume:(BOOL)isVolume;
@end


// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

@interface MPPanGestureRecognizer : UIPanGestureRecognizer
/** 手势方向 */
@property (nonatomic, assign) PanDirection panDirection;

@property (weak, nonatomic) id<MPPanGestureRecognizerDelegates>delegates;

+ (instancetype)panGestureRecognizer;

@end
