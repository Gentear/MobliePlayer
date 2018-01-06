//
//  MPControlView.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPControlView.h"
#import "UIButton+MPButton.h"
#import "MPPlayer.h"
#import "UIView+CLView.h"
#import "MPFastView.h"
//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
@interface MPControlView ()<UIGestureRecognizerDelegate>
/** 是否隐藏 */
@property (assign,nonatomic) BOOL isHide;

/** 显示 */
@property (strong,nonatomic) UITapGestureRecognizer *tapShowView;

/** 快进快退View*/
@property (nonatomic, strong) MPFastView *fastView;


@end

@implementation MPControlView

+ (id)controlView{
    return [[self alloc]init];
}
- (instancetype)init{
    if (self = [super init]) {
        _isHide = YES;
        self.layer.masksToBounds = YES;
    }
    return self;
}
#pragma mark - buttonClick
-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    //处理单击操作
    if (self.fullScreenBtn.hidden == YES) {
        [self showAnimation];
    }else{
        [self hideAnimation];
    }
}
#pragma mark - show view
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self bottomImage];
    [self topImage];
    [self playBtn];
    [self fullScreenBtn];
    [self playProgress];
    [self playTimeLabel];
    [self videoTimeLabel];
    [self closeBtn];
    [self tapShowView];
    [self showFrame];
    [self addTarget];
}
- (void)hideAnimation{
    if (!_isHiddenControl) {
        return;
    }
    [UIView animateWithDuration:AnimationTime animations:^{
        [self hiddenFrame];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bottomImage.hidden = YES;
        self.topImage.hidden = YES;
        self.playBtn.hidden = YES;
        self.fullScreenBtn.hidden = YES;
        self.playProgress.hidden = YES;
        self.playTimeLabel.hidden = YES;
        self.videoTimeLabel.hidden = YES;
        self.closeBtn.hidden = YES;
        self.bottomProgress.hidden = NO;
        if (self.frame.size.height == ScreenHeight) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
    }];
}
- (void)showAnimation{
    _isHiddenControl = YES;
//    if (self.frame.size.height == ScreenHeight) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    }
    self.bottomImage.hidden = NO;
    self.topImage.hidden = NO;
    self.playBtn.hidden = NO;
    self.fullScreenBtn.hidden = NO;
    self.playProgress.hidden = NO;
    self.playTimeLabel.hidden = NO;
    self.videoTimeLabel.hidden = NO;
    self.closeBtn.hidden = NO;
    self.bottomProgress.hidden = YES;
    [UIView animateWithDuration:AnimationTime animations:^{
        [self showFrame];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self delayedHidden];
    }];
}
- (void)delayedHidden{
    double delayInSeconds = DelayInSeconds;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hideAnimation];
    });
}
#pragma mark - 快进
/** 快进 */
- (void)MPPlayerManagerProgress:(CGFloat)progress time:(NSString *)time value:(CGFloat)value{
    [self.fastView setProgress:progress time:time value:value];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"] && [NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - btn
- (void)addTarget{
    [self showAnimation];
    [self.playBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.playProgress addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    [self.playProgress addTarget:self action:@selector(progressSliderFinish) forControlEvents:UIControlEventTouchUpInside];
    [self.playProgress addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontSliderTapped:)]];
    [self.doubleStop addTarget:self action:@selector(DoubleTap:)];
}
/** 播放按钮 */
- (void)playBtn:(UIButton *)play{
    if ([self.delegate respondsToSelector:@selector(DelegatePlayBtn:)]) {
        [self.delegate DelegatePlayBtn:play];
    }
}
/** 全屏 */
- (void)fullScreenBtn:(UIButton *)fullScreen{
    if ([self.delegate respondsToSelector:@selector(DelegateFullScreenBtn:)]) {
        [self.delegate DelegateFullScreenBtn:fullScreen];
    }
}
/** 关闭视频 */
- (void)closeBtn:(UIButton *)close{
    if ([self.delegate respondsToSelector:@selector(DelegateCloseBtn:)]) {
        [self.delegate DelegateCloseBtn:close];
    }
}
- (void)progressSlider:(UISlider *)slider{
    if ([self.delegate respondsToSelector:@selector(DelegateProgressSlider:)]) {
        [self.delegate DelegateProgressSlider:slider];
    }
}
- (void)progressSliderFinish{
    if ([self.delegate respondsToSelector:@selector(DelegateProgressSliderFinish)]) {
        [self.delegate DelegateProgressSliderFinish];
    }
}
- (void)fontSliderTapped:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(DelegateFontSliderTapped:)]) {
        [self.delegate DelegateFontSliderTapped:tapGesture];
    }
}
/** 处理双击操作 */
-(void)DoubleTap:(UITapGestureRecognizer*)recognizer{
    if ([self.delegate respondsToSelector:@selector(DelegateDoubleTap:)]) {
        [self.delegate DelegateDoubleTap:recognizer];
    }
}
#pragma mark - set方法
- (void)setIsHiddenControl:(BOOL)isHiddenControl{
    _isHiddenControl = isHiddenControl;
    if (_isHiddenControl) {
        [self showAnimation];
    }
}

