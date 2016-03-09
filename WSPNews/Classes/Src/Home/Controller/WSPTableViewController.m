//
//  WSPTableViewController.m
//  WSPNews
//
//  Created by auto on 16/1/27.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPTableViewController.h"
#import "WSPNewsDetailViewController.h"
#import "AutoStirViewController.h"
#import "WSPHomeCell.h"
#import "WSPHomeModel.h"
#import "MJRefresh.h"
#import "WSPHomeRequest.h"

#import "WSPPhotoRequest.h"
#import "WSPPhotoModel.h"
#import "WSPPhotoViewController.h"

#import "WSPPhotoRequest.h"
#import "WSPPhotoModel.h"

@interface WSPTableViewController () <WSPHomeCellDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *newsArrayList;
@property (nonatomic, strong) WSPHomeRequest *requestHome;

@property (nonatomic, strong) NSArray *photoName;
@end

@implementation WSPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
//    [self.tableView.mj_header beginRefreshing];
    [self loadData];
    
    if ([self.requestHome cacheJson]) {
        NSDictionary * json = [self.requestHome cacheJson];
        WSPLog(@"json = %@", [json class]);
        NSString *key = [json.keyEnumerator nextObject];
        //
        NSArray *temArray = json[key];
        self.newsArrayList = [WSPHomeModel mj_objectArrayWithKeyValuesArray:temArray];
        [self.tableView reloadData];
    }
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData {
    // http://c.m.163.com//nc/article/headline/T1348647853363/0-30.html
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/0-20.html",self.urlString];
    [self loadDataForType:1 withURL:allUrlstring];
}

// ------上拉加载
- (void)loadMoreData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,(self.newsArrayList.count - self.newsArrayList.count%10)];
    //    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,self.arrayList.count];
    [self loadDataForType:2 withURL:allUrlstring];
}
// ------公共方法
- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring {
    WSPHomeRequest *requestHome = [[WSPHomeRequest alloc] init];
    
    self.requestHome = requestHome;
     self.requestHome.urlString = allUrlstring;
    [self.requestHome startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *responseObject = (NSDictionary *)request.responseJSONObject;
        NSString *key = [responseObject.keyEnumerator nextObject];
        //
        NSArray *temArray = responseObject[key];
        NSMutableArray *arrayM = [WSPHomeModel mj_objectArrayWithKeyValuesArray:temArray];
//        WSPLog(@"-chengg---%@----%@",request.responseString, request.responseJSONObject);
        if (type == 1) {
            self.newsArrayList = arrayM;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.newsArrayList addObjectsFromArray:arrayM];
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
        WSPLog(@"是否从缓存取出  %d--是否过期--%d", self.requestHome.isDataFromCache, self.requestHome.isCacheVersionExpired);
    } failure:^(YTKBaseRequest *request) {
        WSPLog(@"----shibai");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.newsArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSPHomeModel *newsModel = self.newsArrayList[indexPath.row];

    NSString *ID = [WSPHomeCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    
    WSPHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    cell.delegate = self;
    return cell;
}
#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSPHomeModel *newsModel = self.newsArrayList[indexPath.row];
    
    CGFloat rowHeight = [WSPHomeCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 80;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = [UIColor yellowColor];
//    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"NewsUrl" ofType:@"plist"];
//    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//   
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"电影" forKey:@"title"];
//    [dict setObject:@"list/T1348648650048" forKey:@"urlString"];
//    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"dict"]) {
//        [data addObject:dict];
//        BOOL save = [data writeToFile:plistPath atomically:YES];
//        WSPLog(@"----%d", save);
//    }
//        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"dict"];
//     WSPLog(@"%@", data);//直接打印数据。
    
    
//    for (NSDictionary *parms in data) {
//        if ([parms[@"title"] isEqualToString:@"电影"]) {
//            WSPLog(@"cishi");
//        }
////
////        } else {
////            [data addObject:dict];
////            [data writeToFile:plistPath atomically:YES];
////        }
//    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[WSPNewsDetailViewController class]]) {
        
        NSInteger x = self.tableView.indexPathForSelectedRow.row;
        WSPNewsDetailViewController *dc = segue.destinationViewController;
        dc.newsModel = self.newsArrayList[x];
        dc.index = self.index;
        dc.title = dc.newsModel.title;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    
}
- (void)cycleCell:(WSPHomeCell *)cycleCell didSelectItemAtIndex:(NSInteger)index {
    WSPLog(@"---%@",cycleCell.NewsModel.imgextra);
    NSDictionary *dict = cycleCell.NewsModel.ads[index];
//    WSPPhotoViewController *autoPhoto = [[WSPPhotoViewController alloc] init];
    
//    autoPhoto.photosetID = dict[@"url"];//cycleCell.NewsModel.photosetID;
//        
//    [self.navigationController pushViewController:autoPhoto animated:YES];
    
    [self requestId:dict[@"url"]];
    
    
}
- (void)requestId:(NSString *)urlID {
    WSPPhotoRequest *requestPhoto = [WSPPhotoRequest new];
    requestPhoto.photoID = urlID;
    
    [requestPhoto startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *resbonseJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        WSPPhotoModel *photoModel = [WSPPhotoModel mj_objectWithKeyValues:resbonseJson];
        
        
        
        
        NSMutableArray *photoName = [NSMutableArray array];
        //        NSMutableArray *photoString = [NSMutableArray array];
        
        
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;
        
        //        NSMutableArray *photoDes = [NSMutableArray array];
        for (Photos *p  in photoModel.photos) {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:p.imgurl]];
            photo.caption = p.note;
            // Photos
            [photoName addObject:photo];
            //            [photoName addObject:p.imgurl];
            //            [photoString addObject:p.note];
        }
        self.photoName = photoName;
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        [browser setCurrentPhotoIndex:0];
        [self.navigationController pushViewController:browser animated:YES];
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoName.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photoName.count)
        return [self.photoName objectAtIndex:index];
    return nil;
}

- (void)didReceiveThemeChangeNotification {
    
    self.tableView.backgroundColor = kBackgroundColorWhite;
    
    [self.tableView reloadData];
}

@end
