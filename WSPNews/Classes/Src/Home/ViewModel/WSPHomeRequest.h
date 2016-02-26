//
//  WSPHomeRequest.h
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"
@interface WSPHomeRequest : YTKRequest
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSDictionary *dict;
@end
