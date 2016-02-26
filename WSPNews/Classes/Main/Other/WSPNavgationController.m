//
//  WSPNavgationController.m
//  WSPNews
//
//  Created by auto on 16/1/27.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPNavgationController.h"

@interface WSPNavgationController ()

@end

@implementation WSPNavgationController

+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBarTintColor:[UIColor colorWithRed:0.993 green:0.013 blue:0.088 alpha:0.760]];
    [navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
