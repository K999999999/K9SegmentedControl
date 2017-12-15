//
//  ViewController.m
//  K9SegmentedControl
//
//  Created by K999999999 on 2017/12/15.
//  Copyright © 2017年 K999999999. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "K9SegmentedControl.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, K9SegmentedControlDataSource, K9SegmentedControlDelegate>

@property (nonatomic)           BOOL                        showPoint;
@property (nonatomic)           BOOL                        scrollByUser;
@property (nonatomic, strong)   NSArray                     *titleArray;
@property (nonatomic, strong)   NSArray                     *colorArray;

@property (nonatomic, strong)   K9SegmentedControl          *segmentedControl;
@property (nonatomic, strong)   UICollectionViewFlowLayout  *flowLayout;
@property (nonatomic, strong)   UICollectionView            *collectionView;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.showPoint = YES;
    self.scrollByUser = NO;
    [K9SegmentedControlStyle shareStyle].titleColor = [UIColor grayColor];
    [K9SegmentedControlStyle shareStyle].selectedTitleColor = [UIColor blackColor];
    [K9SegmentedControlStyle shareStyle].autoAdjustSegmentWidth = YES;
    [K9SegmentedControlStyle shareStyle].autoAdjustIndicatorWidth = YES;
    [K9SegmentedControlStyle shareStyle].indicatorColor = [UIColor blueColor];
    [K9SegmentedControlStyle shareStyle].pointOffset = UIOffsetMake(-2.f, 4.f);
    [self configViews];
}

#pragma mark - Config Views

- (void)configViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configSegmentedControl];
    [self configCollectionView];
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

- (BOOL)segmentedControl:(K9SegmentedControl *)segmentedControl shouldShowPointAtIndex:(NSInteger)index {
    
    if (3 == index) {
        return YES;
    }
    if (6 == index) {
        return self.showPoint;
    }
    return NO;
}

#pragma mark <K9SegmentedControlDelegate>

- (void)segmentedControl:(K9SegmentedControl *)segmentedControl willSelectSegmentAtIndex:(NSInteger)index {
    
    if (6 == index) {
        self.showPoint = NO;
    }
}

- (void)segmentedControl:(K9SegmentedControl *)segmentedControl shouldChangePageProgress:(float)pageProgress indicator:(UIView *)indicatorView {
    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentSize.width * pageProgress, 0.f);
}

#pragma mark - Getters

- (NSArray *)titleArray {
    
    if (!_titleArray) {
        _titleArray = @[@"r", @"yellow", @"b", @"orange", @"purple", @"brown", @"gray", @"g", @"black"];
    }
    return _titleArray;
}

- (NSArray *)colorArray {
    
    if (!_colorArray) {
        
        _colorArray = @[[UIColor redColor], [UIColor yellowColor], [UIColor blueColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], [UIColor grayColor], [UIColor greenColor], [UIColor blackColor]];
    }
    return _colorArray;
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

@end
