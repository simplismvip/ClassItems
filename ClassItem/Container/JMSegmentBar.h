//
//  JMSegmentBar.h
//  ContainerView
//
//  Created by JM Zhao on 2017/3/7.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSegmentBar;

@protocol JMSegmentBarDelegate <NSObject>

- (void)changeController:(NSInteger)index;
@end

@interface JMSegmentBar : UIView

- (void)scrollToRate:(CGFloat)rate;

@property (nonatomic, weak) id<JMSegmentBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *items;
@end
