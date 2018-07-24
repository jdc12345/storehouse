//
//  LaunchBaseVC.m
//  storehouse
//
//  Created by 万宇 on 2018/7/23.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchBaseVC.h"

@interface LaunchBaseVC ()

@end

@implementation LaunchBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        //添加tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20*kiphone6H);
            make.left.right.bottom.offset(0);
        }];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //    [tableView registerClass:[HomeNoticeNewsTVCell class] forCellReuseIdentifier:tableCellid];
        //    tableView.delegate =self;
        //    tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44*kiphone6H;
        _tableView = tableView;
    }
    return _tableView;
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
