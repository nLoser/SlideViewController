//
//  ViewController.m
//  SlideViewController
//
//  Created by LV on 16/7/27.
//  Copyright © 2016年 LV. All rights reserved.
//

#import "ViewController.h"
#import "SampleViewController.h"

#define scWidth [UIScreen mainScreen].bounds.size.width
#define scHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray * itemArray;
@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) NSMutableArray<SampleViewController *> * vcArray;
@property (nonatomic, strong) SampleViewController * currentVC;
@property (nonatomic, assign) NSInteger currentVCIndex;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadTitleArray];
    [self loadBaseUI];
}

- (void)loadTitleArray
{
    _itemArray = [NSMutableArray arrayWithObjects:@"头条",@"今日",@"焦点",@"推荐",@"热门",@"随笔",@"你喜欢",@"就好",@"再多",@"下雨了",@"惊悚",@"迟疑",@"周星驰",@"大话西游",@"搞笑", nil];
    _vcArray = [NSMutableArray array];
}

- (void)loadBaseUI {
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, scWidth, scHeight-64)];
    _contentView.backgroundColor = [UIColor grayColor];
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    _contentView.contentSize = CGSizeMake(scWidth * _itemArray.count, scHeight-64);
    [self.view addSubview:_contentView];
    
    [self addSubControllers];
}

-(void)addSubControllers
{
    for (NSInteger i = 0; i < _itemArray.count; i ++) {
        SampleViewController * vc = [[SampleViewController alloc] init];
        vc.vcTag = i;
        vc.view.frame = CGRectMake(scWidth*i, 0, scWidth, scHeight - 64);
        vc.view.backgroundColor = [UIColor colorWithRed:(random()%255+1)/255.0 green:(random()%255+1)/255.0 blue:(random()%255+1)/255.0 alpha:1];
        [_vcArray addObject:vc];
    }
    
#if 1
    SampleViewController * tempVC = [self getVCByIndex:0];
    [self addChildViewController:tempVC];
    [tempVC reloadValue:@[_itemArray[tempVC.vcTag]]];
    
    SampleViewController * tempNextVC = [self getVCByIndex:1];
    [self addChildViewController:tempNextVC];
    [tempNextVC reloadValue:@[_itemArray[tempNextVC.vcTag]]];
    
    [self.contentView addSubview:tempVC.view];
    self.currentVCIndex = 0;    //itemArray.count > 0
    self.currentVC = tempVC;
#endif
}

- (SampleViewController *)getVCByIndex:(NSInteger)index
{
    SampleViewController * vc = [self.vcArray objectAtIndex:index];
    return vc;
}

- (void)showViewControllerByIndex:(NSInteger)index {
    if (_currentVCIndex == index) {
        return;
    }
    NSInteger tempIndex = _currentVCIndex;
    _currentVCIndex = index;
    
    NSMutableArray * tempReleaseVCs = [NSMutableArray array];
    NSMutableArray * tempReloadVCs  = [NSMutableArray array];
    
    [tempReloadVCs addObject:@(_currentVCIndex)];
    if (_currentVCIndex - 1 >= 0) {
        [tempReloadVCs addObject:@(_currentVCIndex - 1)];
    }
    if (_currentVCIndex + 1 < _itemArray.count) {
        [tempReloadVCs addObject:@(_currentVCIndex + 1)];
    }
    
    if (tempIndex != (_currentVCIndex - 1) && tempIndex != (_currentVCIndex + 1) &&tempIndex != _currentVCIndex) {
        [tempReleaseVCs addObject:@(tempIndex)];
    }
    if ((tempIndex - 1)!= (_currentVCIndex - 1) && (tempIndex - 1) != (_currentVCIndex + 1) && (tempIndex - 1) != _currentVCIndex) {
        if (tempIndex - 1 >= 0) {
            [tempReleaseVCs addObject:@(tempIndex - 1)];
        }
    }
    if ((tempIndex + 1) != (_currentVCIndex - 1) && (tempIndex + 1) != (_currentVCIndex + 1) && (tempIndex + 1) != _currentVCIndex) {
        if (tempIndex + 1 < _itemArray.count) {
            [tempReleaseVCs addObject:@(tempIndex + 1)];
        }
    }

    for (NSInteger j = 0; j < tempReloadVCs.count; j ++) {
        SampleViewController * vc = [self getVCByIndex:[tempReloadVCs[j] integerValue]];
        [self reloadViewController:vc];
        [vc reloadValue:@[_itemArray[vc.vcTag]]];
    }
    for (NSInteger k = 0; k < tempReleaseVCs.count; k ++) {
        NSInteger num =  [tempReleaseVCs[k] integerValue];
        [self releaseViewController:[self getVCByIndex:num]];
    }
    
    tempReleaseVCs = nil;
    tempReloadVCs  = nil;
}

- (void)releaseViewController:(SampleViewController *)vc {
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    NSLog(@"%ld - 释放",vc.vcTag);
}
- (void)reloadViewController:(SampleViewController *)vc {
    [self addChildViewController:vc];
    [_contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    NSLog(@"%ld - 加载",vc.vcTag);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = _contentView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    [self showViewControllerByIndex:index];
}

@end
