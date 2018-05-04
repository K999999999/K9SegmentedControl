//
//  K9SegmentedControl.m
//  K9Demo
//
//  Created by K999999999 on 2017/12/12.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import "K9SegmentedControl.h"
#import "Masonry.h"

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#ifndef K9ColorFromHexWithAlpha
#define K9ColorFromHexWithAlpha(hexValue,a)\
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.f green:((float)((hexValue & 0xFF00) >> 8))/255.f blue:((float)(hexValue & 0xFF))/255.f alpha:a]
#endif

#ifndef K9ColorFromHex
#define K9ColorFromHex(hexValue)\
K9ColorFromHexWithAlpha(hexValue,1.f)
#endif

@implementation K9SegmentedControlStyle

#pragma mark - Life Cycle

- (instancetype)initWithDefaultStyle {
    
    self = [super init];
    if (self) {
        
        _segmentColor = [UIColor whiteColor];
        _highlightedSegmentColor = K9ColorFromHex(0xf2f2f2);
        _selectedSegmentColor = [UIColor whiteColor];
        
        _titleColor = [UIColor blackColor];
        _highlightedTitleColor = [UIColor blackColor];
        _selectedTitleColor = [UIColor blackColor];
        
        _titleFont = [UIFont systemFontOfSize:14.f];
        _highlightedTitleFont = [UIFont systemFontOfSize:14.f];
        _selectedTitleFont = [UIFont boldSystemFontOfSize:14.f];
        
        _indicatorColor = [UIColor blackColor];
        
        _pointColor = [UIColor redColor];
        _pointLength = 8.f;
        _pointOffset = UIOffsetZero;
        
        _borderWidth = 1.f;
        _borderSpacingVertical = 0.f;
        _borderSpacingHorizontal = 0.f;
        _borderColor = [UIColor blackColor];
        
        _indicatorAnimationDuration = .3f;
        
        _autoAdjustSegmentWidth = NO;
        _autoSegmentSpacing = 10.f;
        _autoSegmentWidthRatio = 1.1f;
        
        _segmentWidth = 40.f;
        
        _autoAdjustIndicatorWidth = NO;
        _autoIndicatorHeight = 2.f;
        _autoIndicatorSpacing = 0.f;
        
        _indicatorSize = CGSizeMake(40.f, 2.f);
    }
    return self;
}

+ (instancetype)shareStyle {
    
    static dispatch_once_t onceToken;
    static K9SegmentedControlStyle *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] initWithDefaultStyle];
    });
    return instance;
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

+ (instancetype)new NS_UNAVAILABLE {
    return nil;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    K9SegmentedControlStyle *style = [[[self class] allocWithZone:zone] initWithDefaultStyle];
    style.segmentColor = _segmentColor;
    style.highlightedSegmentColor = _highlightedSegmentColor;
    style.selectedSegmentColor = _selectedSegmentColor;
    style.titleColor =_titleColor;
    style.highlightedTitleColor = _highlightedTitleColor;
    style.selectedTitleColor = _selectedTitleColor;
    style.titleFont = _titleFont;
    style.highlightedTitleFont = _highlightedTitleFont;
    style.selectedTitleFont = _selectedTitleFont;
    style.indicatorColor = _indicatorColor;
    style.pointColor = _pointColor;
    style.pointLength = _pointLength;
    style.pointOffset = _pointOffset;
    style.borderWidth = _borderWidth;
    style.borderSpacingVertical = _borderSpacingVertical;
    style.borderSpacingHorizontal = _borderSpacingHorizontal;
    style.borderColor = _borderColor;
    style.indicatorAnimationDuration = _indicatorAnimationDuration;
    style.autoAdjustSegmentWidth = _autoAdjustSegmentWidth;
    style.autoSegmentSpacing = _autoSegmentSpacing;
    style.autoSegmentWidthRatio = _autoSegmentWidthRatio;
    style.segmentWidth = _segmentWidth;
    style.autoAdjustIndicatorWidth = _autoAdjustIndicatorWidth;
    style.autoIndicatorHeight = _autoIndicatorHeight;
    style.autoIndicatorSpacing = _autoIndicatorSpacing;
    style.indicatorSize = _indicatorSize;
    return style;
}

@end

@interface K9SegmentedControlCell : UICollectionViewCell

