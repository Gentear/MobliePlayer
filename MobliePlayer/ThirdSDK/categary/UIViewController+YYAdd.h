//
//  UIViewController+YYAdd.h
//  Pods
//
//  Created by 王海堑 on 16/2/29.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (YYAdd)



-(void)setCustomNavigationTitle:(NSString *)title;

-(UIButton *)add_navigation_left_buttonWithNormalImage:(NSString *)normalImageName highlightImage:(NSString *)highlightImageName;

-(void)add_navigation_back_button;


-(UIButton *)add_navigation_right_buttonWithNormalImage:(NSString *)normalImageName highlightImage:(NSString *)highlightImageName;

-(UIButton *)add_navigation_right_button_BT:(UIButton *)rightButton;

-(UIButton *)add_navigation_right_button_title:(NSString *)title;

- (void)hideTabBar;

- (void)showTabBar;

- (void)hideTabBar:(UITabBarController *)tab;

- (void)showTabBar:(UITabBarController *)tab;


-(void)dismissRootVCWithAnimation:(BOOL)isAnimation;

-(void)setBackGroudImage:(UIImage *)image;


@end
