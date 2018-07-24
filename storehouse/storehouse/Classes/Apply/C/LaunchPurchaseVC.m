//
//  LaunchPurchaseVC.m
//  storehouse
//
//  Created by 万宇 on 2018/7/23.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchPurchaseVC.h"
#import "LaunchBaseTVCell.h"

static NSString* tableCellid = @"table_cell";
@interface LaunchPurchaseVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LaunchPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"采购申请";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;//
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LaunchBaseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 7) {
        cell.listButton.hidden = false;
    }
    //    cell.model = self.recordArr[indexPath.row];
    return cell;
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
