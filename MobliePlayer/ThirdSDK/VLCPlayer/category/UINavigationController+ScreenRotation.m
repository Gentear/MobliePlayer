//
// Created by zyyt on 2017/12/29.
// Copyright (c) 2017 gentear. All rights reserved.
//

#import "UINavigationController+ScreenRotation.h"


@implementation UINavigationController (ScreenRotation)


- (BOOL)shouldAutorotate {

    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return self.visibleViewController.supportedInterfaceOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return self.visibleViewController.preferredInterfaceOrientationForPresentation;
}
//让自视图即顶层controller来控制显示状态
- (UIViewController *)childViewControllerForStatusBarHidden {

    return  self.visibleViewController;
}
- (UIViewController *)childViewControllerForStatusBarStyle {

    return self.visibleViewController;
}
@end