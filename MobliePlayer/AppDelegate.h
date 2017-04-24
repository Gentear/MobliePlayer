//
//  AppDelegate.h
//  MobliePlayer
//
//  Created by zyyt on 17/4/5.
//  Copyright © 2017年 conglei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iPhoneHTTPServerViewController;
@class HTTPServer;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HTTPServer *httpServer;


@end

