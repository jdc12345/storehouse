//
//  LaunchSubListVC.m
//  storehouse
//
//  Created by 万宇 on 2018/8/3.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchSubListVC.h"
#import "CPXImageAndTitleButton.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "LaunchExamineListTVCell.h"
#import "LaunchTypeTVCell.h"
#import "HttpClient.h"
#import "CcUserModel.h"
#import "LaunchListModel.h"

static NSString* listCellid = @"tablelist_cell";
static NSString* typeCellid = @"type_cell";
@interface LaunchSubListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray            *dataList;//申请详情列表数据源
@property (nonatomic,strong) UITableView                *tableView;//申请详情列表
//@property (nonatomic, assign) NSInteger                 processStatus;
@property (nonatomic, copy  ) NSString                  *minId;//申请列表数据类型
//@property (nonatomic, assign) BOOL                      isLoading;
//
@property (nonatomic, strong) CPXImageAndTitleButton    *launchSortButton;//申请分类按钮
//@property (nonatomic, strong) CPXLaunchTypeModel        *selectedSortModel;
@property (nonatomic, strong) UITableView               *launchSortTableView;//申请分类列表
@property (nonatomic, strong) NSArray *launchSortTypeArray;//申请分类列表数据源
@end

@implementation LaunchSubListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle];
    self.launchSortTypeArray = [NSArray arrayWithObjects:@"采购申请",@"领用申请",@"借用申请",@"维修申请",@"以旧换新申请",@"报废申请",@"归还申请",@"退库申请", nil];;
    [self launchSortButton];
    [self launchSortTableView];
    //请求列表数据(首次请求全部类型数据，所以传0)
    [self requestLaunchListCurruntSelectedType:@"0"];
}

//根据编号确定标题
- (void) setTitle
{
    switch (self.index) {
        case 0:
            self.title = @"审批中";
            break;
        case 1:
            self.title = @"被驳回";
            break;
        case 2:
            self.title = @"已完成";
            break;
        case 3:
            self.title = @"已失效";
            break;
        default:
            break;
    }
}
- (void)requestLaunchListIsHaveRefreshStatus:(BOOL)isHaveRefreshStatus isFooterRefresh:(BOOL)isFooterRefresh
{
}
#pragma mark - networkRequest

- (void) requestSortApplyTypeList
{
//    [[CPXHTTPClient instanceClient] requestApplySortListCompleteBlock:^(NSArray *dataArray, CPXError *error) {
//        if (!error) {
//            self.launchSortTypeArray = dataArray;
//            [self setSelectedTime];
//        }
//    }];
}

//- (void) setSelectedTime
//{
//    self.selectedSortModel = self.self.launchSortTypeArray.firstObject;
//    [self.launchSortButton setTitle:self.selectedSortModel.typeName forState:UIControlStateNormal];
//    self.selectedSortModel.isSelected = YES;
//    [self.launchSortTableView reloadData];
//}


/**
 *  请求发起列表
 */