@property (nonatomic, strong)   UILabel                         *titleLabel;
@property (nonatomic, strong)   UIView                          *pointView;
@property (nonatomic)           CGFloat                         borderSpacingVertical;
@property (nonatomic)           CGFloat                         borderSpacingHorizontal;
@property (nonatomic)           K9SegmentedControlBorderType    borderType;
@property (nonatomic, strong)   CAShapeLayer                    *shapeLayer;

@end

@implementation K9SegmentedControlCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.frame.size.width <= 0.f
        || self.frame.size.height <= 0.f) {
        return;
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
    self.shapeLayer.frame = rect;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.borderType & K9SegmentedControlBorderTypeTop) {
        
        [path moveToPoint:CGPointMake(self.borderSpacingHorizontal, 0.f)];
        [path addLineToPoint:CGPointMake(rect.size.width - self.borderSpacingHorizontal, 0.f)];
    }
    if (self.borderType & K9SegmentedControlBorderTypeLeft) {
        
        [path moveToPoint:CGPointMake(0.f, self.borderSpacingVertical)];
        [path addLineToPoint:CGPointMake(0.f, rect.size.height - self.borderSpacingVertical)];
    }
    if (self.borderType & K9SegmentedControlBorderTypeBottom) {
        
        [path moveToPoint:CGPointMake(self.borderSpacingHorizontal, rect.size.height)];
        [path addLineToPoint:CGPointMake(rect.size.width - self.borderSpacingHorizontal, rect.size.height)];
    }
    if (self.borderType & K9SegmentedControlBorderTypeRight) {
        
        [path moveToPoint:CGPointMake(rect.size.width, self.borderSpacingVertical)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height - self.borderSpacingVertical)];
    }
    self.shapeLayer.path = path.CGPath;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.titleLabel.attributedText = nil;
    self.pointView.hidden = YES;
}

#pragma mark - Config Views

- (void)configViews {
    
    self.backgroundColor = [UIColor clearColor];
    [self configTitleLabel];
    [self configPointView];
    [self configShapeLayer];
}

- (void)configTitleLabel {
    
    if (self.titleLabel.superview) {
        return;
    }
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.equalTo(self.contentView);
    }];
}

- (void)configPointView {
    
    if (self.pointView.superview) {
        return;
    }
    
    [self.contentView addSubview:self.pointView];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel).with.offset(-4.f);
        make.right.equalTo(self.titleLabel).with.offset(4.f);
        make.width.height.mas_equalTo(8.f);
    }];
}

- (void)configShapeLayer {
    
    if (self.shapeLayer.superlayer) {
        return;
    }
    
    [self.contentView.layer addSublayer:self.shapeLayer];
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)pointView {
    
    if (!_pointView) {
        
        _pointView = [[UIView alloc] init];
        _pointView.hidden = YES;
        _pointView.layer.cornerRadius = 4.f;
    }
    return _pointView;
}

- (CAShapeLayer *)shapeLayer {
    
    if (!_shapeLayer) {
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = 1.f;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    }
    return _shapeLayer;
}

@end;

@interface K9SegmentedControl () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic)           BOOL                        hasFirstReload;

@property (nonatomic)           NSInteger                   segmentCount;
@property (nonatomic)           NSInteger                   selectedIndex;
@property (nonatomic, strong)   K9SegmentedControlStyle     *style;

@property (nonatomic, strong)   NSMutableDictionary         *normalTitleDic;
@property (nonatomic, strong)   NSMutableDictionary         *highlightedTitleDic;
@property (nonatomic, strong)   NSMutableDictionary         *selectedTitleDic;

@property (nonatomic)           CGFloat                     totalWidth;
@property (nonatomic, strong)   NSMutableArray              *segmentXArray;
@property (nonatomic, strong)   NSMutableArray              *widthArray;

@property (nonatomic)           BOOL                        needMove;
@property (nonatomic)           float                       targetIndicatorXProgress;

@property (nonatomic)           float                       fromProgress;
@property (nonatomic)           float                       toProgress;
@property (nonatomic)           float                       animationProgress;

@property (nonatomic, strong)   CADisplayLink               *displayLink;
@property (nonatomic, strong)   UICollectionViewFlowLayout  *flowLayout;
@property (nonatomic, strong)   UICollectionView            *collectionView;
@property (nonatomic, strong)   UIView                      *indicatorView;

@end

@implementation K9SegmentedControl

