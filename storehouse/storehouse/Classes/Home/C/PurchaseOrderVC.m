//
//  PurchaseOrderVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/18.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "PurchaseOrderVC.h"
#import "PurchaseOrderListTVCell.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <MJExtension.h>
#import "PurchaseOrderListModel.h"
#import "PurchaseOrderDetailVC.h"

static NSString* listCell = @"listCell";
static NSInteger start = 0;//上拉加载起始位置
@interface PurchaseOrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(strong, nonatomic)NSMutableArray *orderCategoryButtons;//订单状态分类按钮数组
@property (nonatomic, assign) NSInteger status;//订单状态码
@property(nonatomic,strong)NSMutableArray *ordersArr;//资产列表
@end

@implementation PurchaseOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //设置状态初始值(待采购)
    self.status = 1;
    [self requestOrderListData];//请求采购列表数据

    //采购订单状态栏
    [self selectPurchaseStateBar];
    self.title = @"采购订单";
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(45);
        make.left.right.bottom.offset(0);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PurchaseOrderListTVCell class] forCellReuseIdentifier:listCell];
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
//采购订单状态栏
- (void)selectPurchaseStateBar{//待采购、采购中、已入库、已退货
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"待采购",@"采购中",@"已入库",@"已退货", nil];
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
            make.left.offset(kScreenW*0.25*i);
            make.width.offset(kScreenW*0.25);
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
    PurchaseOrderListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    PurchaseOrderListModel *model = self.ordersArr[indexPath.row];
    [cell setModel:model processStatus:self.status];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PurchaseOrderListModel *model = self.ordersArr[indexPath.row];
    PurchaseOrderDetailVC *vc = [[PurchaseOrderDetailVC alloc] init];
    vc.state = self.status;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
#pragma mark - request
//分页查询采购订单列表接口请求
-(void)requestOrderListData{
    //    分页查询采购订单列表接口
//http://192.168.1.168:8085/mobileapi/buyApply/fpManage.do?status=0
//    status=按状态查询：0=待采购，1=采购中，2=已入库，3=已退货
    NSString *urlString = [NSString stringWithFormat:@"%@status=%ld&start=0&limit=6",mPurchaseOrderList,self.status];
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
                PurchaseOrderListModel *infoModel = [PurchaseOrderListModel mj_objectWithKeyValues:dict];
                [self.ordersArr addObject:infoModel];
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
    NSString *urlString = [NSString stringWithFormat:@"%@status=%ld&start=0&limit=6",mPurchaseOrderList,self.status];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
            [self.ordersArr removeAllObjects];
            NSArray *responseArr = responseDic[@"rows"];
            for (NSDictionary *dict in responseArr){
                PurchaseOrderListModel *infoModel = [PurchaseOrderListModel mj_objectWithKeyValues:dict];
                [self.ordersArr addObject:infoModel];
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
    NSString *urlString = [NSString stringWithFormat:@"%@status=%ld&start=%ld&limit=6",mPurchaseOrderList,self.status,(long)start];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
//            [self.ordersArr removeAllObjects];
            NSArray *responseArr = responseDic[@"rows"];
            for (NSDictionary *dict in responseArr){
                PurchaseOrderListModel *infoModel = [PurchaseOrderListModel mj_objectWithKeyValues:dict];
                [self.ordersArr addObject:infoModel];
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
