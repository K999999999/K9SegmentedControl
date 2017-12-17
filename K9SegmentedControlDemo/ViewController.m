//
//  ViewController.m
//  K9SegmentedControl
//
//  Created by K999999999 on 2017/12/15.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "K9SegmentedControl.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, K9SegmentedControlDataSource, K9SegmentedControlDelegate>

@property (nonatomic)           BOOL                        sameWidth;
@property (nonatomic)           BOOL                        scrollByUser;
@property (nonatomic, strong)   NSArray                     *titleArray;
@property (nonatomic, strong)   NSArray                     *colorArray;
@property (nonatomic, strong)   NSMutableDictionary         *pointDic;

@property (nonatomic, strong)   K9SegmentedControl          *segmentedControl;
@property (nonatomic, strong)   UICollectionViewFlowLayout  *flowLayout;
@property (nonatomic, strong)   UICollectionView            *collectionView;
@property (nonatomic, strong)   UISwitch                    *switchView;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.sameWidth = NO;
    self.scrollByUser = NO;
    [self configViews];
}

#pragma mark - Config Views

- (void)configViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configSegmentedControl];
    [self configCollectionView];
    [self configSwitchView];
}

- (void)configSegmentedControl {
    
    if (self.segmentedControl.superview) {
        return;
    }
    
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(50.f);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60.f);
    }];
}

- (void)configCollectionView {
    
    if (self.collectionView.superview) {
        return;
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.height.equalTo(self.view.mas_width);
    }];
}

- (void)configSwitchView {
    
    if (self.switchView.superview) {
        return;
    }
    
    [self.view addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).with.offset(-50.f);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.colorArray.count) {
        return nil;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = self.colorArray[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float progress = scrollView.contentOffset.x / scrollView.contentSize.width;
    [self.segmentedControl moveIndicatorToPageProgress:progress];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollByUser = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        
        self.scrollByUser = NO;
        NSUInteger index = (NSUInteger)(scrollView.contentOffset.x / scrollView.contentSize.width * (float)self.colorArray.count + .5f);
        [self.segmentedControl didSelectIndex:index animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.scrollByUser = NO;
    NSUInteger index = (NSUInteger)(scrollView.contentOffset.x / scrollView.contentSize.width * (float)self.colorArray.count + .5f);
    [self.segmentedControl didSelectIndex:index animated:NO];
}

#pragma mark <K9SegmentedControlDataSource>

- (NSInteger)numberOfSegmentsInSegmentedControl:(K9SegmentedControl *)segmentedControl {
    return self.titleArray.count;
}

- (NSAttributedString *)segmentedControl:(K9SegmentedControl *)segmentedControl attributedTitleForState:(UIControlState)state atIndex:(NSInteger)index {
    return [segmentedControl attributedTitleForTitle:self.titleArray[index] state:state];
}

- (K9SegmentedControlStyle *)styleForSegmentedControl:(K9SegmentedControl *)segmentedControl {
    
    K9SegmentedControlStyle *style = [[K9SegmentedControlStyle alloc] initWithDefaultStyle];
    style.titleColor = [UIColor grayColor];
    if (self.sameWidth) {
        
        style.segmentWidth = floor([UIScreen mainScreen].bounds.size.width / 3.f);
        style.pointOffset = UIOffsetMake(5.f - floor([UIScreen mainScreen].bounds.size.width / 6.f), 4.f);
        style.borderSpacingVertical = 10.f;
    } else {
        
        style.autoAdjustSegmentWidth = YES;
        style.autoAdjustIndicatorWidth = YES;
        style.autoIndicatorSpacing = 10.f;
        style.pointOffset = UIOffsetMake(-2.f, 4.f);
    }
    style.indicatorColor = [UIColor blueColor];
    
    return style;
}

- (BOOL)segmentedControl:(K9SegmentedControl *)segmentedControl shouldShowPointAtIndex:(NSInteger)index {
    return [[self.pointDic objectForKey:@(index)] boolValue];
}

- (K9SegmentedControlBorderType)borderTypeForSegmentedControl:(K9SegmentedControl *)segmentedControl atIndex:(NSInteger)index {
    
    if (self.sameWidth) {
        return (index + 1 != self.titleArray.count) ? K9SegmentedControlBorderTypeTop | K9SegmentedControlBorderTypeBottom | K9SegmentedControlBorderTypeRight : K9SegmentedControlBorderTypeTop | K9SegmentedControlBorderTypeBottom;
    } else {
        return K9SegmentedControlBorderTypeBottom;
    }
}

#pragma mark <K9SegmentedControlDelegate>

- (void)segmentedControl:(K9SegmentedControl *)segmentedControl willSelectSegmentAtIndex:(NSInteger)index {
    [self.pointDic setObject:@(NO) forKey:@(index)];
}

- (void)segmentedControl:(K9SegmentedControl *)segmentedControl didSelectSegmentAtIndex:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)segmentedControl:(K9SegmentedControl *)segmentedControl shouldChangePageProgress:(float)pageProgress indicator:(UIView *)indicatorView {
    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentSize.width * pageProgress, 0.f);
}

#pragma mark - Action Methods

- (void)onSwitchChange:(UISwitch *)sender {
    
    self.sameWidth = sender.isOn;
    _titleArray = nil;
    _colorArray = nil;
    _pointDic = nil;
    [self.segmentedControl reloadData];
    [self.collectionView reloadData];
    
}

#pragma mark - Getters

- (NSArray *)titleArray {
    
    if (!_titleArray) {
        
        if (self.sameWidth) {
            _titleArray = @[@"R", @"B", @"G"];
        } else {
            _titleArray = @[@"black", @"darkGray", @"lightGray", @"white", @"gray", @"red", @"green", @"blue", @"cyan", @"yellow", @"magenta", @"orange", @"purple", @"brown"];
        }
    }
    return _titleArray;
}

- (NSArray *)colorArray {
    
    if (!_colorArray) {
        
        if (self.sameWidth) {
            _colorArray = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
        } else {
            _colorArray = @[[UIColor blackColor], [UIColor darkGrayColor], [UIColor lightGrayColor], [UIColor whiteColor], [UIColor grayColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor]];
        }
    }
    return _colorArray;
}

- (NSMutableDictionary *)pointDic {
    
    if (!_pointDic) {
        
        _pointDic = [NSMutableDictionary dictionary];
        if (self.sameWidth) {
            [_pointDic setObject:@(YES) forKey:@(1)];
        } else {
            [_pointDic setObject:@(YES) forKey:@(5)];
            [_pointDic setObject:@(YES) forKey:@(6)];
            [_pointDic setObject:@(YES) forKey:@(7)];
        }
    }
    return _pointDic;
}

- (K9SegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        
        _segmentedControl = [[K9SegmentedControl alloc] init];
        _segmentedControl.dataSource = self;
        _segmentedControl.delegate = self;
    }
    return _segmentedControl;
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
        _flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UISwitch *)switchView {
    
    if (!_switchView) {
        
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(onSwitchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

@end
