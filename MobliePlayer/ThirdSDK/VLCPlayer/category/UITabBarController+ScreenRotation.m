//
// Created by zyyt on 2017/12/29.
// Copyright (c) 2017 gentear. All rights reserved.
//

#import "UITabBarController+ScreenRotation.h"


@implementation UITabBarController (ScreenRotation)

- (NSInteger)cl_selectedIndex {
    NSInteger index = [self selectedIndex];
    if (index > self.viewControllers.count) { return 0; }
    return index;
}
- (BOOL)shouldAutorotate {
    UIViewController *tmpVc = self.viewControllers[[self cl_selectedIndex]];
    if ([tmpVc isKindOfClass:[UINavigationController class]]){
        return ((UINavigationController *)tmpVc).topViewController.shouldAutorotate;
    }
    return tmpVc.shouldAutorotate;

}
@end