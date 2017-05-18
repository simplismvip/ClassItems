//
//  JMContainerController.m
//  ContainerView
//
//  Created by JM Zhao on 2017/3/7.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMContainerController.h"
#import "JMSegmentBar.h"
#import "ClassController.h"
#import "UIView+Extension.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface JMContainerController ()<UIScrollViewDelegate, JMSegmentBarDelegate>
{
    BOOL _isGrid;
}
@property (nonatomic, weak) UIScrollView *scroView;
@property (nonatomic, weak) JMSegmentBar *segmentBar;
@property (nonatomic, assign) CGFloat beginOffsetX;
@end

@implementation JMContainerController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"background"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的课程";
    [self creatSubviews:0];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"product_list_list_btn"] style:(UIBarButtonItemStyleDone) target:self action:@selector(switchAction:)];
    self.navigationItem.rightBarButtonItem = right;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)switchAction:(UIBarButtonItem *)rightItem
{
    _isGrid = !_isGrid;
    if (_isGrid) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"product_list_grid_btn"];
    } else {
        
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"product_list_list_btn"];
    }
    
    ClassController *vc = self.controllers[self.segmentBar.selectIndex];
    [vc refreshData];
}

#pragma mark -- 创建子View
- (void)creatSubviews:(NSInteger)selecIndex
{
    UIScrollView *scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, self.view.width, self.view.height-94)];
    scroView.delegate = self;
    scroView.pagingEnabled = YES;
    scroView.contentSize = CGSizeMake(self.view.width*self.controllers.count, self.view.height-94);
    scroView.showsVerticalScrollIndicator = NO;
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.bounces = NO;
    [self.view addSubview:scroView];
    self.scroView = scroView;
    
    JMSegmentBar *segmentBar = [[JMSegmentBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 30)];
    segmentBar.delegate = self;
    segmentBar.items = self.controllers;
    segmentBar.selectIndex = 0;
    [self.view addSubview:segmentBar];
    self.segmentBar = segmentBar;
}

#pragma mark -- 切换控制机器
- (void)changeController:(NSInteger)index
{
    for (UIViewController *controller in self.controllers) {
        
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    UIViewController *vc = self.controllers[index];
    vc.view.frame = CGRectMake((index)*CGRectGetWidth(self.scroView.frame), 0, CGRectGetWidth(self.scroView.frame), CGRectGetHeight(self.scroView.frame));
    
    [vc willMoveToParentViewController:self];
    [self addChildViewController:vc];
    
    [vc didMoveToParentViewController:self];
    [self.scroView addSubview:vc.view];
    
    // 上一个
    if (index + 1 < self.controllers.count) {
        
        UIViewController *nextController = self.controllers[index + 1];
        UIView *nextView = nextController.view;
        [nextView removeFromSuperview];
        nextView.frame = CGRectMake((index + 1) * CGRectGetWidth(self.scroView.frame), 0, CGRectGetWidth(self.scroView.frame), CGRectGetHeight(self.scroView.frame));
        [self.scroView addSubview:nextView];
    }
    
    // 下一个
    if (index - 1 >= 0) {
        
        UIViewController *previousController = self.controllers[index - 1];
        UIView *previousView = previousController.view;
        [previousView removeFromSuperview];
        [self.scroView addSubview:previousView];
        previousView.frame = CGRectMake((index - 1) * CGRectGetWidth(self.scroView.frame), 0, CGRectGetWidth(self.scroView.frame), CGRectGetHeight(self.scroView.frame));
    }
    
    [self.scroView scrollRectToVisible:vc.view.frame animated:YES];
}

#pragma mark -- UIScrollViewDelegate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!scrollView.isDecelerating) {
        
        self.beginOffsetX = CGRectGetWidth(scrollView.frame) * self.segmentBar.selectIndex;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat targetX = targetContentOffset->x;
    NSInteger selectIndex = targetX/CGRectGetWidth(self.scroView.frame);
    self.segmentBar.selectIndex = selectIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.segmentBar scrollToRate:scrollView.contentOffset.x];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
