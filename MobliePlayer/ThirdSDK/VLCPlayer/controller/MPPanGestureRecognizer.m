//
//  MPPanGestureRecognizer.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/15.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPPanGestureRecognizer.h"

@implementation MPPanGestureRecognizer

+ (instancetype)panGestureRecognizer{
 
    return [[self alloc]init];
}
- (instancetype)init{
    if (self = [super init]) {
        [self addTarget:self action:@selector(panDirection:)];
        [self setMaximumNumberOfTouches:1];
        [self setDelaysTouchesBegan:YES];
        [self setDelaysTouchesEnded:YES];
        [self setCancelsTouchesInView:YES];
    }
    return self;
}
/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    CGPoint locationPoint = [pan locationInView:self.view];
    CGPoint veloctyPoint = [pan velocityInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 横向移动
                self.panDirection = PanDirectionHorizontalMoved;
                if ([self.delegates respondsToSelector:@selector(panHorizontalMoved:position:)]) {
                    [self.delegates panHorizontalMoved:PanBeganMoved position:veloctyPoint.x];
                }
            }else if (x < y){  // 纵向移动
                self.panDirection = PanDirectionVerticalMoved;
                NSLog(@"%f-----%f",locationPoint.x,self.view.bounds.size.width);
                if (locationPoint.x > self.view.bounds.size.width / 2) {
                    if ([self.delegates respondsToSelector:@selector(panVerticalMovedVolum:position:isVolume:)]) {
                        [self.delegates panVerticalMovedVolum:PanBeganMoved position:veloctyPoint.y isVolume:YES];
                    }
                }else { // 状态改为显示亮度调节
                    if ([self.delegates respondsToSelector:@selector(panVerticalMovedVolum:position:isVolume:)]) {
                        [self.delegates panVerticalMovedVolum:PanBeganMoved position:veloctyPoint.y isVolume:NO];
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if ([self.delegates respondsToSelector:@selector(panHorizontalMoved:position:)]) {
                        [self.delegates panHorizontalMoved:PanChangeMoved position:veloctyPoint.x];
                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    if ([self.delegates respondsToSelector:@selector(panVerticalMovedVolum:position:isVolume:)]) {
                        [self.delegates panVerticalMovedVolum:PanChangeMoved position:veloctyPoint.y isVolume:YES];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    if ([self.delegates respondsToSelector:@selector(panHorizontalMoved:position:)]) {
                        [self.delegates panHorizontalMoved:PanEndMoved position:veloctyPoint.x];
                    }
                    break;
                }
                case PanDirectionVerticalMoved:{
                    if ([self.delegates respondsToSelector:@selector(panVerticalMovedVolum:position:isVolume:)]) {
                        [self.delegates panVerticalMovedVolum:PanEndMoved position:veloctyPoint.y isVolume:YES];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
@end
