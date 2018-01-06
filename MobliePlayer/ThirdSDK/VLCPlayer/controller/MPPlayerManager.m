//
//  MPPlayerManager.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import "MPPlayerManager.h"
#import "MPControlView.h"
#import "MPHUDView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+ScreenRotation.h"
#import "UITabBarController+ScreenRotation.h"
#import "UINavigationController+ScreenRotation.h"
#import "MPPlayer.h"
#import "MPBirghtness.h"
#import "MPPanGestureRecognizer.h"
#import "UIView+ScreenRotation.h"

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface MPPlayerManager () <VLCMediaPlayerDelegate, UIGestureRecognizerDelegate, MPPanGestureRecognizerDelegates, MPControlViewDelegate,ScreenRotationDeleagte>
/** 手势 */
@property(nonatomic, strong) MPPanGestureRecognizer *panRecognizer;
/**播放器*/
@property(nonatomic, strong) VLCMediaPlayer *player;
/** HUD */
@property(strong, nonatomic) MPHUDView *HUDView;
/** MPControlView */
@property(strong, nonatomic) MPControlView *controlView;
/** 亮度 */
@property(strong, nonatomic) MPBirghtness *birghtness;
/** 滑杆 */
@property(nonatomic, strong) UISlider *volumeViewSlider;
/** 用来保存快进的总时长 */
@property(nonatomic, assign) CGFloat sumTime;
/** 是否正在拖拽 */
@property(nonatomic, assign) BOOL isDragged;
@end

@implementation MPPlayerManager
+ (instancetype)sharedInstanceView:(UIView *)view {
    static MPPlayerManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MPPlayerManager alloc] init];
        [view addSubview:instance];
    });
    instance.hidden = NO;
    [instance willMoveToSuperview:view];
    return instance;
}

- (void)didMoveToSuperview {

}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.backgroundColor = [UIColor blackColor];
    [self.controlView showAnimation];
    [self addNotification];

    self.alpha = 0.0;
    [UIView animateWithDuration:AnimationTime delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5//初始速度，数值越大初始速度越快
                        options:UIViewAnimationOptionCurveEaseIn//动画的过渡效果
                     animations:^{
                         //执行的动画
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         //动画执行完毕后的操作
                         [self MediaPlay];
                         self.player.drawable = self;
                     }];
    [self screenRotation];
    self.delegate = self;
    [self bringSubviewToFront:self.controlView];
    [self configureVolume];
    [self birghtness];
}

#pragma mark - view init

- (void)addNotification {
    // app启动或者app从后台进入前台都会调用这个方法
//    [CLNotificationCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // app从后台进入前台都会调用这个方法
    [CLNotificationCenter addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [CLNotificationCenter addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    //耳机插入拔掉通知
    [CLNotificationCenter addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];

}

#pragma mark - 通知


//app前后台切换通知
- (void)applicationBecomeActive {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationEnterBackground {
    [self MediaPause];
}

//app耳机插入通知
- (void)audioRouteChangeListenerCallback:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self MediaPause];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

/* 旋转 */
#pragma mark - ScreenRotationDeleagte
- (void)rotatingIntoVerticalScreen {
    NSLog(@"竖直");
    self.controlView.fullScreenBtn.selected = NO;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([UIApplication sharedApplication].keyWindow);
        make.height.equalTo(@(ScreenHeight / ScreenWidth * ScreenHeight));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)rotatingIntoLandscape {
    NSLog(@"水平");
    self.controlView.fullScreenBtn.selected = YES;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenHeight));
        make.height.equalTo(@(ScreenWidth));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}
- (void)itsRotation {
    self.birghtness.transform = CGAffineTransformIdentity;
    self.birghtness.transform = [self.birghtness getTransformRotationAngle];
}

#pragma mark - UIPanGestureRecognizer手势方法

/** pan水平移动的方法 */
- (void)horizontalMoved:(CGFloat)value {
    self.sumTime = self.sumTime + value;
//    移动的时常
    CGFloat play = self.sumTime / self.player.media.length.value.floatValue;
    if (play > 1) {play = 1;}
    if (play < 0) {play = 0;}
    [self changePlayTime:play];
    [self.controlView MPPlayerManagerProgress:play time:[self durationStringWithTime:play * self.player.media.length.value.floatValue] value:value];
    self.controlView.playTimeLabel.text = [self durationStringWithTime:self.sumTime];
}

