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
    [navigationBar setBarTintColor:[UIColor colorWithRed:0.993 green:0.203 blue:0.088 alpha:0.631]];
//    [navigationBar setTintColor:[UIColor whiteColor]];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
//                                       forBarMetrics:UIBarMetricsDefault];
//    navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.extendedLayoutIncludesOpaqueBars = NO;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  这里拦截导航控制器的Push方法，重新定向
 *
 *  @param viewController 控制器
 *  @param animated       是否动画
 */
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
