//
//  AssetDetailVC.m
//  storehouse
//
//  Created by 万宇 on 2018/11/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "AssetDetailVC.h"
#import "ApplyDetailTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "ZWPullMenuView.h"
#import "LaunchGetUseVC.h"
#import "launchBorrowApplyVC.h"
#import "AssetChangeRecordModel.h"
#import "AssetChangeRecordTVCell.h"
#import "UILabel+Addition.h"
#import <MJRefresh.h>
#import "CcUserModel.h"
#import "LaunchRepairVC.h"
#import "LaunchOldForNewVC.h"
#import "LaunchScrapVC.h"
#import "LaunchRetiringVC.h"

static NSInteger start = 0;//上拉加载起始位置
static NSString* tableCellid = @"table_cell";
static NSString* recordCellid = @"recordCellid";
@interface AssetDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordsArr;//变动记录列表
@property(nonatomic,copy)NSString *assetId;//资产id
@property(nonatomic,copy)NSString *saverId;//资产保管人id
@end

@implementation AssetDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(manageBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.title = @"资产详情";
    self.itemTypeArray = [NSArray arrayWithObjects:@"资产名称",@"资产类别",@"保管人",@"型号",@"存放位置",@"资产编号",@"使用年限",@"价  格",@"数量",@"计量单位",@"备  注", nil];
    if (self.info_id && !self.ifFromInventory) {//去除扫一扫页面，避免返回到扫一扫页面
        //得到当前视图控制器中的所有控制器
        NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
        //把扫一扫页面从里面删除
        [array removeObjectAtIndex:1];
        //把删除后的控制器数组再次赋值
        [self.navigationController setViewControllers:[array copy] animated:YES];
    }    
}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        //添加tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        _tableView = tableView;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
        [self.tableView registerClass:[AssetChangeRecordTVCell class] forCellReuseIdentifier:recordCellid];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
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
    return _tableView;
}
-(NSMutableArray *)recordsArr{
    if (_recordsArr == nil) {
        _recordsArr = [NSMutableArray array];
    }
    return _recordsArr;
}
//从资产管理页面跳转过来
-(void)setAssetModel:(AssetModel *)assetModel{
    
    _assetModel = assetModel;
    self.assetId = assetModel.info_id;
    self.saverId = assetModel.saveUserId;
    [self requestForAssetRecord:self.assetId];//请求资产变动记录
  
}
//从扫一扫页面跳转过来或者盘点详情点击过来
-(void)setInfo_id:(NSString *)info_id{
    _info_id = info_id;
    NSString *urlString = [NSString stringWithFormat:@"%@id=%@",mAssetDetailResult,info_id];
    HttpClient *client = [HttpClient defaultClient];
    [SVProgressHUD show];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"]  isEqualToString:@"0"]) {

        NSDictionary *responseDic = (NSDictionary*)responseObject[@"message"];
        AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:responseDic];
        self.assetModel = infoModel;
        self.saverId = infoModel.saveUserId;
