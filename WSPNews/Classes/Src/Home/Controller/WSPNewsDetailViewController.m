//
//  WSPNewsDetailViewController.m
//  WSPNews
//
//  Created by auto on 16/2/3.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPNewsDetailViewController.h"
#import "WSPNewsDeatilRequest.h"
#import "WSPDetailModel.h"
#import "WSPReleatedModel.h"
#import "JTSImageViewController.h"
#import "WSPDetailBottomCell.h"
#import "WSPReplyRequest.h"
#import "WSPReplyModel.h"



#define NewsDetailControllerClose (self.tabView.contentOffset.y - (self.tabView.contentSize.height - self.view.bounds.size.height + 55) > (100 - 104))
@interface WSPNewsDetailViewController() <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource >
@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic, strong) WSPDetailModel *detailModel;
@property (nonatomic, weak) IBOutlet UITableView *tabView;
@property(nonatomic,strong) NSMutableArray *replyModels;
@property (nonatomic, strong) NSArray *sameNews;
@property (nonatomic, strong) NSArray *keywordSearch;
@property (nonatomic, strong) WSPDetailBottomCell *closeCell;
@property (nonatomic, assign) CGFloat sectionHeight;
@end

@implementation WSPNewsDetailViewController

//- (UITableView *)tabView {
//    if (!_tabView) {
//        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
//        _tabView.delegate = self;
//        _tabView.dataSource = self;
//        [self.view addSubview:_tabView];
//        
//    }
//    return _tabView;
//}
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _webView.scrollView.scrollsToTop = NO;
        _webView.scrollView.scrollEnabled = NO;
