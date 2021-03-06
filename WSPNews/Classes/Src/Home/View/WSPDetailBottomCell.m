//
//  WSPDetailBottomCell.m
//  WSPNews
//
//  Created by auto on 16/2/16.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPDetailBottomCell.h"
#import "UIImageView+WebCache.h"

@interface WSPDetailBottomCell()

@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *userLbl;
@property (strong, nonatomic) IBOutlet UILabel *goodLbl;
@property (strong, nonatomic) IBOutlet UILabel *userLocationLbl;
@property (strong, nonatomic) IBOutlet UILabel *replyDetail;


@property (strong, nonatomic) IBOutlet UIImageView *newsIcon;
@property (strong, nonatomic) IBOutlet UILabel *newsTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *newsFromLbl;
@property (strong, nonatomic) IBOutlet UILabel *newsTimeLbl;


@property (strong, nonatomic) IBOutlet UIImageView *closeImg;
@property (strong, nonatomic) IBOutlet UILabel *closeLbl;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end

@implementation WSPDetailBottomCell

+ (instancetype)theShareCell{
    return [[NSBundle mainBundle]loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][0];
}

+ (instancetype)theSectionHeaderCell{
    
    return [[NSBundle mainBundle] loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][1];
}

+ (instancetype)theSectionBottomCell{
    return [[NSBundle mainBundle]loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][2];
}

+ (instancetype)theHotReplyCellWithTableView:(UITableView *)tableView;{
    static NSString *ID = @"horreplycell";
    WSPDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][3];
    }
    return cell;
}

+ (instancetype)theContactNewsCell{
    return [[NSBundle mainBundle]loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][4];
}

+ (instancetype)theCloseCell{
    return [[NSBundle mainBundle]loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][5];
}

+ (instancetype)theKeywordCell{
    return [[NSBundle mainBundle]loadNibNamed:@"WSPDetailBottomCell" owner:nil options:nil][6];
}

-(void)setReplyModel:(WSPReplyModel *)replyModel
{
    _replyModel = replyModel;
    self.userLbl.text = replyModel.name;
    self.userLocationLbl.textColor = kFontColorBlackDark;
    self.goodLbl.textColor = kFontColorBlackDark;
    self.replyDetail.textColor = kFontColorBlackDark;
    self.backgroundColor = kBackgroundColorWhite;
    self.contentView.backgroundColor = kBackgroundColorWhite;
    
    self.userLbl.font = [UIFont fontWithName:KShowFontName size:11];
    self.replyDetail.font = [UIFont fontWithName:KShowFontName size:14];
    
    self.goodLbl.font = [UIFont fontWithName:KShowFontName size:11];
    self.userLocationLbl.font = [UIFont fontWithName:KShowFontName size:11];
    
    if (self.contentView.subviews) {
        UIView *subView = self.contentView.subviews[0];
        subView.backgroundColor = kBackgroundColorWhite;
    }
    
    NSRange range = [replyModel.address rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        replyModel.address = [replyModel.address substringToIndex:range.location];
    }
    
    self.userLocationLbl.text = [NSString stringWithFormat:@"%@ %@",replyModel.address,replyModel.rtime];
    self.replyDetail.text = replyModel.say;
    self.goodLbl.text = [NSString stringWithFormat:@"%@顶",replyModel.suppose];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:replyModel.icon] placeholderImage:[UIImage imageNamed:@"pic_2"]];
    self.iconImg.layer.cornerRadius = self.iconImg.width/2;
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.shouldRasterize = YES;
}

- (void)setSameNewsEntity:(WSPReleatedModel *)sameNewsEntity {
    _sameNewsEntity = sameNewsEntity;
    
    self.newsTitleLbl.textColor = kFontColorBlackDark;
    self.newsFromLbl.textColor = kFontColorBlackDark;
    self.newsTimeLbl.textColor = kFontColorBlackDark;
    
    
    self.newsTitleLbl.font = [UIFont fontWithName:KShowFontName size:14];
    self.newsFromLbl.font = [UIFont fontWithName:KShowFontName size:12];
    
    self.newsTimeLbl.font = [UIFont fontWithName:KShowFontName size:12];
    
    
    self.backgroundColor = kBackgroundColorWhite;
    self.contentView.backgroundColor = kBackgroundColorWhite;
    if (self.contentView.subviews) {
        UIView *subView = self.contentView.subviews[0];
        subView.backgroundColor = kBackgroundColorWhite;
    }
   
    
    [self.newsIcon sd_setImageWithURL:[NSURL URLWithString:sameNewsEntity.imgsrc] placeholderImage:[UIImage imageNamed:@"303"]];
    self.newsIcon.layer.cornerRadius = 2;
    self.newsIcon.layer.masksToBounds = YES;
    self.newsIcon.layer.shouldRasterize = YES;
    self.newsTitleLbl.text = sameNewsEntity.title;
    self.newsFromLbl.text = sameNewsEntity.source;
    self.newsTimeLbl.text = sameNewsEntity.ptime;
    self.newsIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap:)];
    [self.newsIcon addGestureRecognizer:ges];
}
- (void)iconTap:(UITapGestureRecognizer *)ges {
    WSPLog(@"-------头像点击");
}
- (void)setISCloseing:(BOOL)iSCloseing {
    _iSCloseing = iSCloseing;
    self.closeImg.image = [UIImage imageNamed:iSCloseing ? @"newscontent_drag_return" : @"newscontent_drag_arrow"];
    self.closeLbl.text = iSCloseing ? @"松手关闭当前页" : @"上拉关闭当前页" ;
    self.backgroundColor = kBackgroundColorWhite;
    self.contentView.backgroundColor = kBackgroundColorWhite;
    
//    self.backGroundView.backgroundColor = kBackgroundColorWhite;
    self.backGroundView.backgroundColor = [UIColor clearColor];
    self.closeLbl.textColor = kFontColorBlackDark;
}

- (IBAction)shareWeiChat:(id)sender {
    WSPLog(@"-分享---%@",sender);
    UIButton *shareButton = (UIButton *)sender;
    switch (shareButton.tag) {
        case 100:
            WSPLog(@"-分享---微信");
            break;
        case 101:
            WSPLog(@"-分享---微博");
            break;
        case 102:
            WSPLog(@"-分享---易信");
            break;
        case 103:
            WSPLog(@"-分享---更多");
            break;
            
        default:
            break;
    }
}
@end
