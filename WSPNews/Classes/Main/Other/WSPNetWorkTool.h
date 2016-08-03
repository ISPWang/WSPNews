//
//  WSPNetWorkTool.h
//  WSPNews
//
//  Created by NB1539 on 16/8/3.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WSPResponseSuccess)(id response);
typedef void(^WSPResponseFail)(NSError *error);
typedef NSURLSessionTask WSPURLSessionTask;
/*!
 *
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^WSPDownloadProgress)(int64_t bytesRead,
                                   int64_t totalBytesRead);

@interface WSPNetWorkTool : NSObject
/*!
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *
 *  @param baseUrl 网络接口的基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

/*!
 *
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param params  接口中所需要的拼接参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (WSPURLSessionTask *)getWithUrl:(NSString *)url
                         success:(WSPResponseSuccess)success
                            fail:(WSPResponseFail)fail;
// 多一个params参数
+ (WSPURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                         success:(WSPResponseSuccess)success
                            fail:(WSPResponseFail)fail;
// 多一个带进度回调
+ (WSPURLSessionTask *)getWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                        progress:(WSPDownloadProgress)progress
                         success:(WSPResponseSuccess)success
                            fail:(WSPResponseFail)fail;
/*!
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (WSPURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(WSPResponseSuccess)success
                             fail:(WSPResponseFail)fail;
+ (WSPURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(WSPDownloadProgress)progress
                          success:(WSPResponseSuccess)success
                             fail:(WSPResponseFail)fail;
/**
 *  下载文件 传入完整路径
 *
 *  @param urlSttring            文件全地址
 *  @param downloadProgressBlock 下载进度
 *  @param cachePath             缓存存取路径
 *  @param completionHandler     完成回调
 *
 *  @return 返回当前下载任务
 */
+ (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSString *)urlSttring
                                             progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                            cachePath:(NSString *)cachePath
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


@end