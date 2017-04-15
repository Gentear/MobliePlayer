//
//  ViewController.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "ViewController.h"
#import "MPPlayerManager.h"
#import "UITabBarController+ZFPlayerRotation.h"
#import "UIViewController+ZFPlayerRotation.h"
#import "UINavigationController+ZFPlayerRotation.h"
@interface ViewController ()
/** <#name#> */
@property (strong,nonatomic) MPPlayerManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(0, 0, 100, 100);
    [btn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}
- (void)addButtonClick:(UIButton *)sender{
    
    MPPlayerManager *manager = [MPPlayerManager sharedInstanceView:self.view];
    //        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp4"];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"456" ofType:@"flv"];
    manager.mediaURL = [NSURL fileURLWithPath:imagePath];
//        manager.mediaURL = [NSURL  URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
//    manager.mediaURL = [NSURL  URLWithString:@"http://gslb.miaopai.com/stream/mHtThGn2H1rQ54LY~uk5hw__.mp4?yx=&refer=weibo_app&Expires=1491533552&ssig=c%2FjqaqlRfd&KID=unistore,video"];
    
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
