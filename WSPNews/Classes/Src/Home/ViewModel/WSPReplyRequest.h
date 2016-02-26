//
//  WSPReplyRequest.h
//  WSPNews
//
//  Created by auto on 16/2/16.
//  Copyright © 2016年 auto. All rights reserved.
//

//#import <YTKNetwork/YTKRequest.h>
#import "YTKRequest.h"
@interface WSPReplyRequest : YTKRequest
@property (nonatomic, copy) NSString *boardid;
@property (nonatomic, copy) NSString *docID;
@end
