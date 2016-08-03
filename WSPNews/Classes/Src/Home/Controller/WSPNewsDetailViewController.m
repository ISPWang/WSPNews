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


#import "WSPDownLoadFontManager.h"

#import "ZipArchive.h"

#import <CoreText/CoreText.h>

#define NewsDetailControllerClose (self.tabView.contentOffset.y - (self.tabView.contentSize.height - self.view.bounds.size.height + 55) > (100 - 54))
@interface WSPNewsDetailViewController() <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate >
@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic, strong) WSPDetailModel *detailModel;
@property (nonatomic, weak) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property(nonatomic,strong) NSMutableArray *replyModels;
@property (nonatomic, strong) NSArray *sameNews;
@property (nonatomic, strong) NSArray *keywordSearch;
@property (nonatomic, strong) WSPDetailBottomCell *closeCell;
@property (nonatomic, assign) CGFloat sectionHeight;


@property (nonatomic, strong) UIActionSheet *themeAction;

@end

@implementation WSPNewsDetailViewController
#pragma mark - lazyLoads
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _webView.scrollView.scrollsToTop = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.backgroundColor = kBackgroundColorWhite;
        
    }
    return _webView;
}
#pragma mark - Actions
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nightMode:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"夜间模式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"白天",@"夜晚", nil];
    
    [action showInView:self.view];
    self.themeAction = action;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    WSPLog(@"----%ld",buttonIndex);
    if (buttonIndex == 0) {
        kSetting.fontType  = WSPFontTypeSystem;
    } else if (buttonIndex == 1) {
         kSetting.fontType = WSPFontTypeDFWaWaW5;
    }
}
- (IBAction)updateFonts:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"修改字体" message:@"" delegate:self cancelButtonTitle:@"系统" otherButtonTitles:@"娃娃体", nil];
    [alertV show];
    
    NSString *fontPath =  [[self filePath:@"regular"] stringByAppendingString:@"/dfgb_ww5/regular.ttf"];
    
    
//
    if ([[NSFileManager defaultManager] fileExistsAtPath:fontPath]) {
        btn.titleLabel.font = [UIFont fontWithName:KShowFontName size:15];//[UIFont fontWithName:[self customFontWithPath:fontPath size:15] size:15];
        return;
    }
    WSPDownLoadFontManager *down = [[WSPDownLoadFontManager alloc] initWithFileName:@"dfgb_ww5.zip"];
    [down startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        WSPLog(@"---%@---%@",request.responseString,[self filePath:@"dfgb_ww5.zip"]);
        NSString *zipPath = [self filePath:@"dfgb_ww5.zip"];
        NSString *destinationPath = [self filePath:@"regular"];
        
        BOOL result =  [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath delegate:nil];
        WSPLog(@"---%d---%@",result,[self filePath:@"dfgb_ww5.zip"]);
//        NSString *fontPath =  [[self filePath:@"regular"] stringByAppendingString:@"/dfgb_ww5/regular.ttf"];
        btn.titleLabel.font = [UIFont fontWithName:[self customFontWithPath:fontPath] size:15];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        WSPLog(@"---失败");
    }];
}
-(NSString *)customFontWithPath:(NSString*)path
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
//    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return fontName;
}

- (NSString *)filePath:(NSString *)fileName {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    return filePath;
}

- (IBAction)scale {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"修改字体" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"变大",@"正常",@"变小", nil];
    
    [action showInView:self.view];
    
    
    
}
#pragma mark - ActionSheetDelegates
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == self.themeAction) {
        
        if (buttonIndex == 0) {
             WSPLog(@"白天模式");
            kSetting.theme = WSPThemeDefault;
        } else if(buttonIndex == 1) {
             WSPLog(@"夜间模式");
            kSetting.theme = WSPThemeNight;
        }
    } else {
        
        NSArray * stringSize = @[@"120%", @"100%", @"90%"];
        
        NSArray * size =@[@"22px", @"18px", @"16px"];
        if (buttonIndex >= stringSize.count) {
            return;
        }
        NSString *str = [NSString stringWithFormat:@"document.getElementById(\"NB-font-size\").style.fontSize=\"%@\";", size[buttonIndex]];
//        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",stringSize[buttonIndex]];
        
        [self.webView stringByEvaluatingJavaScriptFromString:str];
        self.webView.height =  [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
       CGFloat sizeHeght = self.webView.scrollView.contentSize.height;
        
        [self.tabView reloadData];
        WSPLog(@"----%f---%f",self.webView.height, sizeHeght);
    }

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
       CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        
        self.webView.height = webViewHeight + 20;
//        self.webView.scrollView.contentSize = CGSizeMake(self.webView.width, webViewHeight + 20);
        [self webKitFillBackGroundColor];
        
        [self.tabView reloadData];
    }
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
    [self configerBackGroundColor];
