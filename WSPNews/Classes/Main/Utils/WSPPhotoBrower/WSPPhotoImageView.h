//
//  WSPPhotoImageView.h
//  WSPNews
//
//  Created by auto on 16/3/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WSPTapDetectingImageViewDelegate;

@interface WSPPhotoImageView : UIImageView
@property (nonatomic, weak) id <WSPTapDetectingImageViewDelegate> tapDelegate;

@end

@protocol WSPTapDetectingImageViewDelegate <NSObject>

@optional
/** 单点击 */
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
/** 双点击 */
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;

@end