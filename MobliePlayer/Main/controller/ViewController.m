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
#import "MPFloderViewController.h"
#import "MPHTTPViewController.h"
@interface ViewController ()
/** <#name#> */
@property (strong,nonatomic) MPPlayerManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}  //关闭自动偏移

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(0, 64, 100, 100);
    [btn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn2.frame = CGRectMake(100, 64, 100, 100);
    [btn2 addTarget:self action:@selector(addButtonClick2:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn2];
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn3.frame = CGRectMake(200, 64, 100, 100);
    [btn3 addTarget:self action:@selector(addButtonClick3:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn3];
}
- (void)addButtonClick3:(UIButton *)sender{
    MPHTTPViewController * vc = [[MPHTTPViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addButtonClick2:(UIButton *)sender{
    MPFloderViewController * vc = [[MPFloderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
