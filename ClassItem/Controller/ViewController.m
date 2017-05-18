//
//  ViewController.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/2.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "ViewController.h"
#import "ClassController.h"
#import "JMContainerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ClassController *class1 = [[ClassController alloc] init];
    class1.title = @"公共课程";
    
    ClassController *class2 = [[ClassController alloc] init];
    class2.title = @"私有课程";
    
    JMContainerController *vc = [[JMContainerController alloc] init];
    vc.controllers = [NSMutableArray arrayWithArray:@[class1, class2]];
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
