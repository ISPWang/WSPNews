//
//  WSPTitleShowLabel.m
//  WSPNews
//
//  Created by auto on 16/1/27.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPTitleShowLabel.h"

@implementation WSPTitleShowLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        self.scale = 0.0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    if (scale == 0) { // 刚开始的白色
        self.textColor = [UIColor colorWithRed:(kCurrentTheme == WSPThemeNight) ? 1 - scale : scale green:(kCurrentTheme == WSPThemeNight) ? 1.0 - scale : 0.0 blue:(kCurrentTheme == WSPThemeNight) ? 1.0 - scale : 0.0 alpha:1];
    } else if (scale > 0 && scale < 1){
        self.textColor = [UIColor colorWithRed:(kCurrentTheme == WSPThemeNight) ? 1 : scale green:(kCurrentTheme == WSPThemeNight) ? 1.0 - scale : 0.0 blue:(kCurrentTheme == WSPThemeNight) ? 1.0 - scale : 0.0 alpha:1];
    } else { // 形变等于1 的时候
        self.textColor = [UIColor colorWithRed:scale green:(kCurrentTheme == WSPThemeNight) ? 1.0 - scale : 0.0 blue:(kCurrentTheme == WSPThemeNight) ? 1.0 - scale : 0.0 alpha:1];
    }
    
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    
}
- (void)didReceiveThemeChangeNotification {
    if (self.scale == 0) {
        self.textColor = (kCurrentTheme == WSPThemeNight) ? [UIColor whiteColor] : [UIColor blackColor];//kFontColorBlackMid;
    }
}
@end