#pragma mark - Life Cycle

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _hasFirstReload = NO;
        _needMove = NO;
        
        _fromProgress = 0.f;
        _toProgress = 0.f;
        _animationProgress = 0.f;
        _totalWidth = 0.f;
        
        _selectedIndex = 0;
        _style = [[K9SegmentedControlStyle shareStyle] mutableCopy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.hasFirstReload) {
        return;
    }
    
    if (self.frame.size.width <= 0.f
        || self.frame.size.height <= 0.f) {
        return;
    }
    
    self.hasFirstReload = YES;
    self.selectedIndex = [self preselectedIndexForSegment];
    [self reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didConfigIndicator:contentView:)]) {
        [self.delegate segmentedControl:self didConfigIndicator:self.indicatorView contentView:self];
    }
}

- (void)removeFromSuperview {
    
    [super removeFromSuperview];
    
    if (_displayLink) {
        
        _displayLink.paused = YES;
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

#pragma mark - Config Views

- (void)configViews {
    
    [self configCollectionView];
    [self configIndicatorView];
}

- (void)configCollectionView {
    
    if (self.collectionView.superview) {
        return;
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)configIndicatorView {
    
    if (self.indicatorView.superview) {
        return;
    }
    
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.equalTo(self);
        make.width.mas_equalTo(self.style.indicatorSize.width);
        make.height.mas_equalTo(self.style.indicatorSize.height);
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.segmentCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.segmentCount) {
        return nil;
    }
    K9SegmentedControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([K9SegmentedControlCell class]) forIndexPath:indexPath];
    BOOL isSelected = (indexPath.row == self.selectedIndex);
    if (isSelected) {
        
        cell.contentView.backgroundColor = self.style.selectedSegmentColor;
        cell.titleLabel.attributedText = [self.selectedTitleDic objectForKey:@(indexPath.row)];
    } else {
        
        cell.contentView.backgroundColor = self.style.segmentColor;
        cell.titleLabel.attributedText = [self.normalTitleDic objectForKey:@(indexPath.row)];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didRefreshSegmentAtIndex:state:titleLabel:contentView:)]) {
        [self.delegate segmentedControl:self didRefreshSegmentAtIndex:indexPath.row state:isSelected ? UIControlStateSelected : UIControlStateNormal titleLabel:cell.titleLabel contentView:cell.contentView];
    }
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.contentView).with.offset(self.style.autoAdjustSegmentWidth ? self.style.autoSegmentSpacing : 0.f);
        make.right.equalTo(cell.contentView).with.offset(self.style.autoAdjustSegmentWidth ? -self.style.autoSegmentSpacing : 0.f);
    }];
    [self refreshPointForCell:cell indexPath:indexPath];
    [self refreshBorderForCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.widthArray.count) {
        return CGSizeZero;
    }
    return CGSizeMake([self.widthArray[indexPath.row] floatValue], self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    K9SegmentedControlCell *cell = (K9SegmentedControlCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        
        cell.contentView.backgroundColor = self.style.highlightedSegmentColor;
        cell.titleLabel.attributedText = [self.highlightedTitleDic objectForKey:@(indexPath.row)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didRefreshSegmentAtIndex:state:titleLabel:contentView:)]) {
            [self.delegate segmentedControl:self didRefreshSegmentAtIndex:indexPath.row state:UIControlStateHighlighted titleLabel:cell.titleLabel contentView:cell.contentView];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isSelected = (indexPath.row == self.selectedIndex);
    K9SegmentedControlCell *cell = (K9SegmentedControlCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        
        if (isSelected) {
            
            cell.contentView.backgroundColor = self.style.selectedSegmentColor;
            cell.titleLabel.attributedText = [self.selectedTitleDic objectForKey:@(indexPath.row)];
        } else {
            
            cell.contentView.backgroundColor = self.style.segmentColor;
            cell.titleLabel.attributedText = [self.normalTitleDic objectForKey:@(indexPath.row)];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didRefreshSegmentAtIndex:state:titleLabel:contentView:)]) {
            [self.delegate segmentedControl:self didRefreshSegmentAtIndex:indexPath.row state:isSelected ? UIControlStateSelected : UIControlStateNormal titleLabel:cell.titleLabel contentView:cell.contentView];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.segmentCount) {
        return;
    }
    self.selectedIndex = indexPath.row;
    [self shouldSelectIndex:self.selectedIndex animated:YES];
    K9SegmentedControlCell *cell = (K9SegmentedControlCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self refreshPointForCell:cell indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    K9SegmentedControlCell *cell = (K9SegmentedControlCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        
        cell.contentView.backgroundColor = self.style.segmentColor;
        cell.titleLabel.attributedText = [self.normalTitleDic objectForKey:@(indexPath.row)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didRefreshSegmentAtIndex:state:titleLabel:contentView:)]) {
            [self.delegate segmentedControl:self didRefreshSegmentAtIndex:indexPath.row state:UIControlStateNormal titleLabel:cell.titleLabel contentView:cell.contentView];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (!self.needMove) {
        return;
    }
    self.needMove = NO;
    [self moveIndicatorToIndicatorXProgress:self.targetIndicatorXProgress];
}

