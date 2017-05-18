//
//  ClassCollectionReusableView.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/3.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "ClassCollectionReusableView.h"
#import "UIView+Extension.h"
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@implementation ClassCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = JMColor(234, 234, 234);
        
        UILabel *text = [[UILabel alloc] init];
        text.textAlignment = NSTextAlignmentCenter;
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = JMColor(81, 175, 2);
        [self addSubview:text];
        self.text = text;
        
        
        
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        button.backgroundColor = [UIColor grayColor];
//        [button addTarget:self action:@selector(headerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        [self addSubview:button];
//        self.headerBtn = button;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _text.frame = self.bounds;
    _headerBtn.frame = CGRectMake(10, 0, 100, self.height);
}

- (void)headerBtnAction:(UIButton *)sender
{
    NSLog(@"开始点击按钮");
}

@end
