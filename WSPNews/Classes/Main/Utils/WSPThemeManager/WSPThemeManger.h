//
//  WSPThemeManger.h
//  WSPNews
//
//  Created by auto on 16/3/8.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WSPTheme) {
    WSPThemeDefault, // 白天
    WSPThemeNight,   // 夜晚
};

@interface WSPThemeManger : NSObject
+ (instancetype)manager;
#pragma mark - Index

@property (nonatomic, assign) NSUInteger selectedSectionIndex;
@property (nonatomic, assign) NSUInteger categoriesSelectedSectionIndex;
@property (nonatomic, assign) NSUInteger favoriteSelectedSectionIndex;

#pragma mark - Theme

@property (nonatomic, assign) WSPTheme theme;

@property (nonatomic, assign) BOOL themeAutoChange;

@property (nonatomic, copy) UIColor *navigationBarColor;
@property (nonatomic, copy) UIColor *navigationBarLineColor;
@property (nonatomic, copy) UIColor *navigationBarTintColor;

@property (nonatomic, copy) UIColor *backgroundColorWhite;
@property (nonatomic, copy) UIColor *backgroundColorWhiteDark;

@property (nonatomic, copy) UIColor *lineColorBlackDark;
@property (nonatomic, copy) UIColor *lineColorBlackLight;

@property (nonatomic, copy) UIColor *fontColorBlackDark;
@property (nonatomic, copy) UIColor *fontColorBlackMid;
@property (nonatomic, copy) UIColor *fontColorBlackLight;
@property (nonatomic, copy) UIColor *fontColorBlackBlue;

@property (nonatomic, copy) UIColor *colorBlue;
@property (nonatomic, copy) UIColor *cellHighlightedColor;
@property (nonatomic, copy) UIColor *menuCellHighlightedColor;

@property (nonatomic, assign) CGFloat imageViewAlphaForCurrentTheme;

#pragma mark - Notification

@property (nonatomic, assign) BOOL checkInNotiticationOn;
@property (nonatomic, assign) BOOL newNotificationOn;

#pragma mark - NavigationBar

@property (nonatomic, assign) BOOL navigationBarAutoHidden;

#pragma mark - Traffic

@property (nonatomic, assign) BOOL trafficSaveModeOn;
@property (nonatomic, assign) BOOL trafficSaveModeOnSetting;
@property (nonatomic, assign) BOOL preferHttps;
@end