//        [self.tableView reloadData];
            
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    self.assetId = info_id;
    [self requestForAssetRecord:self.assetId];//请求资产变动记录
}
//查询资产变动情况
-(void)requestForAssetRecord:(NSString*)assetId{
    //    资产变动情况分页查询接口：
    //http://192.168.1.168:8085/mobileapi/changesLog/findPage.do?assetId=资产编号
    NSString *urlString = [NSString stringWithFormat:@"%@assetId=%@",mAssetRecordDetailResult,assetId];
    HttpClient *client = [HttpClient defaultClient];
    [SVProgressHUD show];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"]  isEqualToString:@"0"]) {
            [self.recordsArr removeAllObjects];
            NSArray *responseArr = (NSArray*)responseObject[@"rows"];
            for (NSDictionary *recordDic in responseArr) {
                AssetChangeRecordModel *infoModel = [AssetChangeRecordModel mj_objectWithKeyValues:recordDic];
                [self.recordsArr addObject:infoModel];
            }
            if (self.recordsArr.count>0) {
                start = self.recordsArr.count;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if ( start < 6 ) {//没有更多数据了
                    if (start > 0) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }else{//有更多数据
                    self.tableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
                }
            });
            
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.itemTypeArray.count;
    }else{
        return self.recordsArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        
    cell.itemLabel.text = self.itemTypeArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.itemContentLabel.text = self.assetModel.assetName;
            break;
        case 1:
            cell.itemContentLabel.text = self.assetModel.categoryName;
            break;
        case 2:
            cell.itemContentLabel.text = self.assetModel.saveUserName;
            break;
        case 3:
            cell.itemContentLabel.text = self.assetModel.specTyp;
            break;
        case 4:
            cell.itemContentLabel.text = self.assetModel.addressName;
            break;
        case 5:
            cell.itemContentLabel.text = self.assetModel.barcode;
            break;
        case 6:
            cell.itemContentLabel.text = self.assetModel.useTimes;
            break;
        case 7:
            cell.itemContentLabel.text = self.assetModel.worth;
            break;
        case 8:
            cell.itemContentLabel.text = self.assetModel.num;
            break;
        case 9:
            cell.itemContentLabel.text = self.assetModel.unit;
            break;
        case 10:
            cell.itemContentLabel.text = self.assetModel.comment;
            break;
            
        default:
            break;
    }
        return cell;
    }else{
        AssetChangeRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCellid forIndexPath:indexPath];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.model = self.recordsArr[indexPath.row];
        return cell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 35;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if (self.recordsArr.count > 0) {
            return 35;
        }else{
            return 0;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //序号
    UILabel *numLabel = [UILabel labelWithText:@"序号" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    numLabel.backgroundColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(40);
        make.height.offset(35);
    }];
    //变动日期label
    UILabel *changeDateLabel = [UILabel labelWithText:@"变动日期" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    changeDateLabel.backgroundColor = [UIColor whiteColor];
    changeDateLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:changeDateLabel];
    [changeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(numLabel.mas_right);
        make.width.offset(120);
        make.height.offset(35);
    }];
    //变动事项label
    UILabel *itemLabel = [UILabel labelWithText:@"变动事项" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    itemLabel.backgroundColor = [UIColor whiteColor];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(changeDateLabel.mas_right);
        make.width.offset(120);
        make.height.offset(35);
    }];
    //关联人label
    UILabel *saveUserLabel = [UILabel labelWithText:@"关联人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    saveUserLabel.backgroundColor = [UIColor whiteColor];
    saveUserLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:saveUserLabel];
    [saveUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(itemLabel.mas_right);
        make.width.offset(kScreenW - 280);
        make.height.offset(35);
    }];
    
    [headerView layoutIfNeeded];
    [self setBorderWithView:numLabel top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:changeDateLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:itemLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:saveUserLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    
    return headerView;
    
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
#pragma mark - btnClick
//管理按钮点击事件
-(void)manageBtnClick:(UIButton *)sender{
    NSArray *titleArr;
    CcUserModel *userModel = [CcUserModel defaultClient];
    if ([userModel.info_id isEqualToString:self.saverId]) {//是自己的资产
        titleArr = @[@"维修申请",@"以旧换新申请",@"报废申请",@"退库申请"];
    }else{
        titleArr = @[@"领用申请",@"借用申请"];
    }
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorPoint:CGPointMake(kScreenW-50, 88) titleArray:titleArr];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
//    __weak typeof(menuView) weakMenuView = menuView;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//        NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
        if ([userModel.info_id isEqualToString:self.saverId]) {
            switch (menuRow) {
                case 0:{
                    LaunchRepairVC *vc = [[LaunchRepairVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1:{
                    LaunchOldForNewVC *vc = [[LaunchOldForNewVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 2:{
                    LaunchScrapVC *vc = [[LaunchScrapVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 3:{
                    LaunchRetiringVC *vc = [[LaunchRetiringVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
        }else{
            switch (menuRow) {
                case 0:{
                    LaunchGetUseVC *vc = [[LaunchGetUseVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1:{
                    launchBorrowApplyVC *vc = [[launchBorrowApplyVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
        }
        
    };
}
#pragma mark - 刷新和加载
//下拉刷新
-(void)refreshHeader{
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = [NSString stringWithFormat:@"%@assetId=%@&start=0&limit=6",mAssetRecordDetailResult,self.assetId];
    //把中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
            [self.recordsArr removeAllObjects];
            NSArray *responseArr = (NSArray*)responseObject[@"rows"];
            for (NSDictionary *recordDic in responseArr) {
                AssetChangeRecordModel *infoModel = [AssetChangeRecordModel mj_objectWithKeyValues:recordDic];
                [self.recordsArr addObject:infoModel];
            }
            if (self.recordsArr.count>0) {
                start = self.recordsArr.count;
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
    NSString *urlString = [NSString stringWithFormat:@"%@assetId=%@&start=%ld&limit=6",mAssetRecordDetailResult,self.assetId,start];
    //把中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSMutableArray *newsArr = [NSMutableArray array];
            NSArray *responseArr = (NSArray*)responseObject[@"rows"];
            for (NSDictionary *dic in responseArr) {
                AssetChangeRecordModel *infoModel = [AssetChangeRecordModel mj_objectWithKeyValues:dic];
                [newsArr addObject:infoModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (newsArr.count>0) {
                    [weakSelf.recordsArr addObjectsFromArray:newsArr];
                    start = weakSelf.recordsArr.count;
                    
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

