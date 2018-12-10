//
//  HistoryInventoryVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "HistoryInventoryVC.h"
#import "HistoryInventoryTVCell.h"
#import <MJRefresh.h>

static NSString *tableCellid = @"tableCellid";
@interface HistoryInventoryVC ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation HistoryInventoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HistoryInventoryTVCell class] forCellReuseIdentifier:tableCellid];
    [self setupUI];
}
//-(void)setInfos:(NSMutableArray *)infos{
//    _infos = infos;
//    [self.tableView reloadData];
//}
//通知方法
//-(void)refreshLikeStateWithInfoModel:(NSNotification*)sender{
//    NSArray * arr = [self.tableView visibleCells];
//    for (YYCardTableViewCell *cell in arr) {
//        if ([cell.model.info_id isEqualToString:sender.userInfo[@"infoId"]]) {
//            cell.likeState = [sender.userInfo[@"likeState"] boolValue];
//        }
//    }
//}

- (void)setupUI {
    //添加通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLikeStateWithInfoModel:) name:@"refreshLikeStateWithInfoModel:" object:nil];
    self.tableView.scrollEnabled = true;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(transViewController:)]) {
            //代理存在且有这个transButIndex:方法
            [weakSelf.delegate transViewController:weakSelf];
        }
    }];
    //设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(transForFootRefreshWithViewController:)]) {
            //代理存在且有这个transButIndex:方法
            [weakSelf.delegate transForFootRefreshWithViewController:self];
        }
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(5);
    }];
}
#pragma mark - tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inventoryList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryInventoryTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.inventoryList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    HistoryInventoryTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 点击cell调用这个block
    if (self.delegate && [self.delegate respondsToSelector:@selector(transForPushDetailWithCell:)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate transForPushDetailWithCell:cell.model];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
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
