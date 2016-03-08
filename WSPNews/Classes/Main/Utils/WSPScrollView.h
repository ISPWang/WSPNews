//
//  WSPScrollView.h
//  WSPNews
//
//  Created by auto on 16/3/4.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSPPhotoView.h"
#import "WSPPhotoImageView.h"

@class WSPPhotoBrowerController;

@interface WSPScrollView : UIScrollView <UIScrollViewDelegate, WSPTapDetectingViewDelegate, WSPTapDetectingImageViewDelegate>


- (id)initWithPhotoBrowser:(WSPPhotoBrowerController *)browser;
@end
