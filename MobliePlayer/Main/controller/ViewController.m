//
//  ViewController.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "ViewController.h"
#import "MPPlayerManager.h"
#import "UINavigationController+ScreenRotation.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds
#define BarHeight 20
#define NVHeight 44
#define TBHeight 44

#define BackgroundColor [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1]

@interface ViewController ()
/** <#name#> */
@property (strong,nonatomic) MPPlayerManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}  //关闭自动偏移
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(0, 64, 100, 100);
    [btn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}
- (void)addButtonClick:(UIButton *)sender{
    MPPlayerManager *manager = [MPPlayerManager sharedInstanceView:[UIApplication sharedApplication].keyWindow];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"456" ofType:@"flv"];
    manager.mediaURL = [NSURL fileURLWithPath:imagePath];
    [manager mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([UIApplication sharedApplication].keyWindow);
        make.height.equalTo(@(ScreenWidth / ScreenHeight * ScreenWidth));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    //        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp4"];

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
