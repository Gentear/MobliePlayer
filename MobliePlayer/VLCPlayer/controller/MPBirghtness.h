//
//  MPBirghtness.h
//  MobliePlayer
//
//  Created by zyyt on 17/4/10.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPBirghtness : UIView
/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** 是否允许横屏,来控制只有竖屏的状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;
@property (nonatomic, assign) BOOL     isStatusBarHidden;
/** 是否是横屏状态 */
@property (nonatomic, assign) BOOL     isLandscape;
/** 是否是音量 */
@property (assign,nonatomic) BOOL isVolume;

+ (instancetype)sharedBrightnessView;
@end
