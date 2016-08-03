//
//  WSPUrlArgumentsFilter.m
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPUrlArgumentsFilter.h"
//#import "YTKNetworkPrivate.h"

@interface WSPUrlArgumentsFilter()
@property (nonatomic, strong) NSDictionary *arguments;
@end

@implementation WSPUrlArgumentsFilter

+ (WSPUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

//- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
//    return [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
//}
@end
