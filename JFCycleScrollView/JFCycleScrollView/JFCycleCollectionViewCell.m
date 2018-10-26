//
//  JFCycleCollectionViewCell.m
//  JFCycleScrollView
//
//  Created by Japho on 2018/9/26.
//  Copyright © 2018年 Japho. All rights reserved.
//

#import "JFCycleCollectionViewCell.h"

@implementation JFCycleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupImageView];
    }
    
    return self;
}

- (void)setupImageView
{
    UIImageView *imgView = [[UIImageView alloc] init];
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
}

@end
