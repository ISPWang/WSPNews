//
//  WSPNewsDetailViewController.h
//  WSPNews
//
//  Created by auto on 16/2/3.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPHomeModel.h"

@interface WSPNewsDetailViewController : UIViewController
@property (nonatomic, strong) WSPHomeModel *newsModel;
@property (nonatomic, assign) NSInteger index;
@end