#pragma mark - Public Methods

- (NSAttributedString *)attributedTitleForTitle:(NSString *)title state:(UIControlState)state {
    
    if (0 == title.length) {
        return nil;
    }
    if (state & UIControlStateHighlighted) {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : self.style.highlightedTitleColor, NSFontAttributeName : self.style.highlightedTitleFont}];
    } else if (state & UIControlStateSelected) {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : self.style.selectedTitleColor, NSFontAttributeName : self.style.selectedTitleFont}];
    } else {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : self.style.titleColor, NSFontAttributeName : self.style.titleFont}];
    }
}

- (void)reloadData {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self handleDataSource];
        [self reloadIndicator];
        [self.collectionView reloadData];
        [self layoutIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self shouldSelectIndex:self.selectedIndex animated:NO];
        });
    });
}

- (void)didSelectIndex:(NSUInteger)index animated:(BOOL)animated {
    
    if (index >= self.segmentCount) {
        return;
    }
    if (index == self.selectedIndex) {
        return;
    }
    
    dispatch_main_async_safe(^{
        
        self.selectedIndex = index;
        [self shouldSelectIndex:index animated:animated];
    });
}

- (void)moveIndicatorToPageProgress:(float)pageProgress {
    
    dispatch_main_async_safe(^{
        
        float indicatorXProgress = [self getIndicatorXProgressForPageProgress:pageProgress];
        [self moveIndicatorToIndicatorXProgress:indicatorXProgress bySelect:NO];
    });
}

#pragma mark - Action Methods

- (void)onDisplayLink:(CADisplayLink *)displayLink {
    
    float deltaPrgress = (displayLink.duration * displayLink.frameInterval) / self.style.indicatorAnimationDuration;
    self.animationProgress += deltaPrgress;
    float indicatorXProgress = (self.toProgress - self.fromProgress) * self.animationProgress + self.fromProgress;
    if (self.animationProgress >= 1.f) {
        
        [self moveIndicatorToIndicatorXProgress:indicatorXProgress bySelect:YES];
        displayLink.paused = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectSegmentAtIndex:)]) {
            [self.delegate segmentedControl:self didSelectSegmentAtIndex:self.selectedIndex];
        }
        [self refreshCellAfterDidSelect];
    } else {
        [self moveIndicatorToIndicatorXProgress:indicatorXProgress bySelect:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:shouldChangePageProgress:indicator:)]) {
        [self.delegate segmentedControl:self shouldChangePageProgress:[self getPageProgressForIndicatorXProgress:indicatorXProgress] indicator:self.indicatorView];
    }
}

#pragma mark - Private Methods

