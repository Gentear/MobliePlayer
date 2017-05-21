//
//  MPFastView.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/14.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPFastView.h"
#import <Masonry/Masonry.h>
#import "MPPlayer.h"

@interface MPFastView()
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView *fastImageView;
@end

@implementation MPFastView


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self fastImageView];
    [self fastTimeLabel];
    [self fastProgressView];
}

- (void)setProgress:(CGFloat)progress time:(NSString *)time value:(CGFloat)value{
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }

    [self.fastProgressView setProgress:progress];
    if (style) {
        self.fastImageView.image = [UIImage imageNamed:@"fast_forward"];
        self.fastTimeLabel.text = time;
    } else {
        self.fastImageView.image = [UIImage imageNamed:@"fast_backward"];
        self.fastTimeLabel.text = time;
    }
    self.alpha = 1;
    double delayInSeconds = FastInSeconds;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self MPFastViewHideAnimation];
    });
}
- (void)MPFastViewHideAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
}
- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
        [self addSubview:_fastImageView];
        [_fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(32);
            make.height.mas_offset(32);
            make.top.mas_equalTo(5);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return _fastImageView;
}
- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc] init];
        _fastTimeLabel.textColor = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_fastTimeLabel];
        [_fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.with.trailing.mas_equalTo(0);
            make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
        }];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        [self addSubview:_fastProgressView];
        [_fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(12);
            make.trailing.mas_equalTo(-12);
            make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
        }];
    }
    return _fastProgressView;
}
@end
