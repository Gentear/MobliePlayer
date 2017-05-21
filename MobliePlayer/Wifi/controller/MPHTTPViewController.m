//
//  MPHTTPViewController.m
//  MobliePlayer
//
//  Created by zyyt on 17/4/24.
//  Copyright © 2017年 conglei. All rights reserved.
//
#import "MPHTTPViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <GCDWebServer/GCDWebUploader.h>
#import <GCDWebServer/GCDWebServer.h>
#import <Masonry/Masonry.h>
#import "UIColor+CLColor.h"
#import "MPCopyableLabel.h"
#import "UIViewController+YYAdd.h"
@interface MPHTTPViewController ()<GCDWebUploaderDelegate,MPCopyableLabelDelegate>

/** 上传服务 */
@property (strong,nonatomic) GCDWebUploader *webServer;

/** <#name#> */
@property (strong,nonatomic) UIImageView *wifiImage;
/** WIFI服务已开启 */
@property (strong,nonatomic) UILabel *wifiLabel;
/** 上传过程中请勿离开此页面或锁屏 */
@property (strong,nonatomic) UILabel *wifiDescription;
/** 确保手机电脑在同一wifi下 */
@property (strong,nonatomic) UILabel *wifiEqual;
/** 在电脑浏览器地址栏输入 */
@property (strong,nonatomic) UILabel *wifiInput;
/** wifiip */
@property (strong,nonatomic) MPCopyableLabel *wifiLocalHost;
/** <#name#> */
@property (strong,nonatomic) UIView *backImage;

@end

@implementation MPHTTPViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomNavigationTitle:@"WIFI传输"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.18 alpha:1];
    self.backImage.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1.00];
    if ([self.webServer start]) {
    NSLog(@"%@",[NSString stringWithFormat:NSLocalizedString(@"GCDWebServer running locally on port %i", nil), (int)_webServer.port]);
        self.wifiImage.image = [UIImage imageNamed:@"icon_wifi"];
        self.wifiLabel.text = @"WIFI服务已开启";
        self.wifiDescription.text = @"上传过程中请勿离开此页面或锁屏";
        self.wifiEqual.text = @"确保手机和电脑在同一WIFI网络下";
        self.wifiInput.text = @"在电脑浏览器地址栏输入(长按复制)";

    } else {
         NSLocalizedString(@"GCDWebServer not running!", nil);
        self.wifiImage.image = [UIImage imageNamed:@"icon_wifi_offline"];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_webServer stop];
    _webServer = nil;
}
#pragma mark - GCDWebServerDelegate
/**
 *  This method is called after the server has successfully started.
 */
- (void)webServerDidStart:(GCDWebServer *)server
{
    NSLog(@"\n\nServerURL: %@\n\n", [[server serverURL] absoluteString]);
    self.wifiLocalHost.text = [[server serverURL] absoluteString];

}

/**
 *  This method is called after the Bonjour registration for the server has
 *  successfully completed.
 */
- (void)webServerDidCompleteBonjourRegistration:(GCDWebServer *)server
{
    NSLog(@"\n\nBonjourURL: %@\n\n", server.bonjourServerURL);
    
    // web 地址 自动拷贝到粘贴板 方便用户在浏览器内输入
}

/**
 *  This method is called when the first GCDWebServerConnection is opened by the
 *  server to serve a series of HTTP requests.
 *
 *  A series of HTTP requests is considered ongoing as long as new HTTP requests
 *  keep coming (and new GCDWebServerConnection instances keep being opened),
 *  until before the last HTTP request has been responded to (and the
 *  corresponding last GCDWebServerConnection closed).
 */
- (void)webServerDidConnect:(GCDWebServer *)server
{
    
}

/**
 *  This method is called when the last GCDWebServerConnection is closed after
 *  the server has served a series of HTTP requests.
 *
 *  The GCDWebServerOption_ConnectedStateCoalescingInterval option can be used
 *  to have the server wait some extra delay before considering that the series
 *  of HTTP requests has ended (in case there some latency between consecutive
 *  requests). This effectively coalesces the calls to -webServerDidConnect:
 *  and -webServerDidDisconnect:.
 */
- (void)webServerDidDisconnect:(GCDWebServer *)server
{
    
}

