//
//  WSPPhoto.h
//  WSPNews
//
//  Created by auto on 16/3/7.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPPhotoProtocol.h"

@interface WSPPhoto : NSObject <WSPPhotoProtocol>

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic) BOOL emptyImage;
@property (nonatomic) BOOL isVideo;

+ (WSPPhoto *)photoWithImage:(UIImage *)image;
+ (WSPPhoto *)photoWithURL:(NSURL *)url;

+ (WSPPhoto *)videoWithURL:(NSURL *)url; // Initialise video with no poster image

- (id)init;
- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;
- (id)initWithVideoURL:(NSURL *)url;
@end
