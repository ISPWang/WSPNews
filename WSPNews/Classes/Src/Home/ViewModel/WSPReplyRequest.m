//
//  WSPReplyRequest.m
//  WSPNews
//
//  Created by auto on 16/2/16.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPReplyRequest.h"

@implementation WSPReplyRequest
- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"api/json/post/list/new/hot/%@/%@/0/10/10/2/2",self.boardid, self.docID];
}
- (NSString *)baseUrl {
    return @"http://comment.api.163.com/";
}
@end
