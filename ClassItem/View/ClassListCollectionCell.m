//
//  ClassListCollectionCell.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "ClassListCollectionCell.h"
#import "ClassModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ClassListCollectionCell ()

@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, strong) UILabel *className;
@property (nonatomic, strong) UILabel *classTime;

@end

@implementation ClassListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = JMColor(244, 244, 244);
        
        _classImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_classImage];
        
        _className = [[UILabel alloc] initWithFrame:CGRectZero];
        _className.numberOfLines = 0;
        _className.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_className];
        
        _classTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _classTime.textColor = [UIColor redColor];
        _classTime.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_classTime];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"长按弹出按钮");
    }
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {
        
        _classImage.frame = CGRectMake(5, 5, self.width-10, self.height - 45);
        _className.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_classImage.frame), CGRectGetWidth(_classImage.frame), 20);
        _classTime.frame = CGRectMake(CGRectGetMinX(_classImage.frame), CGRectGetMaxY(_className.frame), CGRectGetWidth(_classImage.frame), 20);
        
    } else {
        _classImage.frame = CGRectMake(5, 5, self.height-10, self.height-10);
        _className.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, 0, self.width-self.height, self.height/2);
        _classTime.frame = CGRectMake(CGRectGetMaxX(_classImage.frame)+10, CGRectGetMaxY(_className.frame), self.width-self.height, self.height/2);
    }
}

- (void)setModel:(ClassModel *)model
{
    _model = model;
    
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    _className.text = model.wname;
    _classTime.text = [NSString stringWithFormat:@"￥%.2f",model.jdPrice];

//    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.classImage]];
//    _className.text = model.className;
//    _classTime.text = model.classTime;
}

@end
