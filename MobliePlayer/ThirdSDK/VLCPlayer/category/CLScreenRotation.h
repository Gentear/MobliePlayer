//
// Created by zyyt on 2018/1/2.
// Copyright (c) 2018 gentear. All rights reserved.
//


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
#define AnimationTime 0.3
#define DelayInSeconds 3
#define angle2Rad(angle) ((angle) / 180.0 * M_PI)
#define HUDWidth 30
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define FastInSeconds 0.2
#define CLNotificationCenter [NSNotificationCenter defaultCenter]
#define CLApplication [UIApplication sharedApplication]
#define CLDevice [UIDevice currentDevice]

#import <Masonry/Masonry.h>