- (void)handleDataSource {
    
    self.style = [self styleForSegment];
    self.segmentCount = [self numberOfSegmentsForSegment];
    [self.normalTitleDic removeAllObjects];
    [self.highlightedTitleDic removeAllObjects];
    [self.selectedTitleDic removeAllObjects];
    self.totalWidth = 0.f;
    [self.segmentXArray removeAllObjects];
    [self.widthArray removeAllObjects];
    for (NSInteger i = 0; i < self.segmentCount; i++) {
        
        NSAttributedString *normalTitle = [self attributedTitleForState:UIControlStateNormal atIndex:i];
        NSAttributedString *highlightedTitle = [self attributedTitleForState:UIControlStateHighlighted atIndex:i];
        NSAttributedString *selectedTitle = [self attributedTitleForState:UIControlStateSelected atIndex:i];
        if (normalTitle.length > 0) {
            [self.normalTitleDic setObject:normalTitle forKey:@(i)];
        }
        if (highlightedTitle.length > 0) {
            [self.highlightedTitleDic setObject:highlightedTitle forKey:@(i)];
        }
        if (selectedTitle.length > 0) {
            [self.selectedTitleDic setObject:selectedTitle forKey:@(i)];
        }
        CGFloat normalWidth = [self getSegmentWidthForAttributedTitle:normalTitle];
        CGFloat highlightedWidth = [self getSegmentWidthForAttributedTitle:highlightedTitle];
        CGFloat selectedWidth = [self getSegmentWidthForAttributedTitle:selectedTitle];
        CGFloat segmentWidth = MAX(normalWidth, MAX(highlightedWidth, selectedWidth));
        [self.segmentXArray addObject:@(self.totalWidth)];
        [self.widthArray addObject:@(segmentWidth)];
        self.totalWidth += segmentWidth;
    }
    if (self.selectedIndex >= self.segmentCount) {
        self.selectedIndex = 0;
    }
}

- (void)reloadIndicator {
    
    self.indicatorView.backgroundColor = self.style.indicatorColor;
    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo([self getIndicatorWidthForIndicatorXProgress:[self getIndicatorXProgressForIndex:self.selectedIndex]]);
        make.height.mas_equalTo([self getIndicatorHeight]);
    }];
}

- (NSInteger)numberOfSegmentsForSegment {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSegmentsInSegmentedControl:)]) {
        return [self.dataSource numberOfSegmentsInSegmentedControl:self];
    }
    return 0;
}

- (NSAttributedString *)attributedTitleForState:(UIControlState)state atIndex:(NSInteger)index {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentedControl:attributedTitleForState:atIndex:)]) {
        return [self.dataSource segmentedControl:self attributedTitleForState:state atIndex:index];
    }
    return nil;
}

- (K9SegmentedControlStyle *)styleForSegment {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(styleForSegmentedControl:)]) {
        return [self.dataSource styleForSegmentedControl:self];
    }
    return [[K9SegmentedControlStyle shareStyle] mutableCopy];
}

- (NSInteger)preselectedIndexForSegment {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(preselectedIndexForSegmentedControl:)]) {
        return [self.dataSource preselectedIndexForSegmentedControl:self];
    }
    return 0;
}

- (BOOL)shouldShowPointAtIndex:(NSInteger)index {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentedControl:shouldShowPointAtIndex:)]) {
        return [self.dataSource segmentedControl:self shouldShowPointAtIndex:index];
    }
    return NO;
}

- (K9SegmentedControlBorderType)borderTypeAtIndex:(NSInteger)index {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(borderTypeForSegmentedControl:atIndex:)]) {
        return [self.dataSource borderTypeForSegmentedControl:self atIndex:index];
    }
    return K9SegmentedControlBorderTypeNone;
}

- (CGFloat)getSegmentWidthForAttributedTitle:(NSAttributedString *)attributedTitle {
    
    if (!self.style.autoAdjustSegmentWidth) {
        return self.style.segmentWidth;
    }
    if (0 == attributedTitle.length) {
        return 0.f;
    }
    return ceil([attributedTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height > 0.f ? self.frame.size.height : 20.f) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width + self.style.autoSegmentSpacing * 2.f);
}

- (CGFloat)getIndicatorHeight {
    return self.style.autoAdjustIndicatorWidth ? self.style.autoIndicatorHeight : self.style.indicatorSize.height;
}

- (CGFloat)getIndicatorWidthForIndicatorXProgress:(float)indicatorXProgress {
    
    if (!self.style.autoAdjustIndicatorWidth) {
        return self.style.indicatorSize.width;
    }
    
    if (0 == self.segmentXArray.count
        || 0 == self.widthArray.count) {
        return 0.f;
    }
    
    CGFloat indicatorX = self.totalWidth * indicatorXProgress;
    NSInteger targetIndex = [self getIndexForIndicatorXProgress:indicatorXProgress];
    if ((targetIndex + 1) >= self.segmentXArray.count
        || (targetIndex + 1) >= self.widthArray.count) {
        return [self.widthArray[targetIndex] floatValue] - self.style.autoIndicatorSpacing * 2.f;
    }
    return (indicatorX - [self.segmentXArray[targetIndex] floatValue]) * ([self.widthArray[targetIndex + 1] floatValue] - [self.widthArray[targetIndex] floatValue]) / [self.widthArray[targetIndex] floatValue] + [self.widthArray[targetIndex] floatValue] - self.style.autoIndicatorSpacing * 2.f;
}

