//
//  WSPHomeCell.m
//  WSPNews
//
//  Created by auto on 16/1/6.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "WSPHomeCell.h"
#import "UIImageView+WebCache.h"
#import "SDCycleScrollView.h"
@interface WSPHomeCell() <SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *wspTitle;
@property (weak, nonatomic) IBOutlet UILabel *wspSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageOther1;
@property (weak, nonatomic) IBOutlet UIImageView *imageOther2;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *ScroImge;

@end

@implementation WSPHomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setNewsModel:(WSPHomeModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    //    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc]];
    self.backgroundColor             = kBackgroundColorWhite;
    self.contentView.backgroundColor = kBackgroundColorWhite;
    self.wspTitle.textColor          = kFontColorBlackMid;
    
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    self.wspTitle.text = self.NewsModel.title;
    self.wspSubTitle.text = self.NewsModel.digest;
    
    // 如果回复太多就改成几点几万
    CGFloat count =  [self.NewsModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
//    self.lblReply.text = displayCount;
    
    // 多图cell
    if (self.NewsModel.imgextra.count == 2) {
        
        //        [self.imgOther1 sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgextra[0][@"imgsrc"]]];
        //        [self.imgOther2 sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgextra[1][@"imgsrc"]]];
        
        [self.imageOther1 sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgextra[0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
        [self.imageOther2 sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgextra[1][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
        
    }
    if (NewsModel.hasHead && NewsModel.photosetID) {
        NSMutableArray *imageMuarr = [NSMutableArray array];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (NSDictionary *dict  in NewsModel.ads) {
            [imageMuarr addObject:dict[@"imgsrc"]];
            [titleArray addObject:dict[@"title"]];
        }
        self.ScroImge.placeholderImage = [UIImage imageNamed:@"pic_3"];
        self.ScroImge.imageURLStringsGroup = imageMuarr;
        self.ScroImge.titlesGroup = titleArray;
        self.ScroImge.autoScrollTimeInterval = 3.0f;
        self.ScroImge.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        self.ScroImge.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.ScroImge.currentPageDotColor = [UIColor orangeColor];
        self.ScroImge.hidesForSinglePage = YES;
        if (NewsModel.ads.count <=1) {
            self.ScroImge.autoScroll = NO;
        }
        self.ScroImge.delegate = self;
    }
    
}
#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(WSPHomeModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID) {
        return @"TopImageCell";
    }else if (NewsModel.hasHead){
        return @"HeaderImageCell";
    }else if (NewsModel.imgType){
        return @"BigImageCell";
    }else if (NewsModel.imgextra){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}
#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(WSPHomeModel *)NewsModel
{
    if (NewsModel.hasHead && NewsModel.photosetID){
        return 245;
    }else if(NewsModel.hasHead) {
        return 245;
    }else if(NewsModel.imgType) {
        return 170;
    }else if (NewsModel.imgextra){
        return 130;
    }else{
        return 80;
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    WSPLog(@"---%ld",index);
    
    if ([self.delegate respondsToSelector:@selector(cycleCell:didSelectItemAtIndex:)]) {
        [self.delegate cycleCell:self didSelectItemAtIndex:index];
    }
}

@end
