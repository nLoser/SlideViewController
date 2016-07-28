//
//  SampleViewController.m
//  SlideViewController
//
//  Created by LV on 16/7/27.
//  Copyright © 2016年 LV. All rights reserved.
//

#import "SampleViewController.h"

@interface SampleViewController ()
@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildTableView];
}

- (void)buildTableView {
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewDelegate & TableViewSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XXXIndentifier"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"XXXIndentifier"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld页 － %@",_vcTag,self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

- (void)setVcTag:(NSInteger)vcTag {
    _vcTag = vcTag;
}

- (void)reloadValue:(NSArray *)dataArray {
    [_dataArray addObjectsFromArray:dataArray];
    [_tableView reloadData];
}

@end
