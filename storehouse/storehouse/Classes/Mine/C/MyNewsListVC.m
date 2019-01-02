//
//  MyNewsListVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/22.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "MyNewsListVC.h"
#import "FunctionListFlowLayout.h"
#import "HomeFunctionCollectionViewCell.h"
#import "NSArray+Addition.h"
#import "HomeNoticeNewsTVCell.h"
#import "UILabel+Addition.h"
#import "HomePageScanVC.h"
#import "AssetsManangeVC.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "HomePageNoticeModel.h"
#import "PostNoticeVC.h"
#import "HomePageInventoryVC.h"
#import "PurchaseOrderVC.h"
#import "RepairManagerListVC.h"
#import "NoticeDetailVC.h"

static NSInteger start = 0;//上拉加载起始位置
static NSString* tableCellid = @"table_cell";
@interface MyNewsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray* functionListData;//功能列表
@property(nonatomic,strong)NSMutableArray *noticeNewsArr;//通知消息数据源
@property(nonatomic,weak)UITableView *tableView;//仓库可领用物料列表

@end

@implementation MyNewsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.title = @"我的消息";
    //加载数据
    [self loadData];
}
//-(UIStatusBarStyle)preferredStatusBarStyle{//如果有导航栏必须在导航栏重写- (UIViewController *)childViewControllerForStatusBarStyle{
//    //    return self.topViewController;
//    //}
//    //默认导航栏样式：黑字
//    return UIStatusBarStyleDefault;
//}
- (void)loadData{
    NSString *urlString = [NSString stringWithFormat:@"%@",mNoticeList];
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject[@"rows"];
        for (NSDictionary *dic in responseArr) {
            HomePageNoticeModel *infoModel = [HomePageNoticeModel mj_objectWithKeyValues:dic];
            [self.noticeNewsArr addObject:infoModel];
        }
        if (self.noticeNewsArr.count>0) {
            start = self.noticeNewsArr.count;
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
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    [self setUpUI];
}
//下拉刷新
-(void)refreshHeader{
    [SVProgressHUD show];// 动画开始
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = [NSString stringWithFormat:@"%@start=0&limit=6",mNoticeList];
    //把中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
            [self.noticeNewsArr removeAllObjects];
            NSArray *responseArr = (NSArray*)responseObject[@"rows"];
            for (NSDictionary *dic in responseArr) {
                HomePageNoticeModel *infoModel = [HomePageNoticeModel mj_objectWithKeyValues:dic];
                [self.noticeNewsArr addObject:infoModel];
            }
            if (self.noticeNewsArr.count>0) {
                start = self.noticeNewsArr.count;
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
//上拉刷新
-(void)refreshFooter{
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = [NSString stringWithFormat:@"%@start=%ld&limit=6",mNoticeList,start];
    //把中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSMutableArray *newsArr = [NSMutableArray array];
            NSArray *responseArr = (NSArray*)responseObject[@"rows"];
            for (NSDictionary *dic in responseArr) {
                HomePageNoticeModel *infoModel = [HomePageNoticeModel mj_objectWithKeyValues:dic];
                [newsArr addObject:infoModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (newsArr.count>0) {
                    [weakSelf.noticeNewsArr addObjectsFromArray:newsArr];
                    start = weakSelf.noticeNewsArr.count;
                    
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
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
- (void)setUpUI {
    //背景view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-self.tabBarController.tabBar.bounds.size.height)];
    backView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:backView];
    
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [backView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[HomeNoticeNewsTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 46*kiphone6H;
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf refreshHeader];
        
    }];
    //        上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf refreshFooter];
    }];
    
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticeNewsArr.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNoticeNewsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.noticeNewsArr[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 32*kiphone6H)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *titlelabel = [UILabel labelWithText:@"通知" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:15];
    [titleView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [titleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0.5*kiphone6H);
    }];
    return titleView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46*kiphone6H;
    //    // 2 .给tableview缓存行高属性赋值并计算
    //    YJReportRepairRecordModel *comModel = self.recordArr[indexPath.row];// 2.1 找到这个cell对应的数据模型
    //    NSString *thisId = [NSString stringWithFormat:@"%ld",comModel.info_id];// 2.2 取出模型对应id作为cell缓存行高对应key
    //    CGFloat cacheHeight = [[self.cellHeightCache valueForKey:thisId] doubleValue];// 2.3 根据这个key取这个cell的高度
    //    if (cacheHeight) {// 2.4 如果取得到就说明已经存过了，不需要再计算，直接返回这个高度
    //        return cacheHeight;
    //    }
    //    YJRepairRecordTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:tableCellid];// 2.4 如果没有取到值说明是第一遍，需要取一个cell(作为计算模型)并给cell的数据model赋值，进而计算出这个cell的高度
    //    commentCell.model = comModel;// 2.5 赋值并在cell中计算
    //    [self.cellHeightCache setValue:@(commentCell.cellHeight) forKey:thisId];// 2.6 取cell计算出的高度存入tableview的缓存行高字典里，方便读取
    //    //            NSLog(@"%@",self.cellHeightCache);
    //    return commentCell.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDetailVC *vc = [[NoticeDetailVC alloc] init];
    vc.model = self.noticeNewsArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    //    消息》标记为已读接口
    //http://192.168.1.168:8085/mobileapi/message/setReaded.do?id=消息编号
    //    1=缺少参数：id
    //    2=对应编号的消息不存在
    //标记成功
    //    HomeNoticeNewsTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HomePageNoticeModel *infoModel = self.noticeNewsArr[indexPath.row];
    NSString *noticeUrlStr = [NSString stringWithFormat:@"%@id=%@",mSetReaded,infoModel.info_id];
    [[HttpClient defaultClient]requestWithPath:noticeUrlStr method:1 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"] ) {
            infoModel.isRead = true;
            
            [tableView reloadData];//去掉圆点
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];

}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    //    self.navBarBgAlpha = @"0.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
//    //    self.navigationController.navigationBar.translucent = true;
//    self.navigationController.navigationBarHidden = YES;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//    //    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
//}
#pragma mark -懒加载
-(NSMutableArray *)noticeNewsArr{
    if (_noticeNewsArr == nil) {
        _noticeNewsArr = [NSMutableArray array];
    }
    return _noticeNewsArr;
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