/** 根据时长求出字符串 */
- (NSString *)durationStringWithTime:(int)time {
    VLCTime *timer = [VLCTime timeWithInt:time];
    return timer.stringValue;
}

/** pan垂直移动的方法 */
- (void)verticalMoved:(CGFloat)value {
    self.birghtness.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/** 获取系统音量 */
- (void)configureVolume {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, -1000, 100, 100)];
    volumeView.hidden = NO;
    [self addSubview:volumeView];
    _volumeViewSlider = nil;
    //去掉提示框
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            [_volumeViewSlider setFrame:CGRectMake(-1000, -1000, 10, 10)];
            _volumeViewSlider = (UISlider *) view;

            break;
        }
    }
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
            setCategory:AVAudioSessionCategoryPlayback
                  error:&setCategoryError];

    if (!success) { /* handle the error in setCategoryError */ }

}

#pragma mark - 滑竿改变进度

- (void)changePlayTime:(CGFloat)value {
    if (value > 1) {value = 1;}
    if (value < 0) {value = 0;}
    self.controlView.bottomProgress.value = value;
    [self.controlView.playProgress setValue:value animated:YES];
    self.controlView.playTimeLabel.text = self.player.time.stringValue;
    self.controlView.videoTimeLabel.text = self.player.media.length.stringValue;
}

- (void)playWithTime:(CGFloat)value {
    int targetIntvalue = (int) (value * (float) self.player.media.length.intValue);
    VLCTime *targetTime = [[VLCTime alloc] initWithInt:targetIntvalue];
    [self.player setTime:targetTime];
}

#pragma mark - play/pause/stop

/** 播放 */
- (void)MediaPlay {
    [self.player play];
    self.controlView.playTimeLabel.text = self.player.time.stringValue;
    self.controlView.videoTimeLabel.text = self.player.media.length.stringValue;
    self.controlView.playBtn.selected = NO;
    [self panRecognizer];
}

/** 暂停 */
- (void)MediaPause {
    [self.player pause];
    self.controlView.playBtn.selected = YES;
}

/** 停止 */
- (void)MediaStop {
    [self.player stop];
    self.controlView.playBtn.selected = YES;
    self.controlView.playProgress.value = 0;
    self.controlView.bottomProgress.value = 0;
    self.controlView.playTimeLabel.text = @"00:00";
}

#pragma mark - MPControlViewDelegate

/** 播放按钮 */
- (void)DelegatePlayBtn:(UIButton *)play {
    play.selected ? [self MediaPlay] : [self MediaPause];
}

