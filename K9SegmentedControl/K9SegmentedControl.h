//
//  K9SegmentedControl.h
//  K9Demo
//
//  Created by K999999999 on 2017/12/12.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, K9SegmentedControlBorderType) {
    
    K9SegmentedControlBorderTypeNone = 0,
    K9SegmentedControlBorderTypeTop = 1 << 0,
    K9SegmentedControlBorderTypeLeft = 1 << 1,
    K9SegmentedControlBorderTypeBottom = 1 << 2,
    K9SegmentedControlBorderTypeRight = 1 << 3
};

@interface K9SegmentedControlStyle : NSObject <NSMutableCopying>

@property (nonatomic, strong)   UIColor                         *segmentColor;
@property (nonatomic, strong)   UIColor                         *highlightedSegmentColor;
@property (nonatomic, strong)   UIColor                         *selectedSegmentColor;

@property (nonatomic, strong)   UIColor                         *titleColor;
@property (nonatomic, strong)   UIColor                         *highlightedTitleColor;
@property (nonatomic, strong)   UIColor                         *selectedTitleColor;

@property (nonatomic, strong)   UIFont                          *titleFont;
@property (nonatomic, strong)   UIFont                          *highlightedTitleFont;
@property (nonatomic, strong)   UIFont                          *selectedTitleFont;

@property (nonatomic, strong)   UIColor                         *indicatorColor;

@property (nonatomic, strong)   UIColor                         *pointColor;
@property (nonatomic)           CGFloat                         pointLength;
@property (nonatomic)           UIOffset                        pointOffset;

@property (nonatomic)           CGFloat                         borderWidth;
@property (nonatomic)           CGFloat                         borderSpacingVertical;
@property (nonatomic)           CGFloat                         borderSpacingHorizontal;
@property (nonatomic, strong)   UIColor                         *borderColor;

@property (nonatomic)           NSTimeInterval                  indicatorAnimationDuration;

@property (nonatomic)           BOOL                            autoAdjustSegmentWidth;
@property (nonatomic)           CGFloat                         autoSegmentSpacing;
@property (nonatomic)           CGFloat                         autoSegmentWidthRatio;

@property (nonatomic)           CGFloat                         segmentWidth;

@property (nonatomic)           BOOL                            autoAdjustIndicatorWidth;
@property (nonatomic)           CGFloat                         autoIndicatorHeight;
@property (nonatomic)           CGFloat                         autoIndicatorSpacing;

@property (nonatomic)           CGSize                          indicatorSize;

- (instancetype)initWithDefaultStyle NS_DESIGNATED_INITIALIZER;

+ (instancetype)shareStyle;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

@class K9SegmentedControl;

@protocol K9SegmentedControlDataSource <NSObject>

@required

- (NSInteger)numberOfSegmentsInSegmentedControl:(K9SegmentedControl *)segmentedControl;

//  Call -attributedTitleForTitle:state: to get attributedTitle or return custom attributedTitle
- (NSAttributedString *)segmentedControl:(K9SegmentedControl *)segmentedControl attributedTitleForState:(UIControlState)state atIndex:(NSInteger)index;

@optional

//  If this method is not implemented, the default is 0.
- (NSInteger)preselectedIndexForSegmentedControl:(K9SegmentedControl *)segmentedControl;

//  If this method is not implemented, the default is mutableCopy of shareStyle.
- (K9SegmentedControlStyle *)styleForSegmentedControl:(K9SegmentedControl *)segmentedControl;

//  If this method is not implemented, the default is NO.
- (BOOL)segmentedControl:(K9SegmentedControl *)segmentedControl shouldShowPointAtIndex:(NSInteger)index;

//  If this method is not implemented, the default is K9SegmentedControlBorderTypeNone.
- (K9SegmentedControlBorderType)borderTypeForSegmentedControl:(K9SegmentedControl *)segmentedControl atIndex:(NSInteger)index;

@end

@protocol K9SegmentedControlDelegate <NSObject>

@optional

//  When indicator animation done
- (void)segmentedControl:(K9SegmentedControl *)segmentedControl didSelectSegmentAtIndex:(NSInteger)index;

//  When indicator animation begin
- (void)segmentedControl:(K9SegmentedControl *)segmentedControl willSelectSegmentAtIndex:(NSInteger)index;

//  You can customize page content offset by pageProgress or change indicatorView
- (void)segmentedControl:(K9SegmentedControl *)segmentedControl shouldChangePageProgress:(float)pageProgress indicator:(UIView *)indicatorView;

//  You can customize indicatorView by this method
- (void)segmentedControl:(K9SegmentedControl *)segmentedControl didConfigIndicator:(UIView *)indicatorView contentView:(UIView *)contentView;

//  You can customize titleLabel or contentView by this method after state change
- (void)segmentedControl:(K9SegmentedControl *)segmentedControl didRefreshSegmentAtIndex:(NSInteger)index state:(UIControlState)state titleLabel:(UILabel *)titleLabel contentView:(UIView *)contentView;

@end


@interface K9SegmentedControl : UIControl

@property (nonatomic, weak)             id <K9SegmentedControlDataSource>   dataSource;
@property (nonatomic, weak)             id <K9SegmentedControlDelegate>     delegate;

@property (nonatomic, readonly)         NSInteger                           segmentCount;
@property (nonatomic, readonly)         NSInteger                           selectedIndex;
@property (nonatomic, strong, readonly) UICollectionView                    *collectionView;
@property (nonatomic, strong, readonly) K9SegmentedControlStyle             *style;

- (NSAttributedString *)attributedTitleForTitle:(NSString *)title state:(UIControlState)state;

- (void)didSelectIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)moveIndicatorToPageProgress:(float)pageProgress;

- (void)reloadData;

@end