//        _webView.scrollView.delegate = self;
//        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)]; // 捏合手势
//        [_webView addGestureRecognizer:pinchRecognizer];
    }
    return _webView;
}
- (void)scale {
    
    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementById('NB-font-size').setAttribute('class', 'NB-%@')",
//                          fontSize];
    NSString *string = @"document.getElementById(\"NB-font-size\").style.fontSize=\"22px\";";//@"document.getElementById(\"NB-font-size\").setAttribute(font-size:38px;color:#000)";
//    @""style","width:760px;font-size:18px;color:#000;background:#C7EDCC""
  NSString *bodyS = [self.webView stringByEvaluatingJavaScriptFromString:string];
    self.sectionHeight = self.webView.scrollView.contentSize.height;
//    CGFloat height = self.webView.scrollView.contentSize.height;
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    
        self.webView.height =  [[self.webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue] + 30;
        [self.tabView reloadData];
    
    
//    self.webView.height = height;//self.webView.scrollView.contentSize.height;
//    WSPLog(@"---%f",height);
//    [self.tabView reloadData];
    WSPLog(@"---%@-----%f",bodyS, height);
}
- (NSMutableArray *)replyModels {
    if (!_replyModels) {
        _replyModels = [NSMutableArray array];
    }
    return _replyModels;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any things for me
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(scale)];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    WSPNewsDeatilRequest *requestHome = [[WSPNewsDeatilRequest alloc] init];
    
    requestHome.docid = self.newsModel.docid;
    
    [requestHome startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            WSPLog(@"------%@",request.responseString);
            self.detailModel = [WSPDetailModel mj_objectWithKeyValues:request.responseJSONObject[self.newsModel.docid]];
            if (self.newsModel.boardid.length < 1) {
                self.newsModel.boardid = self.detailModel.replyBoard;
            }
            self.newsModel.replyCount = @(self.detailModel.replyCount);
            
            [self showInWebView];
            [self sendRequestWithUrl2];
            self.sameNews = [WSPReleatedModel mj_objectArrayWithKeyValuesArray:request.responseJSONObject[self.newsModel.docid][@"relative_sys"]];
             self.keywordSearch = request.responseJSONObject[self.newsModel.docid][@"keyword_search"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        WSPLog(@"加载失败 error");
    }];
    
}
- (void)sendRequestWithUrl2 {
    WSPReplyRequest *requestHome = [[WSPReplyRequest alloc] init];
    
    requestHome.docID = self.newsModel.docid;
    requestHome.boardid = self.newsModel.boardid;
    
    [requestHome startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        
        NSDictionary *resbonseJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (resbonseJson[@"hotPosts"] != [NSNull null]) {
            NSArray *dictarray = resbonseJson[@"hotPosts"];
                    NSLog(@"%ld",dictarray.count);
            
            for (int i = 0; i < dictarray.count; i++) {
                NSDictionary *dict = dictarray[i][@"1"];
                WSPReplyModel *replyModel = [[WSPReplyModel alloc]init];
                replyModel.name = dict[@"n"];
                if (replyModel.name == nil) {
                    replyModel.name = @"外星网友";
                }
                replyModel.address = dict[@"f"];
                replyModel.say = dict[@"b"];
                replyModel.suppose = dict[@"v"];
                replyModel.icon = dict[@"timg"];
                replyModel.rtime = dict[@"t"];
                [self.replyModels addObject:replyModel];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        WSPLog(@"加载失败pinglun error");
    }];
}
- (void)showInWebView {
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"WSPNews.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webView loadHTMLString:html baseURL:nil];
}
- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
//        [body appendString:self.detailModel.body];
        [body appendFormat:@"<div class=\"subtitle\" id=\"NB-font-size\">%@</div>",self.detailModel.body];
    }
    // 遍历img
    for (Imgs *detailImgModel in self.detailModel.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    // <video width="320" height="240" controls="controls" autoplay="autoplay">
//    <source src="/i/movie.mp4" type="video/mp4" />
//    <object data="/i/movie.mp4" width="320" height="240">
//    <embed width="320" height="240" src="/i/movie.swf" />
//    </object>
//    </video>
    
    
    /**
     *  <embed src="http://player.youku.com/player.php/sid/XMzI2NTc4NTMy/v.swf"
     width="480" height="400"
     type="application/x-shockwave-flash">
     </embed>
     */
    for (video *vedios in self.detailModel.video) {
         NSMutableString *vedioHtml = [NSMutableString string];
//        [vedioHtml appendString:@"<video width=\"320\" height=\"240\" controls=\"controls\" autoplay=\"autoplay\">"];
//        [vedioHtml appendFormat:@"<source src=\"%@\" type=\"video/mp4\" />",vedios.url_mp4];
////        [vedioHtml appendFormat:@"<object data=\"%@\" width=\"320\" height=\"240\"><embed width=\"320\" height=\"240\" src=\"/i/movie.swf\" />", vedios.url_mp4];
////        [vedioHtml appendString:@"</object>"];
//        [vedioHtml appendString:@"</video>"];
        [vedioHtml appendFormat:@"<embed src=\"%@\" width=\"360\" height=\"200\"type=\"application/x-shockwave-flash\">",vedios.url_mp4];
        [vedioHtml appendString:@" </embed>"];
        // 替换标记
        [body replaceOccurrencesOfString:vedios.ref withString:vedioHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}
#pragma mark - ******************** 将发出通知时调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        NSInteger begin = range.location + range.length;
        NSString *src = [url substringFromIndex:begin];
//        [self savePictureToAlbum:src];
        [self openImageInApp:src];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webView.height = self.webView.scrollView.contentSize.height;
//    self.sectionHeight = self.webView.scrollView.contentSize.height;
    [self.tabView reloadData];
    WSPLog(@"---%f",self.webView.height);
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '40%'"];//修改百分比即可
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
//    [webView stringByEvaluatingJavaScriptFromString:meta];//(initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放)
}
#pragma mark - ******************** 保存到相册方法
- (void)savePictureToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }]];
     [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)openImageInApp:(NSString *)imageUrlString {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:imageUrlString];
    imageInfo.referenceRect = self.webView.frame;
    imageInfo.referenceView = self.webView.superview;
    imageInfo.altText = @"altText";
    imageInfo.title = @"title";
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView;
    }else if (section == 1){
        WSPDetailBottomCell *head = [WSPDetailBottomCell theSectionHeaderCell];
        head.sectionHeaderLbl.text = @"热门跟帖";
        return head;
    }else if (section == 2){
        WSPDetailBottomCell *head = [WSPDetailBottomCell theSectionHeaderCell];
        head.sectionHeaderLbl.text = @"相关新闻";
        return head;
    }
    return [UIView new];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView.height;
    }else if (section == 1){
        return self.replyModels.count > 0 ? 40 : CGFLOAT_MIN;
    }else if (section == 2){
        return self.sameNews.count > 0 ? 40 : CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2){
        WSPDetailBottomCell *closeCell = [WSPDetailBottomCell theCloseCell];
        self.closeCell = closeCell;
        return closeCell;
    }
    return [[UIView alloc]init];
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2){
        return 64;
    }
    return 15;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1 + self.replyModels.count;
    }else if (section == 2){
        return self.sameNews.count;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
//        if (indexPath.row == self.replyModels.count) {
//            [self performSegueWithIdentifier:@"toReply" sender:nil];
//        }
        WSPLog(@"-------点击评论%@",indexPath);
    }else if (indexPath.section == 2){
        if (indexPath.row > 0) {
            WSPHomeModel *model = [[WSPHomeModel alloc]init];
            model.docid = [self.sameNews[indexPath.row] id];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"WSPNews" bundle:nil];
            WSPNewsDetailViewController *devc = (WSPNewsDetailViewController *)[sb instantiateViewControllerWithIdentifier:@"WSPNewsDetailViewController"];
            devc.newsModel = model;
            [self.navigationController pushViewController:devc animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [WSPDetailBottomCell theShareCell];
    }else if (indexPath.section == 1){
        if (indexPath.row == self.replyModels.count) {
            WSPDetailBottomCell *foot = [WSPDetailBottomCell theSectionBottomCell];
            return foot;
        }else{
            WSPDetailBottomCell *hotreply = [WSPDetailBottomCell theHotReplyCellWithTableView:tableView];
            hotreply.replyModel = self.replyModels[indexPath.row];
            return hotreply;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            WSPDetailBottomCell *cell = [WSPDetailBottomCell theKeywordCell];
            [cell.contentView addSubview:[self addKeywordButton]];
            return cell;
        }else{
            WSPDetailBottomCell *other = [WSPDetailBottomCell theContactNewsCell];
            other.sameNewsEntity = self.sameNews[indexPath.row];
            return other;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126;
    }else if (indexPath.section == 1){
        if (indexPath.row == self.replyModels.count) {
            return 50;
        }else{
            return 110.5;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 81;
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126;
    }else if (indexPath.section == 1){
        if (indexPath.row == self.replyModels.count) {
            return 50;
        }else{
            return 110.5;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 81;
        }
    }
    return CGFLOAT_MIN;
}
- (UIView *)addKeywordButton
{
    CGFloat maxRight = 20;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    for (int i = 0;i<self.keywordSearch.count ; ++i) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(maxRight, 10, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor colorWithRed:74/255 green:133/255 blue:198/255 alpha:1]/*SXRGBColor(74, 133, 198)*/ forState:UIControlStateNormal];
        [button setTitle:self.keywordSearch[i][@"word"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"choose_city_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"choose_city_highlight"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.width += 20;
        button.height = 35;
        [button addTarget:self action:@selector(keywordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        maxRight = button.x + button.width + 10;
        [view addSubview:button];
    }
    return view;
}
- (void)keywordButtonClick:(UIButton *)sender {
    
    WSPLog(@"----点击关键字");
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SXSearchPage *sp = [sb instantiateViewControllerWithIdentifier:@"SXSearchPage"];
//    sp.keyword = sender.titleLabel.text;
//    [self.navigationController pushViewController:sp animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.closeCell) {
        self.closeCell.iSCloseing = NewsDetailControllerClose;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"松手了%f--%f",self.tableView.contentOffset.y,self.tableView.contentSize.height - SXSCREEN_H + 55);
    if (NewsDetailControllerClose) {
        UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        imgV.image = [self getImage];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:imgV];
        [self.navigationController popViewControllerAnimated:NO];
        imgV.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            imgV.frame = CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width/2, 0);
            imgV.alpha = 0.0;
        } completion:^(BOOL finished) {
            [imgV removeFromSuperview];
        }];
    }
}
- (UIImage *)getImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height), NO, 1.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
