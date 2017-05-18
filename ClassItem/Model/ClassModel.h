//
//  ClassModel.h
//  ClassItem
//
//  Created by JM Zhao on 2017/3/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

//@property (nonatomic, strong) NSString *classImage;
//@property (nonatomic, strong) NSString *className;
//@property (nonatomic, strong) NSString *classTime;
//@property (nonatomic, strong) NSString *classCount;

@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *wname;
@property (nonatomic, assign) float jdPrice;
@property (nonatomic, assign) int totalCount;

@end
