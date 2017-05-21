//
//  YJTabBarViewController.m
//  E_Jian
//
//  Created by  on 16/3/7.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "MPTabBarViewController.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "MPHTTPViewController.h"
#import "MPFloderViewController.h"
#import "ViewController.h"

@interface MPTabBarViewController ()
@property(strong,nonatomic) UIColor *bgColor;

@end

@implementation MPTabBarViewController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//         NSLog(@"%@", [International getUserLanguage]);
//        YJHomeViewController *homeVC = [[YJHomeViewController alloc] init];
//        //3D地图
//        YJ3DMapHomeViewController *homeVC = [[YJ3DMapHomeViewController alloc] init];
//        [self addChildViewController:homeVC title:[International setLanguage:@"首页"] normalImage:@"TabBar-Featured-normal" selectImage:@"TabBar-Featured-select"];
//        YJCustomizeViewController *customizeVC = [[YJCustomizeViewController alloc] init];
//        [self addChildViewController:customizeVC title:[International setLanguage:@"专题"] normalImage:@"TabBar-Topic-normal" selectImage:@"TabBar-Topic-select"];
//        YJMyViewController *myVC = [[YJMyViewController alloc] init];
//        [self addChildViewController:myVC title:[International setLanguage:@"我的"] normalImage:@"TabBar-My-normal" selectImage:@"TabBar-My-select"];
//        
//        UIImage *bgImg = [[UIImage alloc] init];
//        [self.tabBar setBackgroundImage:bgImg];
//        
//        self.tabBar.opaque = YES;
//        [self.tabBar setShadowImage:bgImg];

//    }
//    return self;
//}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage{
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:normalImage];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : YJBLUECOLOR} forState:UIControlStateSelected];
    
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:childController];
    [nav.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    [self addChildViewController:nav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MPFloderViewController *customizeVC = [[MPFloderViewController alloc] init];
    [self addChildViewController:customizeVC title:@"专题" normalImage:@"TabBar-Topic-normal" selectImage:@"TabBar-Topic-select"];
    MPHTTPViewController *myVC = [[MPHTTPViewController alloc] init];
    [self addChildViewController:myVC title:@"我的" normalImage:@"TabBar-My-normal" selectImage:@"TabBar-My-select"];
    
//    UIImage *bgImg = [[UIImage alloc] init];
//    [self.tabBar setBackgroundImage:bgImg];
//    
//    self.tabBar.opaque = YES;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
////    [self changTabBarBackground:[UIColor colorWithHexString:@"#1a1a1ad0"]];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
