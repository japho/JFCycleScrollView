//
//  JFCycleScrollView.h
//  JFCycleScrollView
//
//  Created by Japho on 2018/9/26.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JFCycleScrollViewPageControlAliment)
{
    JFCycleScrollViewPageControlAlimentRight,
    JFCycleScrollViewPageControlAlimentCenter
};

@class JFCycleScrollView;

@protocol JFCycleScrollViewDelegate <NSObject>

//点击图片回调
- (void)cycleScrollView:(JFCycleScrollView *)cycleScrollView didSelectedItemAtIndex:(NSInteger)index;
//滚动回调
- (void)cycleSCrollView:(JFCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface JFCycleScrollView : UIView

@property (nonatomic, strong) NSArray *arrImageUrlStrings;
@property (nonatomic, strong) NSArray *arrLocalizationImageNames;

@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
@property (nonatomic, assign) JFCycleScrollViewPageControlAliment pageControlAliment;

@property (nonatomic, weak) id<JFCycleScrollViewDelegate> delegate;

@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;
@property (nonatomic, strong) UIImage *imgPlaceholder;

@property (nonatomic, assign) CGFloat pageControlBottomOffset;
@property (nonatomic, assign) CGFloat pageControlRightOffset;
@property (nonatomic, strong) UIColor *currentPageDotColor;
@property (nonatomic, strong) UIColor *pageDotColor;

@property (nonatomic, assign) BOOL infiniteLoop;    //无限循环
@property (nonatomic, assign) BOOL autoScroll;  //自动滚动

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame localizationImageNames:(NSArray *)arrImageNames;
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStrings:(NSArray *)arrImageURLStrings;


/** 滚动到指定index */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppear;

/** 滚动手势禁用 */
- (void)disableScrollGesture;

/** 清除图片缓存  */
+ (void)clearImagesCache;

@end

NS_ASSUME_NONNULL_END
