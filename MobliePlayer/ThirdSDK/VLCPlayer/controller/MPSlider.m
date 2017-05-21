//
//  MPSlider.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/6.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPSlider.h"
#import <Masonry/Masonry.h>

@interface MPSlider()
/** <#name#> */
@property (strong,nonatomic) UIImageView *backImage;
/** <#name#> */
@property (strong,nonatomic) UIImageView *progressImage;

@end

@implementation MPSlider

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self backImage];
    [self progressImage];
}

- (void)setValue:(CGFloat)value{
    self.progressImage.frame = CGRectMake(0, 0, value * self.frame.size.width, 2);
}

- (UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc]init];
        _backImage.backgroundColor = [UIColor colorWithWhite:0.714 alpha:1.000];
        [self addSubview:_backImage];
        [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];
    }
    return _backImage;
}
- (UIImageView *)progressImage{
    if (!_progressImage) {
        _progressImage = [[UIImageView alloc]init];
        _progressImage.backgroundColor = [UIColor colorWithRed:0.929 green:0.251 blue:0.251 alpha:1.000];
        [self addSubview:_progressImage];
    }
    return _progressImage;
}
@end
