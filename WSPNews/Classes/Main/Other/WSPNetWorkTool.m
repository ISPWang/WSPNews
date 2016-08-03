//
//  WSPNetWorkTool.m
//  WSPNews
//
//  Created by NB1539 on 16/8/3.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPNetWorkTool.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>

static NSString *sg_privateNetworkBaseUrl = nil;

@implementation WSPNetWorkTool
+ (void)updateBaseUrl:(NSString *)baseUrl {
    sg_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return sg_privateNetworkBaseUrl;
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        }else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    return absoluteUrl;
}
#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = nil;;
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    return manager;
}
/**
 * // @property int64_t totalUnitCount;  需要下载文件的总大小
 * // @property int64_t completedUnitCount; 当前已经下载的大小
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSString *)urlSttring
                                             progress:(void (^)(NSProgress *))downloadProgressBlock
                                            cachePath:(NSString *)cachePath
                                    completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler {
    
    NSURL *URL = [NSURL URLWithString:urlSttring];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //下载Task操作
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:response.suggestedFilename]];
        
    } completionHandler:completionHandler];
    
    return  downloadTask;
}
+ (WSPURLSessionTask *)getWithUrl:(NSString *)url
                         success:(WSPResponseSuccess)success
                            fail:(WSPResponseFail)fail {
    return [self getWithUrl:url params:nil success:success fail:fail];
}

+ (WSPURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(WSPResponseSuccess)success
                            fail:(WSPResponseFail)fail {
    return [self getWithUrl:url params:params progress:nil success:success fail:fail];
}
+ (WSPURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(WSPDownloadProgress)progress
                         success:(WSPResponseSuccess)success
                            fail:(WSPResponseFail)fail {
    return [self _requestWithUrl:url refreshCache:NO httpMedth:1 params:params progress:progress success:success fail:fail];
}
+ (WSPURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(WSPResponseSuccess)success
                             fail:(WSPResponseFail)fail {
    return [self postWithUrl:url params:params progress:nil success:success fail:fail];
}
+ (WSPURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(WSPDownloadProgress)progress
                          success:(WSPResponseSuccess)success
                             fail:(WSPResponseFail)fail {
    return [self _requestWithUrl:url refreshCache:NO httpMedth:2 params:params progress:progress success:success fail:fail];
}



+ (WSPURLSessionTask *)_requestWithUrl:(NSString *)url
                         refreshCache:(BOOL)refreshCache
                            httpMedth:(NSUInteger)httpMethod
                               params:(NSDictionary *)params
                             progress:(WSPDownloadProgress)progress
                              success:(WSPResponseSuccess)success
                                 fail:(WSPResponseFail)fail {
    
    AFHTTPSessionManager *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        
        if (absouluteURL == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    WSPURLSessionTask *session = nil;
    
    if (httpMethod == 1) {
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleCallbackWithError:error fail:fail];
        }];
    } else if (httpMethod == 2) {
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleCallbackWithError:error fail:fail];
        }];
    }
    
    
    return session;
}

+ (void)successResponse:(id)responseData callback:(WSPResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}
+ (void)handleCallbackWithError:(NSError *)error fail:(WSPResponseFail)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (fail) {
            fail(error);
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
}
+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}
@end
