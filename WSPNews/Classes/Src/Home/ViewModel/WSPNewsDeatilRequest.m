//
//  WSPNewsDeatilRequest.m
//  WSPNews
//
//  Created by auto on 16/2/3.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPNewsDeatilRequest.h"

@implementation WSPNewsDeatilRequest
- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"nc/article/%@/full.html",self.docid];
}
- (NSInteger)cacheTimeInSeconds {
    return 60;
}
@end
