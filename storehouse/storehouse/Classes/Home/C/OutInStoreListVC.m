//
//  OutInStoreListVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/24.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "OutInStoreListVC.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <MJExtension.h>
#import "OutPutListTVCell.h"
#import "BuyApplyDetailModel.h"
#import "CheckdetailVC.h"
#import "GetApplyDetailModel.h"
#import "OutPutGetDetailVC.h"
#import "borrowApplyDetailModel.h"
#import "OutPutBorrowDetailVC.h"
#import "ReplaceApplyDetailModel.h"
#import "OutPutReplaceDetailVC.h"
#import "OutPutBackStoreDetailVC.h"

static NSString* listCell = @"listCell";
static NSInteger start = 0;//上拉加载起始位置
@interface OutInStoreListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(strong, nonatomic)NSMutableArray *orderCategoryButtons;//订单状态分类按钮数组
@property (nonatomic, assign) NSInteger status;//订单状态码
@property(nonatomic,strong)NSMutableArray *ordersArr;//资产列表

@end

@implementation OutInStoreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //设置状态初始值(待采购)
    self.status = 1;
    [self requestOrderListData];//请求采购列表数据
    
    //出库入库状态栏
    [self selectOutInStateBar];
    self.title = @"出库入库";
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(45);
        make.left.right.bottom.offset(0);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[OutPutListTVCell class] forCellReuseIdentifier:listCell];
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf refreshHeader];
        
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf refreshFooter];
    }];
    
}
//出入库状态栏
- (void)selectOutInStateBar{//
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"验收",@"领用",@"借用",@"以旧换新",@"退库", nil];
    //循环把各个按钮通用的部分设置
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor colorWithHexString:@"23b880"] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"1ebeec"];
        }else{
            [btn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }
        //
        btn.tag = 31+i;
        [self.orderCategoryButtons addObject:btn];
        //添加按钮的监听事件
        [btn addTarget:self action:@selector(orderCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(kScreenW*0.2*i);
            make.width.offset(kScreenW*0.2);
            make.top.offset(0);
            make.height.offset(45);
        }];
    }
}
#pragma mark - btnClick
-(void)orderCategoryButtonClick:(UIButton*)sender{
    self.status = sender.tag - 30;
    [self requestOrderListData];
    [sender setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"1ebeec"];
    for (UIButton *btn in self.orderCategoryButtons) {
        if (btn.tag != sender.tag) {
            [btn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }
    }
}


#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ordersArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutPutListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    switch (self.status) {
        case 1:
        {
            BuyApplyDetailModel *model = self.ordersArr[indexPath.row];
            cell.checkModel = model;
            break;
        }
        case 2:
        {
            GetApplyDetailModel *model = self.ordersArr[indexPath.row];
            cell.getModel = model;
            break;
        }
        case 3:
        {
            borrowApplyDetailModel *model = self.ordersArr[indexPath.row];
            cell.borrowModel = model;
            break;
        }
        case 4:
        {
            ReplaceApplyDetailModel *model = self.ordersArr[indexPath.row];
            cell.replaceModel = model;
            break;
        }
        case 5:
        {
            GetApplyDetailModel *model = self.ordersArr[indexPath.row];
            cell.backModel = model;
            break;
        }
        default:
            break;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.status) {
        case 1://验收
        {
            BuyApplyDetailModel *model = self.ordersArr[indexPath.row];
            CheckdetailVC *vc = [[CheckdetailVC alloc] init];
            vc.state = [model.acceptanceOpinion integerValue];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:true];
        }
            break;
        case 2://领用
        {
            GetApplyDetailModel *model = self.ordersArr[indexPath.row];
            OutPutGetDetailVC *vc = [[OutPutGetDetailVC alloc] init];
            vc.outboundDateString = model.outboundDateString;//根据 outboundDate 领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:true];
        }
            break;
        case 3://领用
        {
            borrowApplyDetailModel *model = self.ordersArr[indexPath.row];
            OutPutBorrowDetailVC *vc = [[OutPutBorrowDetailVC alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:true];
        }
            break;
        case 4://领用
        {
            ReplaceApplyDetailModel *model = self.ordersArr[indexPath.row];
            OutPutReplaceDetailVC *vc = [[OutPutReplaceDetailVC alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:true];
        }
            break;
        case 5://退库
        {
            GetApplyDetailModel *model = self.ordersArr[indexPath.row];
            OutPutBackStoreDetailVC *vc = [[OutPutBackStoreDetailVC alloc] init];
            vc.inboundDateString = model.outboundDateString;//根据 outboundDate 领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:true];
        }
        default:
            break;
    }
    
    
}
#pragma mark - request
//分页查询列表接口请求
-(void)requestOrderListData{
    //    status=按状态查询：1=验收，2=领用，3=借用，4=以旧换新，5=退库
    NSString *urlString = @"";
    switch (self.status) {
        case 1:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpCheckList];
            break;
        case 2:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutGetApplyList];
            break;
        case 3:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutassetBorrowApplyList];
            break;
        case 4:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutAssetRepalceApplyList];
            break;
        case 5:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutAssetBackStoreList];
            break;
            
        default:
            break;
    }
    
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *client = [HttpClient defaultClient];
    [SVProgressHUD show];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
            [self.ordersArr removeAllObjects];
            NSArray *responseArr = responseDic[@"rows"];
            for (NSDictionary *dict in responseArr){
                switch (self.status) {
                    case 1:{
                        BuyApplyDetailModel *infoModel = [BuyApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 2:{
                        GetApplyDetailModel *infoModel = [GetApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 3:{
                        borrowApplyDetailModel *infoModel = [borrowApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 4:{
                        ReplaceApplyDetailModel *infoModel = [ReplaceApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 5:{
                        GetApplyDetailModel *infoModel = [GetApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    default:
                        break;
                }
                
            }
            if (self.ordersArr.count>0) {
                start = self.ordersArr.count;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (start < 6) {//没有更多数据了
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{//有更多数据
                    self.tableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
                }
                
            });
        }else if ([responseDic[@"code"] isEqualToString:@"-1"]){
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    
}


//#pragma mark -request
//下拉刷新
-(void)refreshHeader{
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    //    status=按状态查询：1=验收，2=领用，3=借用，4=以旧换新，5=退库
    NSString *urlString = @"";
    switch (self.status) {
        case 1:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpCheckList];
            break;
        case 2:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutGetApplyList];
            break;
        case 3:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutassetBorrowApplyList];
            break;
        case 4:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutAssetRepalceApplyList];
            break;
        case 5:
            urlString = [NSString stringWithFormat:@"%@&start=0&limit=6",mfpOutPutAssetBackStoreList];
            break;
            
        default:
            break;
    }
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
            [self.ordersArr removeAllObjects];
            NSArray *responseArr = responseDic[@"rows"];
            for (NSDictionary *dict in responseArr){
                switch (self.status) {
                    case 1:{
                        BuyApplyDetailModel *infoModel = [BuyApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 2:{
                        GetApplyDetailModel *infoModel = [GetApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 3:{
                        borrowApplyDetailModel *infoModel = [borrowApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 4:{
                        ReplaceApplyDetailModel *infoModel = [ReplaceApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 5:{
                        GetApplyDetailModel *infoModel = [GetApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    default:
                        break;
                }
            }
            if (self.ordersArr.count>0) {
                start = self.ordersArr.count;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                if (start < 6) {//没有更多数据了
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{//有更多数据
                    weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
                }
            });
            
        }else if ([responseDic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//上拉加载
-(void)refreshFooter{
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = @"";
    switch (self.status) {
        case 1:
            urlString = [NSString stringWithFormat:@"%@&start=%ld&limit=6",mfpCheckList,(long)start];
            break;
        case 2:
            urlString = [NSString stringWithFormat:@"%@&start=%ld&limit=6",mfpOutPutGetApplyList,(long)start];
            break;
        case 3:
            urlString = [NSString stringWithFormat:@"%@&start=%ld&limit=6",mfpOutPutassetBorrowApplyList,(long)start];
            break;
        case 4:
            urlString = [NSString stringWithFormat:@"%@&start=%ld&limit=6",mfpOutPutAssetRepalceApplyList,(long)start];
            break;
        case 5:
            urlString = [NSString stringWithFormat:@"%@&start=%ld&limit=6",mfpOutPutAssetBackStoreList,(long)start];
            break;
            
        default:
            break;
    }
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
//            [self.ordersArr removeAllObjects];
            NSArray *responseArr = responseDic[@"rows"];
            for (NSDictionary *dict in responseArr){
                switch (self.status) {
                    case 1:{
                        BuyApplyDetailModel *infoModel = [BuyApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 2:{
                        GetApplyDetailModel *infoModel = [GetApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 3:{
                        borrowApplyDetailModel *infoModel = [borrowApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 4:{
                        ReplaceApplyDetailModel *infoModel = [ReplaceApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    case 5:{
                        GetApplyDetailModel *infoModel = [GetApplyDetailModel mj_objectWithKeyValues:dict];
                        [self.ordersArr addObject:infoModel];
                        break;
                    }
                    default:
                        break;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (self.ordersArr.count>0) {
                    start = self.ordersArr.count;
                    [weakSelf.tableView reloadData];
                    if (start % 6 != 0) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            });
            
        }else if ([responseDic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
#pragma mark -懒加载

-(NSMutableArray *)ordersArr{
    if (_ordersArr == nil) {
        _ordersArr = [NSMutableArray array];
    }
    return _ordersArr;
}

-(NSMutableArray *)orderCategoryButtons{
    if (_orderCategoryButtons == nil) {
        _orderCategoryButtons = [NSMutableArray array];
    }
    return _orderCategoryButtons;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
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
