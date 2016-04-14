//
//  WSPDownLoadFontManager.m
//  WSPNews
//
//  Created by auto on 16/3/24.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPDownLoadFontManager.h"

@interface WSPDownLoadFontManager()
@property (nonatomic, copy) NSString *fileName;

@end

@implementation WSPDownLoadFontManager

- (id)initWithFileName:(NSString *)fileName {
    if (self = [super init]) {
        _fileName = fileName;
    }
    return self;
}
- (NSString *)requestUrl {
   return [NSString stringWithFormat:@"/%@", _fileName];
}
- (NSString *)baseUrl {
    return @"http://file.ws.126.net/3g/client/font";
}
//- (BOOL)useCDN {
//    return YES;
//}
//resumableDownloadProgressBlock

- (NSString *)resumableDownloadPath {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:_fileName];
    return filePath;
}
@end
