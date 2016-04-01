//
//  MapListViewController.m
//  MapDemo
//
//  Created by xdzhangm on 16/4/1.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "MapListViewController.h"
#import "MapLocationItemModel.h"
#import "TileMapViewController.h"

@interface MapListViewController ()
{
    NSMutableArray *dataList;
}
@end

@implementation MapListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVariables];
    [self updateViews];
}

- (void)initVariables
{
    dataList = [MapItemModel arrayOfModelsFromData:[FileUtil readFileFromPath:@"hand_drawing_map_list.json"] error:nil];
    self.navigationItem.title = @"导游导览";
}

- (void)updateViews
{
    // 隐藏多余的分隔线
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    MapItemModel *item = dataList[indexPath.row];
    cell.textLabel.text = item.scenicName;
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if([@"mapListToDetail" isEqualToString:segue.identifier])
    {
        TileMapViewController *viewController = (TileMapViewController *)segue.destinationViewController;
        viewController.mapItem = dataList[indexPath.row];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
