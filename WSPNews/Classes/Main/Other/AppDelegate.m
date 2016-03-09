//
//  AppDelegate.m
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    WSPUrlArgumentsFilter *urlFilter = [WSPUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
    [config addUrlFilter:urlFilter];
    //    http://api.auto.ifeng.com/app/api/tuan_cont.php?city=110000
//    config.baseUrl = @"http://api.auto.ifeng.com";
    config.baseUrl = @"http://c.m.163.com/";//@"http://dealer.auto.ifeng.com";
    config.cdnUrl = @"http://auto.ifeng.com";
    
    // 修改配置选项
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (kSetting.themeAutoChange && ![[NSUserDefaults standardUserDefaults] objectForKey:@"Theme"]) { // 根据屏幕亮度， 去处理是不是自动夜间模式
        CGFloat brightness = [UIScreen mainScreen].brightness;
        
        if (brightness < 0.2) {
            kSetting.theme = WSPThemeNight;
        } else {
            kSetting.theme = WSPThemeDefault;
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