- (float)getIndicatorXProgressForIndex:(NSInteger)index {
    
    if (index >= self.segmentXArray.count
        || index >= self.widthArray.count) {
        return 0.f;
    }
    if (self.totalWidth <= 0.f) {
        return 0.f;
    }
    if (self.style.autoAdjustIndicatorWidth) {
        return ([self.segmentXArray[index] floatValue] + self.style.autoIndicatorSpacing) / self.totalWidth;
    } else {
        return ([self.segmentXArray[index] floatValue] + ([self.widthArray[index] floatValue] - self.style.indicatorSize.width) * .5f) / self.totalWidth;
    }
}

- (NSInteger)getIndexForIndicatorXProgress:(float)indicatorXProgress {
    
    CGFloat indicatorX = self.totalWidth * indicatorXProgress;
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.segmentXArray.count; i++) {
        
        if (indicatorX < [self.segmentXArray[i] floatValue]) {
            
            index = MAX(0, i - 1);
            break;
        }
        if (i == (self.segmentXArray.count - 1)) {
            
            index = i;
            break;
        }
    }
    return index;
}

- (float)getIndicatorXProgressForPageProgress:(float)pageProgress {
    
    NSInteger index = (NSInteger)(pageProgress * (float)self.segmentCount);
    if (index >= self.segmentXArray.count
        || index >= self.widthArray.count) {
        return 0.f;
    }
    float deltaX = (pageProgress - ((float)index / (float)self.segmentCount)) * (float)self.segmentCount * [self.widthArray[index] floatValue];
    if (self.style.autoAdjustIndicatorWidth) {
        return ([self.segmentXArray[index] floatValue] + self.style.autoIndicatorSpacing + deltaX) / self.totalWidth;
    } else {
        return ([self.segmentXArray[index] floatValue] + ([self.widthArray[index] floatValue] - self.style.indicatorSize.width) * .5f + deltaX) / self.totalWidth;
    }
}

- (float)getPageProgressForIndicatorXProgress:(float)indicatorXProgress {
    
    NSInteger index = [self getIndexForIndicatorXProgress:indicatorXProgress];
    if (index >= self.segmentXArray.count
        || index >= self.widthArray.count) {
        return 0.f;
    }
    float deltaX = self.totalWidth * indicatorXProgress - [self.segmentXArray[index] floatValue];
    if (self.style.autoAdjustIndicatorWidth) {
        deltaX -= self.style.autoIndicatorSpacing;
    } else {
        deltaX -= ([self.widthArray[index] floatValue] - self.style.indicatorSize.width) * .5f;
    }
    return ((float)index + deltaX / [self.widthArray[index] floatValue]) / (float)self.segmentCount;
}

- (void)moveIndicatorToIndicatorXProgress:(float)indicatorXProgress bySelect:(BOOL)bySelect {
    
    indicatorXProgress = MAX(0.f, MIN(1.f, indicatorXProgress));
    NSInteger index = self.selectedIndex;
    if (!bySelect) {
        index = [self getIndexForIndicatorXProgress:indicatorXProgress];
    }
    BOOL needScroll = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    K9SegmentedControlCell *cell = (K9SegmentedControlCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        needScroll = YES;
    } else {
        
        CGRect cellFrame = [self convertRect:cell.frame fromView:cell.superview];
        needScroll = !CGRectContainsRect(self.collectionView.frame, cellFrame);
    }
    
    if (needScroll) {
        
        self.needMove = YES;
        self.targetIndicatorXProgress = indicatorXProgress;
        if (bySelect) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        } else {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    } else {
        
        [self moveIndicatorToIndicatorXProgress:indicatorXProgress];
        if (bySelect) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

- (void)moveIndicatorToIndicatorXProgress:(float)indicatorXProgress {
    
    CGRect newFrame = self.indicatorView.frame;
    newFrame.origin.x = indicatorXProgress * self.totalWidth;
    newFrame.size.width = [self getIndicatorWidthForIndicatorXProgress:indicatorXProgress];
    self.indicatorView.frame = [self convertRect:newFrame fromView:self.collectionView];
}

- (void)refreshCellAfterDidSelect {
    
    [self.collectionView reloadData];
    K9SegmentedControlCell *cell = (K9SegmentedControlCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    if (cell) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didRefreshSegmentAtIndex:state:titleLabel:contentView:)]) {
            [self.delegate segmentedControl:self didRefreshSegmentAtIndex:self.selectedIndex state:UIControlStateSelected titleLabel:cell.titleLabel contentView:cell.contentView];
        }
    }
}

