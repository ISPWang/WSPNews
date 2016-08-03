//
//  WSPConst.h
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZDisplayViewController.h"
#import "AFNetworking.h"


//日志输出宏定义
#ifdef DEBUG
// 调试状态
#define WSPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
// 发布状态
#define WSPLog(...)
#endif

#define RGB(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]

#define kSetting                   [WSPThemeManger manager]

#define kNavigationBarTintColor    kSetting.navigationBarTintColor
#define kNavigationBarColor        kSetting.navigationBarColor
#define kNavigationBarLineColor    kSetting.navigationBarLineColor

#define kBackgroundColorWhite      kSetting.backgroundColorWhite
#define kBackgroundColorWhiteDark  kSetting.backgroundColorWhiteDark

#define kLineColorBlackDark        kSetting.lineColorBlackDark
#define kLineColorBlackLight       kSetting.lineColorBlackLight

#define kFontColorBlackDark        kSetting.fontColorBlackDark
#define kFontColorBlackMid         kSetting.fontColorBlackMid
#define kFontColorBlackLight       kSetting.fontColorBlackLight
#define kFontColorBlackBlue        kSetting.fontColorBlackBlue

#define kColorBlue                 kSetting.colorBlue
#define kCellHighlightedColor      kSetting.cellHighlightedColor
#define kMenuCellHighlightedColor  kSetting.menuCellHighlightedColor

#define KShowFontName              kSetting.chageFontName // 文字名字

#define kCurrentTheme              kSetting.theme

#define KCurrentFontType           kSetting.fontType


#import "Masonry.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIView+WSPFrame.h"
#import "UIColor+expanded.h"
#import "UIView+BlocksKit.h"
#import "WSPNetWorkTool.h"
#import "MWPhotoBrowser.h"

#import "WSPThemeManger.h"

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

static NSString *const kThemeDidChangeNotification = @"ThemeDidChangeNotification";
static NSString *const KFontTypeDidChangeNotification = @"FontTypeDidChangeNotification";

@interface WSPConst : NSObject


@end
