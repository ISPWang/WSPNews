//
//  WSPPhotoViewController.m
//  WSPNews
//
//  Created by auto on 16/2/17.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPPhotoViewController.h"
#import "AutoStirViewController.h"
#import "WSPPhotoRequest.h"
#import "WSPPhotoModel.h"
@interface WSPPhotoViewController ()

@end

@implementation WSPPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
//    SPLog(@"---%@",cycleCell.NewsModel.imgextra);
    WSPPhotoRequest *requestPhoto = [WSPPhotoRequest new];
    requestPhoto.photoID = self.photosetID;
    
    [requestPhoto startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSDictionary *resbonseJson = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        WSPPhotoModel *photoModel = [WSPPhotoModel mj_objectWithKeyValues:resbonseJson];
        NSMutableArray *photoName = [NSMutableArray array];
        NSMutableArray *photoString = [NSMutableArray array];
//        NSMutableArray *photoDes = [NSMutableArray array];
        for (Photos *p  in photoModel.photos) {
            [photoName addObject:p.imgurl];
            [photoString addObject:p.note];
        }
        AutoStirViewController *autoPhoto = [[AutoStirViewController alloc] init];
        
        autoPhoto.photoName = photoName;
        autoPhoto.photoStrings = photoString;
        //        autoPhoto.autophotoSize = YES;
        
//        autoPhoto.number = 0; // 从第0张开始播放
        
        autoPhoto.needTimer = NO; // 不自动滚动
        
        autoPhoto.autophotoSize = YES;// 图片根据自身大小自适应
        
        CGFloat width = [[UIScreen mainScreen]bounds].size.width;
        
        CGFloat height = [[UIScreen mainScreen]bounds].size.height;
        
        autoPhoto.frame = CGRectMake(0, 0, width, height * 0.56);// 图片默认大小
        
        autoPhoto.viewFrame = CGRectMake(0, 0, width, [[UIScreen mainScreen]bounds].size.height);// 整个轮播视图的大小,含描述文字所占空间
        
        [self.view addSubview:autoPhoto.view];
        
        [self addChildViewController:autoPhoto];
        
        //        [self.navigationController pushViewController:autoPhoto animated:YES];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