/** 全屏 */
- (void)DelegateFullScreenBtn:(UIButton *)fullScreen {
    fullScreen.selected = !fullScreen.selected;

    if (fullScreen.selected) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self transform:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self transform:UIInterfaceOrientationLandscapeRight];
        }
    } else {
        [self transform:UIInterfaceOrientationPortrait];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

/** 关闭视频 */
- (void)DelegateCloseBtn:(UIButton *)close {
    [self MediaStop];
}

- (void)DelegateProgressSlider:(UISlider *)slider {
    self.controlView.isHiddenControl = NO;
    [self changePlayTime:slider.value];
    [self playWithTime:slider.value];
}

- (void)DelegateProgressSliderFinish {
    self.controlView.isHiddenControl = YES;
}

- (void)DelegateFontSliderTapped:(UITapGestureRecognizer *)tapGesture {
    if ([NSStringFromClass([tapGesture.view class]) isEqualToString:@"UIImageView"]) {
        return;
    }
    CGPoint touchPoint = [tapGesture locationInView:self.controlView.playProgress];
    CGFloat value = (self.controlView.playProgress.maximumValue - self.controlView.playProgress.minimumValue) * (touchPoint.x / self.controlView.playProgress.frame.size.width);
    [self.controlView.playProgress setValue:value animated:YES];
    [self changePlayTime:value];
    [self playWithTime:value];
}

/** 处理双击操作 */
- (void)DelegateDoubleTap:(UITapGestureRecognizer *)recognizer {
    self.controlView.playBtn.selected ? [self MediaPlay] : [self MediaPause];
}

#pragma mark - VLCMediaPlayerDelegate

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    [self bringSubviewToFront:self.HUDView];
    [self bringSubviewToFront:self.controlView];
    if (self.player.media.state == VLCMediaStateBuffering) {
        self.HUDView.hidden = NO;
//        self.controlView.playBtn ? [self MediaPlay]:[self MediaPause];
    } else if (self.player.media.state == VLCMediaStatePlaying) {
        self.HUDView.hidden = YES;
    } else if (self.player.state == VLCMediaPlayerStateStopped) {
        [self MediaStop];
    } else {
        self.HUDView.hidden = NO;
    }
    NSLog(@"+++++++++++++++%ld————————————————————————", (long) self.player.state);
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    if (self.controlView.playProgress.state != UIControlStateNormal) {
        return;
    }
    if (self.panRecognizer.state != UIGestureRecognizerStateBegan && self.panRecognizer.state != UIGestureRecognizerStateChanged && self.panRecognizer.state != UIGestureRecognizerStateEnded) {
        float precentValue = ([self.player.time.numberValue floatValue]) / ([self.player.media.length.numberValue floatValue]);
        [self.controlView.playProgress setValue:precentValue animated:YES];
        [self.controlView.bottomProgress setValue:precentValue];
        self.controlView.playTimeLabel.text = self.player.time.stringValue;
        self.controlView.videoTimeLabel.text = self.player.media.length.stringValue;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击a不执行Touch事件
    NSLog(@"^^^^^^^^^^^^^^^^^^%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    return YES;
}

#pragma mark - MPPanGestureRecognizerDelegates

//横向移动
- (void)panHorizontalMoved:(PanMoved)moved position:(CGFloat)position {
    switch (moved) {
        case PanBeganMoved:
            NSLog(@"66666666666666666666::::::%@", self.player.time.stringValue);
            self.sumTime = self.player.time.intValue;
            break;
        case PanChangeMoved:
            [self horizontalMoved:position];
            break;
        case PanEndMoved: {
            CGFloat play = self.sumTime / self.player.media.length.value.floatValue;
            [self playWithTime:play];
            [self MediaPlay];
            self.sumTime = 0;
        }
            break;
        default:
            break;
    }
}

//纵向移动
- (void)panVerticalMovedVolum:(PanMoved)moved position:(CGFloat)position isVolume:(BOOL)isVolume {
    switch (moved) {
        case PanBeganMoved:
            self.birghtness.isVolume = isVolume;
            break;
        case PanChangeMoved:
            [self verticalMoved:position];
            break;
        case PanEndMoved:
            self.birghtness.isVolume = NO;
            break;
        default:
            break;
    }
}

#pragma mark - dealloc

- (void)dealloc {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [CLNotificationCenter removeObserver:self];
}

#pragma mark - setter

- (void)setMediaURL:(NSURL *)mediaURL {
    _mediaURL = mediaURL;
    [self.player setDrawable:self];
    self.player.media = [[VLCMedia alloc] initWithURL:_mediaURL];
}

#pragma mark - getter

- (MPBirghtness *)birghtness {
    if (!_birghtness) {
        _birghtness = [MPBirghtness sharedBrightnessView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_birghtness];
        [_birghtness mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(155));
            make.height.equalTo(@(155));
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
    return _birghtness;
}

- (VLCMediaPlayer *)player {
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] initWithOptions:@[@"--avi-index=2"]];
        _player.delegate = self;
    }
    return _player;
}

- (MPHUDView *)HUDView {
    if (!_HUDView) {
        _HUDView = [[MPHUDView alloc] init];
        [self addSubview:_HUDView];
        [_HUDView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
    return _HUDView;
}

- (MPControlView *)controlView {
    if (!_controlView) {
        _controlView = [[MPControlView alloc] init];
        [self addSubview:_controlView];
        self.controlView.delegate = self;
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.height.equalTo(self);
            make.center.equalTo(self);
        }];
    }
    return _controlView;
}

- (MPPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        MPPanGestureRecognizer *panRecognizer = [MPPanGestureRecognizer panGestureRecognizer];
        panRecognizer.delegate = self;
        panRecognizer.delegates = self;
        [self addGestureRecognizer:panRecognizer];
        _panRecognizer = panRecognizer;
    }
    return _panRecognizer;
}

#pragma clang diagnostic pop
@end
