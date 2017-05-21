//
//  UIViewController+YYAdd.m
//  Pods
//
//  Created by 王海堑 on 16/2/29.
//
//

#import "UIViewController+YYAdd.h"
//#import "UIView+YYAdd.h"
//#import "UIColor+YYAdd.h"
//#import "Constants.h"

@implementation UIViewController (YYAdd)

-(void)setCustomNavigationTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 180, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationItem.titleView = titleLabel;
}

- (void)add_navigation_back_button
{
    
    //左侧按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    [backButton setImage:[UIImage imageNamed:@"Nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"Nav_back"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(navigation_left_button_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backButton];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -15;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
}

-(UIButton *)add_navigation_right_buttonWithNormalImage:(NSString *)normalImageName highlightImage:(NSString *)highlightImageName
{
    //右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 22.0f, 20.0f)];
    [rightButton setImage:[UIImage imageNamed:normalImageName]   forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(navigation_right_button_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = backButtonItem;
    
    return rightButton;
}

-(UIButton *)add_navigation_right_button_BT:(UIButton *)rightButton
{
    [rightButton addTarget:self action:@selector(navigation_right_button_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = backButtonItem;
    
    return rightButton;
}

-(UIButton *)add_navigation_right_button_title:(NSString *)title
{
    //右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 70.f, 20.0f)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightButton addTarget:self action:@selector(navigation_right_button_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    return rightButton;
}

-(void)navigation_right_button_click:(UIButton *)button
{
    
}

- (void)hideTabBar
{
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformTranslate(self.tabBarController.tabBar.transform, 0, 49);
    } completion:^(BOOL finished) {
        self.tabBarController.tabBar.hidden = YES;
    }];
}

- (void)showTabBar
{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformTranslate(self.tabBarController.tabBar.transform, 0, -49);
        
    } completion:^(BOOL finished) {
        self.tabBarController.tabBar.hidden = NO;
    }];
}

- (void)hideTabBar:(UITabBarController *)tab
{
    if (tab.tabBar.hidden == YES) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformTranslate(self.tabBarController.tabBar.transform, 0, 49);
    } completion:^(BOOL finished) {
        tab.tabBar.hidden = YES;
    }];
}

- (void)showTabBar:(UITabBarController *)tab
{
    if (tab.tabBar.hidden == NO)
    {
        return;
    }
    tab.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.tabBarController.tabBar.transform = CGAffineTransformTranslate(self.tabBarController.tabBar.transform, 0, -49);
    }];
}



//-(UIButton *)add_navigation_back_title:(NSString *)title
//{
//    UIButton * backBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBT setTitle:title forState:UIControlStateNormal];
//    [backBT setTitle:title forState:UIControlStateHighlighted];
//    [backBT sizeToFit];
//    [backBT setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//    [backBT addTarget:self action:@selector(navigation_right_button_click:) forControlEvents:UIControlEventTouchUpInside];
//    backBT.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backBT];
//    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixedItem.width = -10;
//    self.navigationItem.rightBarButtonItems = @[fixedItem, rightItem];
//    
//    return backBT;
//}

-(UIButton *)add_navigation_left_buttonWithNormalImage:(NSString *)normalImageName highlightImage:(NSString *)highlightImageName
{
    //左侧按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 22.0f, 20.0f)];
    [leftButton setImage:[UIImage imageNamed:normalImageName]   forState:UIControlStateNormal];
//    [leftButton setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(navigation_left_button_click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    return leftButton;
}

-(void)navigation_left_button_click:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissRootVCWithAnimation:(BOOL)isAnimation
{
    UIViewController *viewController = self;
    while (viewController.presentingViewController)
    {
        if (viewController)  // 直到找到最底层为止
        {
            viewController = viewController.presentingViewController;
        }
        else
        {
            break;
        }
        
    }
    if (viewController)
    {
        if (isAnimation) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [viewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
}

-(void)setBackGroudImage:(UIImage *)image
{
    if (self.navigationController.navigationBar) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

@end
