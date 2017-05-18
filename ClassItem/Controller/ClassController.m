//
//  ClassController.m
//  ClassItem
//
//  Created by JM Zhao on 2017/3/7.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "ClassController.h"

#import "ClassModel.h"
#import "ClassListCollectionCell.h"
#import "NSObject+JMProperty.h"
#import "ClassCollectionViewFlowLayout.h"
#import "ClassCollectionReusableView.h"
#import "UIView+Extension.h"

@interface ClassController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) ClassCollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ClassController

{
    BOOL _isGrid;
}

static NSString *const collectionID = @"cell";
static NSString *const footerID = @"footer";
static NSString *const headerID = @"header";

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {self.dataSource = [NSMutableArray array];}
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isGrid = NO;
    [self.view addSubview:self.collection];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *products = [dict[@"wareInfo"] mutableCopy];
    
    NSInteger step = products.count/7;
    for (int i = 0; i < step; i ++) {
        
        NSRange range = NSMakeRange(i, step);
        NSArray *sections = [products subarrayWithRange:range];
        NSMutableArray *array = [NSMutableArray array];
        for (id obj in sections) {
            
            [array addObject:[ClassModel objectWithDictionary:obj]];
        }
        
        [self.dataSource addObject:array];
    }
}

- (void)refreshData
{
    _isGrid = !_isGrid;
    [self.collection reloadData];
}

- (UICollectionView *)collection
{
    if (!_collection)
    {
        NSLog(@"collection - %@", NSStringFromCGRect(self.view.bounds));
        
        self.collectionLayout = [[ClassCollectionViewFlowLayout alloc] init];
        self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.alwaysBounceVertical = NO;
        [self.view addSubview:_collection];
        
        // 注册
        [_collection registerClass:[ClassListCollectionCell class] forCellWithReuseIdentifier:collectionID];
//        [_collection registerClass:[ClassCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
//        [_collection registerClass:[ClassCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    }
    return _collection;
}


#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    cell.isGrid = _isGrid;
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

//// 返回辅助视图工具
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    ClassCollectionReusableView *header;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        
//        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerID forIndexPath:indexPath];
//        header.text.text = [NSString stringWithFormat:@"我的第%ld个课程", indexPath.section+1];
//        if (header == nil) {header = [[ClassCollectionReusableView alloc] init];}
//        
//    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        
//        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerID forIndexPath:indexPath];
//        if (header == nil) {header = [[ClassCollectionReusableView alloc] init];}
//    }
//    
//    return header;
//}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
}


// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        
        [_collection performBatchUpdates:^{
            
            [_dataSource removeObjectAtIndex:indexPath.row];
            [_collection deleteItemsAtIndexPaths:@[indexPath]];
            
        } completion:nil];
        
    }else if([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

// 动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGrid) {
        
        NSInteger rows = (self.view.width-10*4)/3;
        return CGSizeMake(rows, rows+40);
        
    } else {
        return CGSizeMake(self.view.width-20, (self.view.width-6)/4+20);
    }
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

// 动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//// 动态设置某个分区头视图大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(self.view.width, 30);
//}
//
//// 动态设置某个分区尾视图大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 0);
//}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
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