/**
 *  This method is called after the server has stopped.
 */
- (void)webServerDidStop:(GCDWebServer *)server
{
    
}
#pragma mark - GCDWebUploaderDelegate
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
}
- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
}
- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
}
- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
}
#pragma mark - HTCopyableLabelDelegate
- (NSString *)stringToCopyForCopyableLabel:(MPCopyableLabel *)copyableLabel{
    return copyableLabel.text;
}
#pragma mark - set方法
- (GCDWebUploader *)webServer{
    if (!_webServer) {
        NSString* documentsPath = [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
       
        _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
        _webServer.delegate = self;
        _webServer.allowHiddenItems = YES;
        _webServer.title = @"页面标题";
        _webServer.header = @"文件管理";
        _webServer.footer = @"123";
    }
    return _webServer;
}
- (UIImageView *)wifiImage{
    if (!_wifiImage) {
        _wifiImage = [[UIImageView alloc]init];
        [self.view addSubview:_wifiImage];
        [_wifiImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(107, 82.5));
            make.top.mas_equalTo(@104);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _wifiImage;
}
/** WIFI服务已开启 */
- (UILabel *)wifiLabel{
    if (!_wifiLabel) {
        _wifiLabel = [[UILabel alloc]init];
        _wifiLabel.textAlignment = NSTextAlignmentCenter;
        _wifiLabel.textColor = [UIColor colorWithRed:0.51 green:0.81 blue:0.42 alpha:1.00];
        _wifiLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_wifiLabel];
        [_wifiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 20));
            make.top.mas_equalTo(@224);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _wifiLabel;
}
/** 上传过程中请勿离开此页面或锁屏 */
- (UILabel *)wifiDescription{
    if (!_wifiDescription) {
        _wifiDescription = [[UILabel alloc]init];
        _wifiDescription.textAlignment = NSTextAlignmentCenter;
        _wifiDescription.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.59 alpha:1.00];
        _wifiDescription.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_wifiDescription];
        [_wifiDescription mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 20));
            make.top.mas_equalTo(@260);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _wifiDescription;
}
/** 确保手机电脑在同一wifi下 */
- (UILabel *)wifiEqual{
    if (!_wifiEqual) {
        _wifiEqual = [[UILabel alloc]init];
        _wifiEqual.textAlignment = NSTextAlignmentCenter;
//        _wifiEqual.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.59 alpha:1.00];
        _wifiEqual.font = [UIFont systemFontOfSize:18];
        [self.backImage addSubview:_wifiEqual];
        [_wifiEqual mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 20));
            make.top.mas_equalTo(@50);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _wifiEqual;
}
/** 在电脑浏览器地址栏输入 */
- (UILabel *)wifiInput{
    if (!_wifiInput) {
        _wifiInput = [[UILabel alloc]init];
        _wifiInput.textAlignment = NSTextAlignmentCenter;
        _wifiInput.textColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.59 alpha:1.00];
        _wifiInput.font = [UIFont systemFontOfSize:13];
        [self.backImage addSubview:_wifiInput];
        [_wifiInput mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 20));
            make.top.mas_equalTo(@75);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _wifiInput;
}
/** wifiip */
- (MPCopyableLabel *)wifiLocalHost{
    if (!_wifiLocalHost) {
        _wifiLocalHost = [[MPCopyableLabel alloc]init];
        _wifiLocalHost.textAlignment = NSTextAlignmentCenter;
        _wifiLocalHost.copyableLabelDelegate = self;
        _wifiLocalHost.textColor = [UIColor whiteColor];
        _wifiLocalHost.backgroundColor = [UIColor colorWithRed:0.08 green:0.43 blue:0.85 alpha:1.00];
        _wifiLocalHost.layer.cornerRadius = 15;
        _wifiLocalHost.layer.masksToBounds = YES;
        [self.backImage addSubview:_wifiLocalHost];
        [_wifiLocalHost mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(240, 30));
            make.top.mas_equalTo(@115);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _wifiLocalHost;
}
- (UIView *)backImage{
    if (!_backImage) {
        _backImage = [[UIView alloc]init];
        [self.view addSubview:_backImage];
        [_backImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height/2));
            make.top.mas_equalTo(self.view.frame.size.height/2);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
    }
    return _backImage;
}
@end

