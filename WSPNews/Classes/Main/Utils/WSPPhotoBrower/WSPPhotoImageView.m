//
//  WSPPhotoImageView.m
//  WSPNews
//
//  Created by auto on 16/3/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPPhotoImageView.h"

@implementation WSPPhotoImageView

- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        case 3:
            [self handleTripleTap:touch];
            break;
            
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event]; // 下一个响应
}
- (void)handleSingleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)]) {
        [_tapDelegate imageView:self singleTapDetected:touch];
    }
    
}
- (void)handleDoubleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)]) {
        [_tapDelegate imageView:self doubleTapDetected:touch];
    }
    
}
- (void)handleTripleTap:(UITouch *)touch {
    if ([_tapDelegate respondsToSelector:@selector(imageView:tripleTapDetected:)]) {
        [_tapDelegate imageView:self tripleTapDetected:touch];
    }
}
@end
