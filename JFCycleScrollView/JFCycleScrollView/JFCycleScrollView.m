//
//  JFCycleScrollView.m
//  JFCycleScrollView
//
//  Created by Japho on 2018/9/26.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import "JFCycleScrollView.h"
#import "JFCycleCollectionViewCell.h"
#import "UIImageView+WebCache.h"

NSString * const colletionCellID = @"JFCycleColletionCellID";

@interface JFCycleScrollView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *arrImagePaths;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;

@property (nonatomic, strong) UIImageView *imgViewBackground;

@end

@implementation JFCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initializeConfig];
        [self setupMainView];
    }
    
    return self;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame localizationImageNames:(NSArray *)arrImageNames
{
    JFCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.arrLocalizationImageNames = [NSMutableArray arrayWithArray:arrImageNames];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStrings:(NSArray *)arrImageURLStrings
{
    JFCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.arrImageUrlStrings = [NSMutableArray arrayWithArray:arrImageURLStrings];
    return cycleScrollView;
}

- (void)initializeConfig
{
    _pageControlAliment = JFCycleScrollViewPageControlAlimentCenter;
    _autoScrollTimeInterval = 3.0;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _pageControlRightOffset = 0;
    _pageControlBottomOffset = 0;
    _bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    [mainView registerClass:[JFCycleCollectionViewCell class] forCellWithReuseIdentifier:colletionCellID];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    
    [self addSubview:mainView];
    
    _mainView = mainView;
}

#pragma mark - --- Action ---

- (void)setupTimer
{
    [self invalidateTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl
{
    if (_pageControl)
    {
        //重新加载，数据重新刷新
        [_pageControl removeFromSuperview];
    }
    
    if (self.arrImagePaths.count <= 1)
    {
        return;
    }
    
    int indexOfPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.arrImagePaths.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
    pageControl.pageIndicatorTintColor = self.pageDotColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexOfPageControl;
    
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
}

- (void)automaticScroll
{
    if (_totalItemsCount == 0)
    {
        return;
    }
    
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount)
    {
        if (self.infiniteLoop)
        {
            targetIndex = _totalItemsCount * 0.5;
            
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
        return;
    }
    
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex
{
    if (_mainView.frame.size.width == 0 || _mainView.frame.size.height == 0)
    {
        return 0;
    }
    
    int index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.arrImagePaths.count;
}

#pragma mark - --- Life Cycle ---

- (void)layoutSubviews
{
    self.delegate = self.delegate;
    
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    
    if (_mainView.contentOffset.x == 0 && _totalItemsCount)
    {
        int targetIndex = 0;
        
        if (self.infiniteLoop)
        {
            targetIndex = _totalItemsCount * 0.5;
        }
        else
        {
            targetIndex = 0;
        }
        
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeMake(self.arrImagePaths.count * 15, 10);
    
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    CGFloat y = self.mainView.frame.size.height - size.height - 10;
    
    if (self.pageControlAliment == JFCycleScrollViewPageControlAlimentRight)
    {
        x = self.mainView.frame.size.width - size.width - 10;
    }
    
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    
    self.pageControl.frame = pageControlFrame;
    
    if (self.imgViewBackground)
    {
        self.imgViewBackground.frame = self.bounds;
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc
{
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

- (void)disableScrollGesture
{
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]])
        {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
}

#pragma mark - --- public actions ---

- (void)adjustWhenControllerViewWillAppear
{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount)
    {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - --- UICollectionView DataSource ---

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFCycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colletionCellID forIndexPath:indexPath];
    
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    NSString *imagePath = self.arrImagePaths[itemIndex];
    
    if ([imagePath isKindOfClass:[NSString class]])
    {
        if ([imagePath hasPrefix:@"http"])
        {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.imgPlaceholder];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:imagePath];
            
            if (!image)
            {
                image = [UIImage imageWithContentsOfFile:imagePath];
            }
            
            cell.imgView.image = image;
        }
    }
    else if ([imagePath isKindOfClass:[UIImage class]])
    {
        cell.imgView.image = (UIImage *)imagePath;
    }
    
    cell.imgView.contentMode = _bannerImageViewContentMode;
    
    return cell;
}

#pragma mark - --- UICollectionView Delegate ---

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleScrollView:didSelectedItemAtIndex:)])
    {
        [self.delegate cycleScrollView:self didSelectedItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}

#pragma mark - --- UIScrollView Delegate ---

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.arrImagePaths.count)
    {
        return; //解决清除timer偶尔出现的问题
    }
    
    int itemIndex = [self currentIndex];
    int indexOfPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPage = indexOfPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll)
    {
        //用户手势开始拖动时，禁止计时器计时
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll)
    {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.arrImagePaths.count)
    {
        return; //解决清除timer偶尔出现的问题
    }
    
    int itemIndex = [self currentIndex];
    int indexOfPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleSCrollView:didScrollToIndex:)])
    {
        [self.delegate cycleSCrollView:self didScrollToIndex:indexOfPageControl];
    }
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index
{
    if (self.autoScroll)
    {
        [self invalidateTimer];
    }
    
    if (0 == _totalItemsCount) return;
    
    [self scrollToIndex:(int)(_totalItemsCount * 0.5 + index)];
    
    if (self.autoScroll)
    {
        [self setupTimer];
    }
}

#pragma mark - --- Setter && Getter ---

- (void)setImgPlaceholder:(UIImage *)imgPlaceholder
{
    _imgPlaceholder = imgPlaceholder;
    
    if (!self.imgViewBackground)
    {
        UIImageView *imgViewBackground = [UIImageView new];
        imgViewBackground.contentMode = UIViewContentModeScaleAspectFit;
        
        [self insertSubview:imgViewBackground belowSubview:self.mainView];
        
        self.imgViewBackground = imgViewBackground;
    }
}

- (void)setArrLocalizationImageNames:(NSArray *)arrLocalizationImageNames
{
    _arrLocalizationImageNames = arrLocalizationImageNames;
    self.arrImagePaths = [arrLocalizationImageNames copy];
}

- (void)setArrImageUrlStrings:(NSArray *)arrImageUrlStrings
{
    _arrImageUrlStrings = arrImageUrlStrings;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [_arrImageUrlStrings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]])
        {
            urlString = obj;
        }
        else if ([obj isKindOfClass:[NSURL class]])
        {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString)
        {
            [temp addObject:urlString];
        }
    }];
    
    self.arrImagePaths = [temp copy];
}

- (void)setArrImagePaths:(NSArray *)arrImagePaths
{
    [self invalidateTimer];
    
    _arrImagePaths = arrImagePaths;
    
    _totalItemsCount = self.infiniteLoop ? self.arrImagePaths.count * 100 : self.arrImagePaths.count;
    
    if (arrImagePaths.count > 1)
    {
        //一张，零张都不滚动
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }
    else
    {
        self.mainView.scrollEnabled = NO;
        [self invalidateTimer]; //注销计时器，停止循环
    }
    
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    if (self.arrImagePaths.count)
    {
        self.arrImagePaths = self.arrImagePaths;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll)
    {
        [self setupTimer];
    }
}

@end