#pragma mark - getter
- (MPFastView *)fastView {
    if (!_fastView) {
        _fastView = [[MPFastView alloc] init];
        _fastView.backgroundColor = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius = 4;
        _fastView.layer.masksToBounds = YES;
//        _fastView.hidden = YES;
        [self addSubview:_fastView];
        [_fastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(125);
            make.height.mas_equalTo(80);
            make.center.equalTo(self);
        }];
        }
    return _fastView;
}
//
//- (UIButton *)failBtn {
//    if (!_failBtn) {
//        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
//        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
////        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
//        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _failBtn;
//}
- (UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_shadow"]];
        _topImage.userInteractionEnabled = YES;
        [self addSubview:_topImage];
    }
    return _topImage;
}
- (UIImageView *)bottomImage{
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_shadow"]];
        _bottomImage.userInteractionEnabled = YES;
        [self addSubview:_bottomImage];
    }
    return _bottomImage;
}
- (UITapGestureRecognizer *)doubleStop{
    if (!_doubleStop) {
        // 双击的 Recognizer
        UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc]init];
        doubleRecognizer.numberOfTapsRequired = 2; // 双击
        doubleRecognizer.numberOfTouchesRequired = 1; //手指数
        doubleRecognizer.delegate = self;
        // 解决点击当前view时候响应其他控件事件
        [doubleRecognizer setDelaysTouchesBegan:YES];
        //关键语句，给self.view添加一个手势监测；
        [self addGestureRecognizer:doubleRecognizer];
        _doubleStop = doubleRecognizer;
    }
    return _doubleStop;
}
- (UITapGestureRecognizer *)tapShowView{
    if (!_tapShowView) {
        // 单击的 Recognizer
        UITapGestureRecognizer* tapShowView;
        tapShowView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        tapShowView.delegate = self;
        //点击的次数
        tapShowView.numberOfTapsRequired = 1; // 单击
        tapShowView.numberOfTouchesRequired = 1; //手指数
        [tapShowView setDelaysTouchesBegan:YES];

        //给self.view添加一个手势监测；
        [self addGestureRecognizer:tapShowView];
        _tapShowView = tapShowView;
        // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
        [_tapShowView requireGestureRecognizerToFail:self.doubleStop];
    }
    return _tapShowView;
}
- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
        _playBtn.selected = YES;
        [self addSubview:_playBtn];
    }
    return _playBtn;
}
- (UILabel *)playTimeLabel{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc]init];
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.font = [UIFont systemFontOfSize:9];
        [self addSubview:_playTimeLabel];
        _videoTimeLabel.userInteractionEnabled = NO;
    }
    return _playTimeLabel;
}
- (UISlider *)playProgress{
    if (!_playProgress) {
        _playProgress = [[UISlider alloc]init];
        [_playProgress setMinimumTrackTintColor:[UIColor colorWithRed:0.929 green:0.251 blue:0.251 alpha:1.000]];
        _playProgress.continuous = YES;
        [_playProgress setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [self addSubview:_playProgress];
    }
    return _playProgress;
}
- (MPSlider *)bottomProgress{
    if (!_bottomProgress) {
        _bottomProgress = [[MPSlider alloc]init];
        [self addSubview:_bottomProgress];
       
    }
    return _bottomProgress;
}
- (UIButton *)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateSelected];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [self addSubview:_fullScreenBtn];
    }
    return _fullScreenBtn;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        
    }
    return _closeBtn;
}
- (UILabel *)videoTimeLabel{
    if (!_videoTimeLabel) {
        _videoTimeLabel = [[UILabel alloc]init];
        _videoTimeLabel.textColor = [UIColor whiteColor];
        _videoTimeLabel.font = [UIFont systemFontOfSize:9];
        _videoTimeLabel.textAlignment = NSTextAlignmentRight;
        _videoTimeLabel.userInteractionEnabled = NO;
        [self addSubview:_videoTimeLabel];
    }
    return _videoTimeLabel;
}
#pragma mark - 位置变化
- (void)showFrame{
    [self.bottomImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    [self.topImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.playProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playBtn).offset(50);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(_fullScreenBtn).offset(-50);
        make.height.mas_equalTo(30);
    }];
    [self.playTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.left.equalTo(_playBtn).offset(50);
        make.bottom.equalTo(self).offset(2);
    }];
    [self.videoTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.right.equalTo(_fullScreenBtn).offset(-50);
        make.bottom.equalTo(self).offset(2);
    }];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
    }];
    [self.bottomProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self).offset(2);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
    }];
}
- (void)hiddenFrame{
    [self.bottomImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self).offset(60);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    [self.topImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.top.equalTo(self).offset(-60);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(35);
    }];
    [self.fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(35);
    }];
    [self.playProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playBtn).offset(50);
        make.bottom.equalTo(self).offset(35);
        make.right.equalTo(_fullScreenBtn).offset(-50);
        make.height.mas_equalTo(30);
    }];
    [self.playTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.left.equalTo(_playBtn).offset(50);
        make.bottom.equalTo(self).offset(17);
    }];
    [self.videoTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 15));
        make.right.equalTo(_fullScreenBtn).offset(-50);
        make.bottom.equalTo(self).offset(17);
    }];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(-40);
    }];
    [self.bottomProgress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
    }];
}
#pragma clang diagnostic pop
@end