//    self.tabView.delegate   = nil;
//    self.tabView.dataSource = nil;
    self.webView.delegate = self;
//    self.webView.scrollView.delegate = self;
    
//    [self.view addSubview:self.webView]; // 只加载个WebView样式看看
    
    WSPNewsDeatilRequest *requestHome = [[WSPNewsDeatilRequest alloc] init];
    
    requestHome.docid = self.newsModel.docid;
    
    [requestHome startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([jsonDict isKindOfClass:[NSDictionary class]]) {
            WSPLog(@"------%@",request.responseString);
            self.detailModel = [WSPDetailModel mj_objectWithKeyValues:jsonDict[self.newsModel.docid]];
            if (self.newsModel.boardid.length < 1) {
                self.newsModel.boardid = self.detailModel.replyBoard;
            }
            self.newsModel.replyCount = @(self.detailModel.replyCount);
            
            [self showInWebView];
            [self sendRequestWithUrl2];
            self.sameNews = [WSPReleatedModel mj_objectArrayWithKeyValuesArray:jsonDict[self.newsModel.docid][@"relative_sys"]];
             self.keywordSearch = jsonDict[self.newsModel.docid][@"keyword_search"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        WSPLog(@"加载失败 error");
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFontTypeChangeNotification) name:KFontTypeDidChangeNotification object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    /**
     *  监听 webView 中 scrollView的内容变化
     */
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)viewWillDisappear:(BOOL)antimated{
    [super viewWillDisappear:antimated];
    [self.webView.scrollView removeObserver:self
                                 forKeyPath:@"contentSize" context:nil];
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
                    replyModel.name = @"未知网友";
                }
                replyModel.address = dict[@"f"];
                replyModel.say = dict[@"b"];
                replyModel.suppose = dict[@"v"];
                replyModel.icon = dict[@"timg"];
                replyModel.rtime = dict[@"t"];
                [self.replyModels addObject:replyModel];
            }
            
            [self.tabView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        WSPLog(@"加载失败评论失败");
    }];
}
#pragma mark - webView 加载html 标签
- (void)showInWebView {
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<!DOCTYPE HTML>"];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"WSPNews.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}
- (NSString *)touchBody {
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>" ,self.detailModel.title];
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
       NSString *photoStr = [[NSBundle mainBundle] pathForResource:@"placeHolder_1_640 360.png" ofType:nil];
//        [imgHtml appendFormat:@"<img class=\"img-parent\" onload=\"%@\"  width=\"%f\" height=\"%f\" src=\"%@\"/>",onload,width,height,photoStr/*,detailImgModel.src*/];
//        [imgHtml appendFormat:@"<img src=images/1.png>/"];
        [imgHtml appendFormat:@"<img class=\"image-parent\" id=\"img\" onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\" data-original=\"%@\">",onload,width,height,photoStr,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        
    }
    
    NSString *js = @"<script type=\"text/javascript\" src=\"jquery-1.12.1.min.js\"></script>\
    <script type=\"text/javascript\" src=\"jquery.lazyload.min.js\"></script>\
    <script type=\"text/javascript\" charset=\"utf-8\">\
    jQuery(document).ready(function() {\
    \
    $(\"img.image-parent\").lazyload({\
    effect : \"fadeIn\",\
    effectspeed:1000,\
    failurelimit : 5,\
    threshold:200\
    });\
    });\
    </script>";
    [body appendString:js];
    
    /*
    NSString *funJs = @"<script type=\"text/javascript\"> \
    (function (){ \
    var imageList = document.getElementsByTagName(\"img\");\
    for(var i = 0; i < imageList.length; i++){ \
    var image = imageList[i]; \
    image.href = image.src; \
    image.src = \"http://y2.ifengimg.com/auto/image/2016/0302/033330702_240.jpg\"; \
    image.alt = \"点击加载图片\"; \
    image.onclick = function(){ \
    if(this.src != this.href) {\
    this.src = this.href; \
    return false; \
    } else { \
    document.location = this.src; \
    return false; \
    } \
    } \
    } \
    }()); \
    </script>";
    [body appendString:funJs];
    */
    NSString *videoOnload = @"this.onclick = function() {"
    "  window.location.href = 'sx:videosrc=' +this.src;"
    "};";
    // <video src="http://v6.pstatp.com/origin/11785/921826846?Signature=FrWqfzZseH5XygofzJjA29lH4Yo%3D&amp;Expires=1458806833&amp;KSSAccessKeyId=qh0h9TdcEMrm1VlR2ad/" type="video/mp4" controls="" poster="http://p3.pstatp.com/large/2f8000ee7abd0d80d35" preload="none" style="width:100%;height:100%;">
    for (video *vedios in self.detailModel.video) {
        
        [body replaceOccurrencesOfString:vedios.ref withString:[NSString stringWithFormat:@"<video onload=\"%@\" src=\"%@\" width=\"%f\" height=\"200\" poster=\"%@\" type=\"video/mp4\" preload=\"none\"></video>",videoOnload ,vedios.url_mp4, _webView.bounds.size.width - 16,vedios.cover] options:0 range:NSMakeRange(0, [body length])];
        
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
    if ([url containsString:@"sx:videosrc"]) {
        WSPLog(@"视频资源----%@",url);
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webView.height = self.webView.scrollView.contentSize.height;
    
//    self.webView.height =  [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 20;
//    self.sectionHeight = self.webView.scrollView.contentSize.height;
    

//    [self.tabView reloadData];
//    WSPLog(@"---%f---%@",self.webView.height, laString);
//    NSString *str1 = [NSString stringWithFormat:@"document.getElementById(\"NB-font-size\").style.fontFamily=\"%@\";", KShowFontName];
//    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontFamily= '%@'",KShowFontName];
//    [self.webView stringByEvaluatingJavaScriptFromString:str1];
//    [self.webView stringByEvaluatingJavaScriptFromString:str];
}
#pragma mark - ******************** 保存到相册方法
- (void)savePictureToAlbum:(NSString *)src {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.webView;
    }else if (section == 1){
        WSPDetailBottomCell *head = [WSPDetailBottomCell theSectionHeaderCell];
//        head.backgroundColor = kBackgroundColorWhite;
        head.contentView.backgroundColor = kBackgroundColorWhite;
        if (head.contentView.subviews) {
            UIView *subView = head.contentView.subviews[0];
            subView.backgroundColor = kBackgroundColorWhite;
        }
        head.sectionHeaderLbl.text = @"热门跟帖";
        return head;
    }else if (section == 2){
        WSPDetailBottomCell *head = [WSPDetailBottomCell theSectionHeaderCell];
        head.backgroundColor = kBackgroundColorWhite;
        head.contentView.backgroundColor = kBackgroundColorWhite;
        if (head.contentView.subviews) {
            UIView *subView = head.contentView.subviews[0];
            subView.backgroundColor = kBackgroundColorWhite;
        }
        head.sectionHeaderLbl.text = @"相关新闻";
        return head;
    }
    return [UIView new];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.webView.height;//scrollView.contentSize.height;
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
    return nil;//[[UIView alloc]init];
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2){
        return 64;
    }
    return 15;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        WSPDetailBottomCell *shareCell = [WSPDetailBottomCell theShareCell];
        shareCell.contentView.backgroundColor = kBackgroundColorWhite;
        if (shareCell.contentView.subviews) {
            UIView *subView = shareCell.contentView.subviews[0];
            subView.backgroundColor = kBackgroundColorWhite;
        }
        return shareCell;
    }else if (indexPath.section == 1){
        if (indexPath.row == self.replyModels.count) {
            WSPDetailBottomCell *foot = [WSPDetailBottomCell theSectionBottomCell];
            foot.contentView.backgroundColor = kBackgroundColorWhite;
            if (foot.contentView.subviews) {
                UIView *subView = foot.contentView.subviews[0];
                subView.backgroundColor = kBackgroundColorWhite;
            }
            return foot;
        }else{
            WSPDetailBottomCell *hotreply = [WSPDetailBottomCell theHotReplyCellWithTableView:tableView];
            hotreply.replyModel = self.replyModels[indexPath.row];
            return hotreply;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0 && self.keywordSearch.count > 0) {
            WSPDetailBottomCell *cell = [WSPDetailBottomCell theKeywordCell];
            cell.contentView.backgroundColor = kBackgroundColorWhite;
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
        if (indexPath.row == 0 && self.keywordSearch.count > 0) {
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
        if (indexPath.row == 0 && self.keywordSearch.count > 0) {
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
    view.backgroundColor = kBackgroundColorWhite;
    for (int i = 0;i<self.keywordSearch.count ; ++i) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(maxRight, 10, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:kFontColorBlackDark/*[UIColor colorWithRed:74/255 green:133/255 blue:198/255 alpha:1]*/ forState:UIControlStateNormal];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tabView) {
        if (self.closeCell) {
            self.closeCell.iSCloseing = NewsDetailControllerClose;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.tabView) {
        if (NewsDetailControllerClose) {
            WSPLog(@"----%d",NewsDetailControllerClose);
            
            UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            imgV.image = [self getImage];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:imgV];
            [self.navigationController popViewControllerAnimated:NO];
            
            [UIView animateWithDuration:0.3 animations:^{
                imgV.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/2, 10);
                if (imgV) {
                    imgV.alpha = 0.0;
                }
                
            } completion:^(BOOL finished) {
                [imgV removeFromSuperview];
            }];
        }
    }
    
}
- (UIImage *)getImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height), NO, 1.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    WSPLog(@"----%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    [self configerBackGroundColor];
    [self webKitFillBackGroundColor];
    [self.tabView reloadData];
}
- (void)didReceiveFontTypeChangeNotification {
    if (KCurrentFontType == WSPFontTypeSystem) {
        NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontFamily= '%@'",[WSPThemeManger manager].chageFontName];
        NSString *str1 = [NSString stringWithFormat:@"document.getElementById(\"NB-font-size\").style.fontFamily=\"%@\";", @".SFUIText-Regular"];
//        UIPickerView
       NSString *gaiString =  [self.webView stringByEvaluatingJavaScriptFromString:str1];
       [self.webView stringByEvaluatingJavaScriptFromString:str];
        WSPLog(@"----%@",gaiString);
        
    } else {
        NSString *str = [NSString stringWithFormat:@"document.body.style.fontFamily= '%@'",[WSPThemeManger manager].chageFontName];
        NSString *str1 = [NSString stringWithFormat:@"document.getElementById(\"NB-font-size\").style.fontFamily=\"%@\";", [WSPThemeManger manager].chageFontName];
        
        [self.webView stringByEvaluatingJavaScriptFromString:str1];
       NSString *gaiString = [self.webView stringByEvaluatingJavaScriptFromString:str];
         WSPLog(@"----%@",gaiString);
    }
    
    [self.tabView reloadData];
}
// 颜色切换
- (void)webKitFillBackGroundColor {
    if (kCurrentTheme == WSPThemeDefault) {
        [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
        [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'"];
    } else {
        [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
        [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#989898'"];
    }
}
- (void)configerBackGroundColor {
    self.tabView.backgroundColor = kBackgroundColorWhite;
    self.webView.backgroundColor = kBackgroundColorWhite;
    self.view.backgroundColor    = kBackgroundColorWhite;
    self.topBarView.backgroundColor = kBackgroundColorWhite;
    [self.backButton setTitleColor:kFontColorBlackMid forState:UIControlStateNormal];
}

@end
