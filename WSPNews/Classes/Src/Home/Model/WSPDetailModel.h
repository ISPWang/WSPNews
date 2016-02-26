//
//  WSPDetailModel.h
//  WSPNews
//
//  Created by auto on 16/2/3.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Imgs,Keyword_Search,video;
@interface WSPDetailModel : NSObject

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *ec;

@property (nonatomic, strong) NSArray *link;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tid;

@property (nonatomic, strong) NSArray *boboList;

@property (nonatomic, strong) NSArray *apps;

@property (nonatomic, strong) NSArray<Imgs *> *img;

@property (nonatomic, strong) NSArray<video *> *video;

@property (nonatomic, strong) NSArray *topiclist_news;

@property (nonatomic, strong) NSArray *ydbaike;

@property (nonatomic, copy) NSString *docid;

@property (nonatomic, assign) BOOL picnews;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, copy) NSString *template;

@property (nonatomic, copy) NSString *replyBoard;

@property (nonatomic, assign) BOOL hasNext;

@property (nonatomic, strong) NSArray *topiclist;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, strong) NSArray<Keyword_Search *> *keyword_search;

@property (nonatomic, strong) NSArray *votes;

@property (nonatomic, assign) NSInteger threadAgainst;

@property (nonatomic, copy) NSString *voicecomment;

@property (nonatomic, copy) NSString *dkeys;

@property (nonatomic, strong) NSArray *users;

@property (nonatomic, assign) NSInteger threadVote;

@property (nonatomic, strong) NSArray *relative_sys;

@property (nonatomic, copy) NSString *digest;

@end

@interface Imgs : NSObject

@property (nonatomic, copy) NSString *pixel;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *src;

@property (nonatomic, copy) NSString *ref;

@end

@interface video : NSObject
/**
 *  commentid": "BF8QD7OI008535RB",
 "ref": "<!--VIDEO#0-->",
 "topicid": "0085",
 "cover": "http://vimg3.ws.126.net/image/snapshot/2016/2/1/R/VBF8QQH1R.jpg",
 "alt": "习近平走进《新闻联播》演播室体验新闻播报",
 "url_mp4": "http://flv2.bn.netease.com/videolib3/1602/19/jqcrV9423/SD/jqcrV9423-mobile.mp4",
 "broadcast": "in",
 "videosource": "新媒体",
 "commentboard": "videonews_bbs",
 "appurl": "",
 "url_m3u8": "http://flv2.bn.netease.com/videolib3/1602/19/jqcrV9423/SD/jqcrV9423-mobile.mp4",
 "size": ""
 */
@property (nonatomic, copy) NSString *commentid;

@property (nonatomic, copy) NSString *ref;
@property (nonatomic, copy) NSString *topicid;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *alt;
@property (nonatomic, copy) NSString *url_mp4;

@property (nonatomic, copy) NSString *broadcast;
@property (nonatomic, copy) NSString *videosource;
@property (nonatomic, copy) NSString *commentboard;
@property (nonatomic, copy) NSString *appurl;
@property (nonatomic, copy) NSString *url_m3u8;
@property (nonatomic, copy) NSString *size;
@end

@interface Keyword_Search : NSObject

@property (nonatomic, copy) NSString *word;

@end

