//
//  WSPShareView.m
//  WSPNews
//
//  Created by auto on 16/2/24.
//  Copyright © 2016年 auto. All rights reserved.
//

#define kCodingShareView_NumPerLine 4
//#define kCodingShareView_NumPerScroll (2 * kCodingShareView_NumPerLine)
#define kCodingShareView_TopHeight 60.0
#define kCodingShareView_BottomHeight 65.0

#define kPaddingLeftWidth 15.0
#define kLoginPaddingLeftWidth 18.0
#define kMySegmentControl_Height 44.0
#define kMySegmentControlIcon_Height 70.0

#import "WSPShareView.h"

@interface WSPShareView()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UIButton *dismissBtn;
@property (strong, nonatomic) UIScrollView *itemsScrollView;
//@property (strong, nonatomic) SMPageControl *myPageControl;

@property (strong, nonatomic) NSArray *shareSnsValues;
@property (weak, nonatomic) NSObject *objToShare;
@end

@implementation WSPShareView

#pragma mark init M
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = kScreen_Bounds;
        
        if (!_bgView) {
            _bgView = ({
                UIView *view = [[UIView alloc] initWithFrame:kScreen_Bounds];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                [view bk_whenTapped:^{
//                    [self p_dismiss];
                }];
                view;
            });
            [self addSubview:_bgView];
        }
        if (!_contentView) {
            _contentView = [UIView new];
            _contentView.backgroundColor = [UIColor colorWithHexString:@"0xF0F0F0"];
            if (!_titleL) {
                _titleL = ({
                    UILabel *label = [UILabel new];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:14];
                    label.textColor = [UIColor colorWithHexString:@"0x666666"];
                    label;
                });
                [_contentView addSubview:_titleL];
                [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_contentView);
                    make.top.equalTo(_contentView).offset(10);
                    make.height.mas_equalTo(20);
                }];
            }
            if (!_dismissBtn) {
                _dismissBtn = ({
                    UIButton *button = [UIButton new];
                    button.backgroundColor = [UIColor whiteColor];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 2.0;
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"0x808080"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateHighlighted];
                    [button addTarget:self action:@selector(p_dismiss) forControlEvents:UIControlEventTouchUpInside];
                    button;
                });
                [_contentView addSubview:_dismissBtn];
                [_dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_contentView).offset(kPaddingLeftWidth);
                    make.right.equalTo(_contentView).offset(-kPaddingLeftWidth);
                    make.bottom.equalTo(_contentView).offset(-kPaddingLeftWidth);
                    make.height.mas_equalTo(40);
                }];
            }
            if (!_itemsScrollView) {
                _itemsScrollView = ({
                    UIScrollView *scrollView = [UIScrollView new];
                    scrollView.pagingEnabled = YES;
                    scrollView.showsHorizontalScrollIndicator = NO;
                    scrollView.showsVerticalScrollIndicator = NO;
                    scrollView;
                });
                [_contentView addSubview:_itemsScrollView];
                [_itemsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_contentView);
                    make.top.equalTo(_contentView).offset(kCodingShareView_TopHeight);
                    make.bottom.equalTo(_contentView).offset(-kCodingShareView_BottomHeight);
                }];
            }
            [_contentView setY:kScreen_Height];
            [self addSubview:_contentView];
        }
    }
    return self;
}

@end
