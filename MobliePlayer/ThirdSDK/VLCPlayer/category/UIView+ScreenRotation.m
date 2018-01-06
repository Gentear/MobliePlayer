//
// Created by zyyt on 2018/1/2.
// Copyright (c) 2018 gentear. All rights reserved.
//

#import "UIView+ScreenRotation.h"
#import "CLScreenRotation.h"
#import <objc/runtime.h>

static NSString *const ScreenRotationDelegate = @"ScreenRotationDelegate";

@implementation UIView (ScreenRotation)

- (void)screenRotation{
    /**
     * 开启通知
     */
    [CLDevice beginGeneratingDeviceOrientationNotifications];
    [CLNotificationCenter addObserver:self selector:@selector(deviceOrientationDidChangeNotification) name:UIDeviceOrientationDidChangeNotification object:nil];

}
- (void)deviceOrientationDidChangeNotification{
    UIDeviceOrientation orientation = CLDevice.orientation;
    UIInterfaceOrientation interfaceOrientation = orientation;

    if (interfaceOrientation == UIDeviceOrientationFaceUp ||
            interfaceOrientation == UIDeviceOrientationFaceDown ||
            interfaceOrientation == UIDeviceOrientationUnknown ||
            interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        return;
    }
    [self transform:interfaceOrientation];
}
- (void)transform:(UIInterfaceOrientation)interfaceOrientation{
    UIInterfaceOrientation currentOrientation = [CLApplication statusBarOrientation];
    if (currentOrientation == interfaceOrientation) {return;}
    if (currentOrientation != UIInterfaceOrientationPortrait){

        if (interfaceOrientation == UIInterfaceOrientationPortrait){
            /**
             * 旋转成竖直状态代理
             */
            if ([self.delegate
                    respondsToSelector:@selector(rotatingIntoVerticalScreen)]){
                [self.delegate rotatingIntoVerticalScreen];
            }
        }
    } else{
        /**
         * 旋转成水平状态代理
         */
        if ([self.delegate
                respondsToSelector:@selector(rotatingIntoLandscape)]){
            [self.delegate rotatingIntoLandscape];
        }
    }
    /**
     * 旋转view
     */
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:AnimationTime];
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    /**
     * 代理
     */
    if ([self.delegate respondsToSelector:@selector(itsRotation)]){
        [self.delegate itsRotation];
    }
    [UIView commitAnimations];
}
/** 获取变换的旋转角度 */
- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [CLApplication statusBarOrientation];
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}
- (void)setDelegate:(id <ScreenRotationDeleagte>)delegate {
    objc_setAssociatedObject(self, &ScreenRotationDelegate , delegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id <ScreenRotationDeleagte>)delegate {
    return objc_getAssociatedObject(self, &ScreenRotationDelegate);
}
@end