//
//  WSPShareView.h
//  WSPNews
//
//  Created by auto on 16/2/24.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSPShareView : UIView
//+ (void)showShareViewWithObj:(NSObject *)curObj;
@end

@interface WSPShareView_Item : UIView
@property (strong, nonatomic) NSString *snsName;
@property (copy, nonatomic) void(^clickedBlock)(NSString *snsName);
+ (instancetype)itemWithSnsName:(NSString *)snsName;
+ (CGFloat)itemWidth;
+ (CGFloat)itemHeight;
@end