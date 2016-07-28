//
//  SampleViewController.h
//  SlideViewController
//
//  Created by LV on 16/7/27.
//  Copyright © 2016年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger vcTag;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> * dataArray;

- (void)reloadValue:(NSArray *)dataArray;

@end
