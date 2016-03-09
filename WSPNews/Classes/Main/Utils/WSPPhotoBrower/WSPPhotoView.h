//
//  WSPPhotoView.h
//  WSPNews
//
//  Created by auto on 16/3/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSPTapDetectingViewDelegate;

@interface WSPPhotoView : UIView
@property (nonatomic, weak) id <WSPTapDetectingViewDelegate> tapDelegate;
@end

@protocol WSPTapDetectingViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;

@end