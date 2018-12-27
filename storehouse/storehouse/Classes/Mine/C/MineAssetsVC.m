//
//  MineAssetsVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/23.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "MineAssetsVC.h"
#import "LaunchBaseTVCell.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import "AssetsManageTVCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "storeThingsModel.h"
#import "AssetModel.h"
#import <MJExtension.h>
#import "AssetDetailVC.h"



static NSString* listCell = @"listCell";
static NSInteger start = 0;//上拉加载起始位置
@interface MineAssetsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *assetsArr;//资产列表

@end

@implementation MineAssetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的资产";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self requestList];
    //设置资产标题栏
    [self setTitleBar];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (kScreenH > 736) {//iPhone X
            make.top.offset(88+35);
        }else{
            make.top.offset(64+35);
        }
        make.left.right.bottom.offset(0);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AssetsManageTVCell class] forCellReuseIdentifier:listCell];
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
//添加标题栏
- (void)setTitleBar{
    //空白格
    UIView *emptyView = [[UIView alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenH > 736) {//iPhone X
            make.top.offset(88);
        }else{
            make.top.offset(64);
        }
        make.left.offset(0);
        make.width.offset(40);
        make.height.offset(35);
    }];
    //资产数量label
    UILabel *departmentLabel = [UILabel labelWithText:@"资产数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(emptyView.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    //物品名称label
    UILabel *goodsNameLabel = [UILabel labelWithText:@"资产名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    goodsNameLabel.backgroundColor = [UIColor whiteColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    //保管人label
    UILabel *keeperLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    keeperLabel.backgroundColor = [UIColor whiteColor];
    keeperLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:keeperLabel];
    [keeperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(goodsNameLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    //storelabel
    UILabel *storelabel = [UILabel labelWithText:@"存放地" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    storelabel.backgroundColor = [UIColor whiteColor];
    storelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:storelabel];
    [storelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(keeperLabel.mas_right);
        make.right.offset(0);
        make.height.offset(35);
    }];
    
    [self.view layoutIfNeeded];
    [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:keeperLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:storelabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    
}
//给view添加不同位置的边框
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetsArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetsManageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.assetModel = self.assetsArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetModel *model = self.assetsArr[indexPath.row];
    AssetDetailVC *vc = [[AssetDetailVC alloc] init];
    vc.assetModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
#pragma mark - request
-(void)requestList{
    NSString *urlString = [NSString stringWithFormat:@"%@start=0&limit=6",mUserAssetsRequest];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *client = [HttpClient defaultClient];
    [SVProgressHUD show];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        NSArray *responseArr = responseDic[@"rows"];
        NSMutableArray *assetsArr = [NSMutableArray array];
        for (NSDictionary *dict in responseArr){
            AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:dict];
            [assetsArr addObject:infoModel];
        }
        self.assetsArr = assetsArr;
        if (self.assetsArr.count>0) {
            start = self.assetsArr.count;
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
}

#pragma mark - btnClick

//设置列表行为不可编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

#pragma mark -懒加载
//下拉刷新
-(void)refreshHeader{
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = [NSString stringWithFormat:@"%@start=0&limit=6",mUserAssetsRequest];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
            NSArray *responseArr = responseDic[@"rows"];
            NSMutableArray *assetsArr = [NSMutableArray array];
            for (NSDictionary *dict in responseArr){
                AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:dict];
                [assetsArr addObject:infoModel];
            }
            weakSelf.assetsArr = assetsArr;
            if (weakSelf.assetsArr.count>0) {
                start = weakSelf.assetsArr.count;
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
    NSString *urlString = [NSString stringWithFormat:@"%@start=%ld&limit=6",mUserAssetsRequest,start];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *responseArr = dic[@"rows"];
            NSMutableArray *assetsArr = [NSMutableArray array];
            for (NSDictionary *dict in responseArr){
                AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:dict];
                [assetsArr addObject:infoModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (assetsArr.count>0) {
                    [weakSelf.assetsArr addObjectsFromArray:assetsArr];
                    start = weakSelf.assetsArr.count;
                    
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
