//
//  WSPHomeRequest.m
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPHomeRequest.h"
//http://dealer.auto.ifeng.com/sms/mobileMessageHander
@implementation WSPHomeRequest
- (NSString *)requestUrl {
    return self.urlString;//@"/sms/mobileMessageHander.do";//@"/app/api/tuan_cont.php";
}
//- (id)requestArgument {
//    return self.dict;//@{
////             @"city" : _cityCode
////             };
//}

- (YTKRequestMethod)requestMethod {  /**< 这个方法是实现是get 请求还是post 还是其他 默认是get 请求  可以不实现这个方法。返回枚举 */
    return YTKRequestMethodGet;
}
- (NSInteger)cacheTimeInSeconds {
    return 2;
}
@end
