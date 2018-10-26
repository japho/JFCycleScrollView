//
//  ViewController.m
//  JFCycleScrollView
//
//  Created by Japho on 2018/9/26.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import "ViewController.h"
#import "JFCycleScrollView.h"

@interface ViewController () <JFCycleScrollViewDelegate>

@end

@implementation ViewController
{
    NSArray *_imagesURLStrings;
    JFCycleScrollView *_customCellScrollViewDemo;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:demoContainerView];
    
    self.title = @"JFCycleScrollView";
    
    
    // 本地图片
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg"
                            ];
    
    // 网络图片
    NSArray *imagesURLStrings = @[
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537962119037&di=f797e864763e3ac2b5ead3bb248e38aa&imgtype=0&src=http%3A%2F%2Fimg0.ph.126.net%2FsMoxyilLsW9CBJD1tkTtFw%3D%3D%2F2788572594290079399.jpg",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537962119036&di=43f025e738b86e2b75e3645db23d08a3&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fae51f3deb48f8c540f531e3130292df5e0fe7f28.jpg",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537962119036&di=21b697b4740686fd22644090302bc43f&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F5ab5c9ea15ce36d3e89aa42f30f33a87e950b116.jpg",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537962119036&di=d9f0666febe8c638f7c7154d2d0d7b56&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F7dd98d1001e939017330982371ec54e736d196f8.jpg",
                                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1537962119036&di=2a7a3f97b706701dfa759393d29afb8d&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F2f738bd4b31c8701180dd7e62d7f9e2f0708ff73.jpg"
                                  ];
    _imagesURLStrings = imagesURLStrings;
    
    CGFloat screenWidth = self.view.bounds.size.width;
    
    JFCycleScrollView *cycleScrollView1 = [JFCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, screenWidth, 180) localizationImageNames:imageNames];
    cycleScrollView1.delegate = self;
    [demoContainerView addSubview:cycleScrollView1];
    
    JFCycleScrollView  *cycleScrollView2 = [JFCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, screenWidth, 180) imageURLStrings:imagesURLStrings];
    cycleScrollView2.delegate = self;
    cycleScrollView2.imgPlaceholder = [UIImage imageNamed:@"placeholder"];
    [demoContainerView addSubview:cycleScrollView2];
}

#pragma mark - --- JFCycleScrollView Delegate ---

- (void)cycleScrollView:(JFCycleScrollView *)cycleScrollView didSelectedItemAtIndex:(NSInteger)index
{
    NSLog(@"------ cycleScrollView did select item at index %ld", (long)index);
}

- (void)cycleSCrollView:(JFCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
     NSLog(@">>>>>> cycleScrollView did scroll to index %ld", (long)index);
}

@end
