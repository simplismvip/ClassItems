//
//  ClassListCollectionCell.h
//  ClassItem
//
//  Created by JM Zhao on 2017/3/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassModel;
@interface ClassListCollectionCell : UICollectionViewCell
@property (nonatomic, strong) ClassModel *model;
@property (nonatomic, assign) BOOL isGrid;
@end
