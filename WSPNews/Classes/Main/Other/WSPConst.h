//
//  WSPConst.h
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZDisplayViewController.h"
#import "YTKNetworkConfig.h"
#import "WSPUrlArgumentsFilter.h"


//日志输出宏定义
#ifdef DEBUG
// 调试状态
#define WSPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
// 发布状态
#define WSPLog(...)
#endif

#import "Masonry.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIView+WSPFrame.h"
#import "UIColor+expanded.h"
#import "UIView+BlocksKit.h"

#import "MWPhotoBrowser.h"

#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width


@interface WSPConst : NSObject

@end