//- (void)requestLaunchListIsHaveRefreshStatus:(BOOL)isHaveRefreshStatus isFooterRefresh:(BOOL)isFooterRefresh
- (void)requestLaunchListCurruntSelectedType:(NSString *)SelectedType
{
    [SVProgressHUD show];// 动画开始
//http://192.168.1.168:8085/mobileapi/convergeApply/findPage.do?msgStatus=0
    //    msgStatus：消息状态, 0=审批中，1=被驳回，2=已完成，3=已失效  msgType:不传代表请求全部
    NSString *listUrlStr;
    if ([SelectedType isEqualToString:@"0"]) {
        listUrlStr = [NSString stringWithFormat:@"%@/mobileapi/convergeApply/findPage.do?msgStatus=%ld",mPrefixUrl,self.index];
    }else{
        listUrlStr = [NSString stringWithFormat:@"%@/mobileapi/convergeApply/findPage.do?msgStatus=%ld&msgType=%@",mPrefixUrl,self.index,SelectedType];
    }
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            for (int i = 0; i < listArr.count; i++) {
                NSDictionary *modelDic = listArr[i];
                LaunchListModel *listModel = [LaunchListModel mj_objectWithKeyValues:modelDic];
                [self.dataList addObject:listModel];
                [self.tableView reloadData];
            }
            
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
//    if (self.isLoading) {
//        return;
//    }
//    self.isLoading = YES;
//    NSArray *array = @[@1, @3, @5, @4];
//    self.processStatus = [array[self.index] integerValue];
//    __weak typeof(self) weakSelf = self;
//    NSString *minId = @"0";
//    if (isFooterRefresh) {
//        minId = self.minId;
//    }
//    [[CPXHTTPClient instanceClient] requestLaunchMainDataWithProcessStatus:[array[self.index] integerValue]
//                                                                     minId:minId
//                                                                    typeId:self.selectedSortModel.type
//                                                         isNeedShowLoading:isHaveRefreshStatus
//                                                             completeBlock:^(CPXLaunchCellModel* listModel, CPXError* error) {
//                                                                 weakSelf.isLoading = NO;
//                                                                 [weakSelf.tableView.header endRefreshing];
//                                                                 [weakSelf.tableView.footer endRefreshing];
//                                                                 if (!error) {
//                                                                     if (listModel.next == 1) {
//                                                                         weakSelf.minId = listModel.minId;
//                                                                     }else if (listModel.next == 0){
//                                                                         [weakSelf.tableView.footer noticeNoMoreData];
//                                                                     }
//
//                                                                     if (isFooterRefresh){
//                                                                         [weakSelf.dataList addObjectsFromArray:listModel.list];
//                                                                     }else{
//                                                                         [weakSelf.dataList removeAllObjects];
//                                                                         [weakSelf.dataList addObjectsFromArray:listModel.list];
//                                                                     }
//                                                                     weakSelf.errorTipView.hidden = YES;
//                                                                 }else{
//                                                                     if (error.errorCode == CPXErrorTypeDataIsBlink) {
//                                                                         [weakSelf.dataList removeAllObjects];
//                                                                     }
//                                                                     if (weakSelf.dataList.count <= 0) {
//                                                                         [weakSelf setDefaultErrorTipWithError:error
//                                                                                                    retryBlock:^{
//                                                                                                        [weakSelf requestLaunchListIsHaveRefreshStatus:YES isFooterRefresh:NO];
//                                                                                                    }];
//                                                                     }
//                                                                 }
//                                                                 [weakSelf.tableView reloadData];
//                                                             }];
}


//- (void)refreshSortTypeDataWithModel:(CPXLaunchTypeModel *)typeModel{
//    if (self.selectedSortModel != typeModel) {
//        self.selectedSortModel = typeModel;
//        [self.tableView.header beginRefreshing];
//    }
//}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[LaunchExamineListTVCell class] forCellReuseIdentifier:listCellid];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.launchSortButton.mas_bottom);
        }];
//        __weak typeof(self) weakSelf = self;
//        [_tableView addLegendHeaderWithRefreshingBlock:^{
//            [weakSelf requestLaunchListIsHaveRefreshStatus:NO isFooterRefresh:NO];
//        }];
//        _tableView.header.updatedTimeHidden = YES;
//        [_tableView addLegendFooterWithRefreshingBlock:^{
//            [weakSelf requestLaunchListIsHaveRefreshStatus:NO isFooterRefresh:YES];
//        }];
    }
    return _tableView;
}


- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}


- (UIButton *)launchSortButton{
    if (!_launchSortButton) {
        _launchSortButton = [CPXImageAndTitleButton buttonWithType:UIButtonTypeCustom];
        [_launchSortButton addTarget:self action:@selector(resetLaunchSortView) forControlEvents:UIControlEventTouchUpInside];
        [_launchSortButton setTitleColor:[UIColor colorWithHexString:@"373a41"] forState:UIControlStateNormal];
        [_launchSortButton setTitle:@"全部分类" forState:UIControlStateNormal];
        _launchSortButton.titleLabel.font = [UIFont systemFontOfSize:12];
        UIImage *nomalIcon = [UIImage imageNamed:@"箭头向下灰色"];
        UIImage *turnImage = [UIImage imageWithCGImage:nomalIcon.CGImage scale:nomalIcon.scale orientation:UIImageOrientationDown];
        [_launchSortButton setImage:nomalIcon forState:UIControlStateNormal];
        [_launchSortButton setImage:turnImage forState:UIControlStateSelected];
        _launchSortButton.imageAndTitleOffset = 3;
        _launchSortButton.imagePosition = CPXImageAndTitleButtonImagePositionRight;
        [self.view addSubview:_launchSortButton];
        [_launchSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(40);
        }];
//        UIView *bottomLine = [[UIView alloc] init];
//        bottomLine.backgroundColor = CPXCommonLineLayerColorColor;
//        [_launchSortButton addSubview:bottomLine];
//        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(_launchSortButton);
//            make.height.mas_equalTo(0.5);
//        }];
    }
    return _launchSortButton;
}