- (void)refreshPointForCell:(K9SegmentedControlCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if (!cell) {
        return;
    }
    cell.pointView.backgroundColor = self.style.pointColor;
    cell.pointView.layer.cornerRadius = self.style.pointLength * .5f;
    [cell.pointView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cell.titleLabel).with.offset(-self.style.pointLength * .5f + self.style.pointOffset.vertical);
        make.right.equalTo(cell.titleLabel).with.offset(self.style.pointLength * .5f + self.style.pointOffset.horizontal);
        make.width.height.mas_equalTo(self.style.pointLength);
    }];
    cell.pointView.hidden = ![self shouldShowPointAtIndex:indexPath.row];
}

- (void)refreshBorderForCell:(K9SegmentedControlCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if (!cell) {
        return;
    }
    cell.shapeLayer.lineWidth = self.style.borderWidth;
    cell.shapeLayer.strokeColor = self.style.borderColor.CGColor;
    cell.borderSpacingVertical = self.style.borderSpacingVertical;
    cell.borderSpacingHorizontal = self.style.borderSpacingHorizontal;
    cell.borderType = [self borderTypeAtIndex:indexPath.row];
}

- (void)shouldSelectIndex:(NSUInteger)index animated:(BOOL)animated {
    
    if (0 == self.segmentCount
        || index > self.segmentCount) {
        return;
    }
    
    _displayLink.paused = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:willSelectSegmentAtIndex:)]) {
        [self.delegate segmentedControl:self willSelectSegmentAtIndex:index];
    }
    if (!animated) {
        
        [self moveIndicatorToIndicatorXProgress:[self getIndicatorXProgressForIndex:index] bySelect:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectSegmentAtIndex:)]) {
            [self.delegate segmentedControl:self didSelectSegmentAtIndex:index];
        }
        [self refreshCellAfterDidSelect];
    } else {
        
        self.fromProgress = [self.collectionView convertRect:self.indicatorView.frame fromView:self.indicatorView.superview].origin.x / self.totalWidth;
        self.toProgress = [self getIndicatorXProgressForIndex:index];
        self.animationProgress = 0.f;
        if (self.toProgress - self.fromProgress != 0.f) {
            self.displayLink.paused = NO;
        } else {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControl:didSelectSegmentAtIndex:)]) {
                [self.delegate segmentedControl:self didSelectSegmentAtIndex:index];
            }
            [self refreshCellAfterDidSelect];
        }
    }
}

#pragma mark - Getters

- (NSMutableDictionary *)normalTitleDic {
    
    if (!_normalTitleDic) {
        _normalTitleDic = [NSMutableDictionary dictionary];
    }
    return _normalTitleDic;
}

- (NSMutableDictionary *)highlightedTitleDic {
    
    if (!_highlightedTitleDic) {
        _highlightedTitleDic = [NSMutableDictionary dictionary];
    }
    return _highlightedTitleDic;
}

- (NSMutableDictionary *)selectedTitleDic {
    
    if (!_selectedTitleDic) {
        _selectedTitleDic = [NSMutableDictionary dictionary];
    }
    return _selectedTitleDic;
}

- (NSMutableArray *)segmentXArray {
    
    if (!_segmentXArray) {
        _segmentXArray = [NSMutableArray array];
    }
    return _segmentXArray;
}

- (NSMutableArray *)widthArray {
    
    if (!_widthArray) {
        _widthArray = [NSMutableArray array];
    }
    return _widthArray;
}

- (CADisplayLink *)displayLink {
    
    if (!_displayLink) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.minimumInteritemSpacing = 0.f;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.headerReferenceSize = CGSizeZero;
        _flowLayout.footerReferenceSize = CGSizeZero;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[K9SegmentedControlCell class] forCellWithReuseIdentifier:NSStringFromClass([K9SegmentedControlCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = self.style.indicatorColor;
        _indicatorView.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return _indicatorView;
}

@end
