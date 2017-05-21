//
//  MPPlayerController.m
//  MobliePlayer
//
//  Created by zyyt on 17/5/20.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPPlayerController.h"
#import "MPPlayerManager.h"
#import "UIViewController+YYAdd.h"
#import "UITabBarController+ZFPlayerRotation.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
#import "MPPlayer.h"
@interface MPPlayerController ()
/** <#name#> */
@property (strong,nonatomic) MPPlayerManager *manager;

@end

@implementation MPPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}  //关闭自动偏移
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];
    [self add_navigation_back_button];
    
    [self setCustomNavigationTitle:[_videoPath componentsSeparatedByString:@"/"].lastObject];
    
    MPPlayerManager *manager = [MPPlayerManager sharedInstanceView:[UIApplication sharedApplication].keyWindow];
    manager.mediaURL = [NSURL fileURLWithPath:self.videoPath];
    [manager mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([UIApplication sharedApplication].keyWindow);
        make.height.equalTo(@(ScreenWidth/ScreenHeight * ScreenWidth));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    _manager = manager;
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.manager MediaStop];
    [self.manager setHidden:YES];
//    self.manager = nil;
}
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }UIStatusBarStyleLightContent
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
//- (BOOL)shouldAutorotate//是否支持旋转屏幕
//{
//    return YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations//支持哪些方向
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation//默认显示的方向
//{
//    return UIInterfaceOrientationPortrait;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