- (UITableView *)launchSortTableView{
    if (!_launchSortTableView) {
        _launchSortTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _launchSortTableView.delegate = self;
        _launchSortTableView.dataSource = self;
        _launchSortTableView.tableFooterView = nil;
        _launchSortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_launchSortTableView registerClass:[LaunchTypeTVCell class] forCellReuseIdentifier:typeCellid];
        [self.view addSubview:_launchSortTableView];
        _launchSortTableView.hidden = YES;
        [_launchSortTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.launchSortButton.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(0);
        }];
    }
    [self.view bringSubviewToFront:_launchSortTableView];
    return _launchSortTableView;
}
#pragma mark - 按钮点击

/**
 *  全部类型点击筛选不同类型审批相关的动画
 */
- (void)resetLaunchSortView
{
    if (self.launchSortButton.selected) {
        self.launchSortButton.selected = NO;
        [self.launchSortTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.launchSortTableView.hidden = YES;
        }];
    }else{
        self.launchSortTableView.hidden = NO;
        [self.launchSortTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height - 64 - 44);
        }];
        self.launchSortButton.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

//- (void)resetViewHeight{
//    if (self.launchSortTypeArray.count > 0) {
//        for (CPXLaunchTypeModel *typeModel in self.launchSortTypeArray) {
//            typeModel.isSelected = NO;
//        }
//        self.selectedSortModel = [self.launchSortTypeArray firstObject];
//        self.selectedSortModel.isSelected = YES;
//        self.launchSortButton.hidden = NO;
//    }else{
//        self.launchSortButton.hidden = YES;
//    }
//}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.launchSortTableView){
        return self.launchSortTypeArray.count;
    }else{
        return self.dataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.launchSortTableView){
        LaunchTypeTVCell *sortCell = [tableView dequeueReusableCellWithIdentifier:typeCellid forIndexPath:indexPath];
//        CPXLaunchTypeModel *typeModel = [self.launchSortTypeArray objectAtIndex:indexPath.row];
//        [sortCell setLaunchTypeModel:typeModel cellType:CPXLaunchTypeCellStyleSortType];
        cell = sortCell;
    }else{
        LaunchExamineListTVCell *launchCell = [tableView dequeueReusableCellWithIdentifier:listCellid forIndexPath:indexPath];
        LaunchListModel *model = self.dataList[indexPath.row];
        [launchCell setModel:model processStatus:self.index];
        cell = launchCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (tableView == self.launchSortTableView){
//        self.selectedSortModel.isSelected = NO;
//        CPXLaunchTypeModel *typeModel = [self.launchSortTypeArray objectAtIndex:indexPath.row];
//        typeModel.isSelected = YES;
//        [self.launchSortTableView reloadData];
//        [self resetLaunchSortView];
//        [self.launchSortButton setTitle:typeModel.typeName forState:UIControlStateNormal];
//        [self refreshSortTypeDataWithModel:typeModel];
//    }else{
//        CPXLaunchCellDetailModel *model = self.dataList[indexPath.row];
//        UIViewController * detailVC = [CPXLaunchDetailVCManager launchDetailVCWithExpenseSn:model.expenseSn andExpenseType:model.typeModel.type ShopId:model.shopModel.id index:[self processStatusWithIndex]];
//        detailVC.hidesBottomBarWhenPushed = YES;
//        [self.view.navigationController pushViewController:detailVC animated:YES];
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.launchSortTableView){
        return [LaunchTypeTVCell cellHeight];
    }else{
//        CPXLaunchCellDetailModel *model = self.dataList[indexPath.row];
//        return [CPXLaunchCell calculateRowHeightWithIndex:self.index model:model];
        return 95;
    }
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
