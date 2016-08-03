//
//  WSPTableViewController.m
//  WSPNews
//
//  Created by auto on 16/1/27.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPTableViewController.h"
#import "WSPNewsDetailViewController.h"
#import "WSPHomeCell.h"
#import "WSPHomeModel.h"
#import "MJRefresh.h"

#import "WSPPhotoModel.h"

#import "WSPPhotoModel.h"

@interface WSPTableViewController () <WSPHomeCellDelegate, MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *newsArrayList;

@property (nonatomic, strong) NSArray *photoName;
@end

@implementation WSPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header = header;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
//    [self loadData];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveThemeChangeNotification) name:kThemeDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFontTypeChangeNotification) name:KFontTypeDidChangeNotification object:nil];
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
    
    [WSPNetWorkTool getWithUrl:allUrlstring success:^(NSDictionary *response) {
        WSPLog(@"%@",response);
        NSString *key = [response.keyEnumerator nextObject];
        //
        NSArray *temArray = response[key];
        NSMutableArray *arrayM = [WSPHomeModel mj_objectArrayWithKeyValuesArray:temArray];
        
        if (type == 1) {
            self.newsArrayList = arrayM;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.newsArrayList addObjectsFromArray:arrayM];
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        WSPLog(@" error = %@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.newsArrayList.count == 0);
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
    
    [self requestId:dict[@"url"]];
    
    
}
- (void)requestId:(NSString *)urlID {
    
    NSString *two = [urlID substringFromIndex:4];
    NSArray *three = [two componentsSeparatedByString:@"|"];
   NSString *requestUrl = [NSString stringWithFormat:@"photo/api/set/%@/%@.json",[three firstObject],[three lastObject]];
    
    [WSPNetWorkTool getWithUrl:requestUrl success:^(id response) {
        
        WSPPhotoModel *photoModel = [WSPPhotoModel mj_objectWithKeyValues:response];
    
        
        NSMutableArray *photoName = [NSMutableArray array];
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;
        
        for (Photos *p  in photoModel.photos) {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:p.imgurl]];
            photo.caption = p.note;
            // Photos
            [photoName addObject:photo];
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
    } fail:^(NSError *error) {
        
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
- (void)didReceiveFontTypeChangeNotification {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
