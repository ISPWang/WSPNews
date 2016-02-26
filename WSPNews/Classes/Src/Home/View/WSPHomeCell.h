//
//  WSPHomeCell.h
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPHomeModel.h"
@class WSPHomeCell;

@protocol WSPHomeCellDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)cycleCell:(WSPHomeCell *)cycleCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface WSPHomeCell : UITableViewCell
@property (nonatomic, strong) WSPHomeModel *NewsModel;
/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(WSPHomeModel *)NewsModel;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(WSPHomeModel *)NewsModel;


@property (nonatomic, weak) id<WSPHomeCellDelegate> delegate;
@end
