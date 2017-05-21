//
//  UIColor+CLColor.h
//  myCategary
//
//  Created by zyyt on 16/9/10.
//  Copyright © 2016年 丛蕾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CLColor)
/**
 *  获取颜色
 */
- (NSString *)CL_HexString;
/**
 *  16进制转颜色
 */
+ (UIColor *)CL_colorWithHexColorString:(NSString *)hexColorString;
/**
 *  随机颜色
 */
+ (UIColor *)CL_randomColor;
/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)CL_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
/**
 *  将颜色变亮
 *
 *  @param lighten 0 - 1
 */
- (UIColor *)CL_lightenColor:(CGFloat)lighten;
/**
 *  将颜色变暗
 *
 *  @param lighten 0 - 1
 */
- (UIColor *)CL_darkenColor:(CGFloat)darken;
@end
