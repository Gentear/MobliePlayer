//
//  MPHUDView.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPHUDView.h"
#import "MPPlayer.h"
@implementation MPHUDView

+ (instancetype)HUDView{
    
    return [[self alloc]init];
    
}
- (instancetype)init{
    if (self = [super init]) {
        //采用贝瑟尔路径绘制圆环
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(HUDWidth * 0.5, HUDWidth * 0.5) radius:HUDWidth * 0.5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 3;
        //    shapeLayer.lineJoin = kCALineJoinRound;
        //    shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.path = path.CGPath;
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        //autoreverses自动反转
        animation.autoreverses = YES;
        animation.duration = 1.5;
        animation.repeatCount = MAXFLOAT;
        // 设置layer的animation
        [shapeLayer addAnimation:animation forKey:nil];
        
        CABasicAnimation *anim = [CABasicAnimation animation];
        
        anim.keyPath = @"transform.rotation";
        anim.toValue = @(angle2Rad(360));
        anim.repeatCount = MAXFLOAT;
        anim.duration = 1;
        
        
        CAKeyframeAnimation *anim2 = [CAKeyframeAnimation animation];
        
        // 设置动画属性
        anim2.keyPath = @"strokeColor";
        NSValue *v1 = (id)[UIColor blueColor].CGColor;
        NSValue *v2 = (id)[UIColor redColor].CGColor;
        NSValue *v3 = (id)[UIColor greenColor].CGColor;
        anim2.values = @[v1,v2,v3];
        anim2.duration = 3;
        anim2.repeatCount = MAXFLOAT;
        [shapeLayer addAnimation:anim2 forKey:nil];
        
        // self.heart需要添加动画的view
        [self.layer addSublayer:shapeLayer];
        [self.layer addAnimation:anim forKey:nil];
    }
    return self;
}
@end
