//
//  WSPDetailBottomCell.h
//  WSPNews
//
//  Created by auto on 16/2/16.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSPReleatedModel.h"
#import "WSPReplyModel.h"

@interface WSPDetailBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sectionHeaderLbl;

@property(nonatomic,assign)BOOL iSCloseing;
@property (nonatomic, strong) WSPReleatedModel *sameNewsEntity;
@property (nonatomic, strong) WSPReplyModel *replyModel;

+ (instancetype)theShareCell;

+ (instancetype)theSectionHeaderCell;

+ (instancetype)theSectionBottomCell;

+ (instancetype)theHotReplyCellWithTableView:(UITableView *)tableView;

+ (instancetype)theContactNewsCell;

+ (instancetype)theCloseCell;

+ (instancetype)theKeywordCell;
@end
