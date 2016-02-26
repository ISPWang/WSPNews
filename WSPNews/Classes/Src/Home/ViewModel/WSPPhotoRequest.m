//
//  WSPPhotoRequest.m
//  WSPNews
//
//  Created by auto on 16/2/17.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPPhotoRequest.h"

@implementation WSPPhotoRequest
- (NSString *)requestUrl {
    // 取出关键字
    NSString *one  = self.photoID;
    NSString *two = [one substringFromIndex:4];
    NSArray *three = [two componentsSeparatedByString:@"|"];
    return [NSString stringWithFormat:@"photo/api/set/%@/%@.json",[three firstObject],[three lastObject]];
}
@end
