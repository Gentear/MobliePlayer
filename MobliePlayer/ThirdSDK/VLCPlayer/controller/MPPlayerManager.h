//
//  MPPlayerManager.h
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
@interface MPPlayerManager : UIView
/** 位置 */
@property (strong,nonatomic) NSURL *mediaURL;

+ (instancetype)sharedInstanceView:(UIView *)view ;

- (void)MediaStop;
@end
