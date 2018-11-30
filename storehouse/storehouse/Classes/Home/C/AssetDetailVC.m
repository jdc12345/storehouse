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

static NSString* tableCellid = @"table_cell";
@interface AssetDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,weak)UITableView *tableView;
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
    if (self.info_id) {//去除扫一扫页面，避免返回到扫一扫页面
        //得到当前视图控制器中的所有控制器
        NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
        //把扫一扫页面从里面删除
        [array removeObjectAtIndex:1];
        //把删除后的控制器数组再次赋值
        [self.navigationController setViewControllers:[array copy] animated:YES];
    }    
}
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
        self.tableView.scrollEnabled = false;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
//从资产管理页面跳转过来
-(void)setAssetModel:(AssetModel *)assetModel{
    
    _assetModel = assetModel;
    [self.tableView reloadData];
  
}
//从扫一扫页面跳转过来
-(void)setInfo_id:(NSString *)info_id{
    _info_id = info_id;
    //把搜索中文转义
    NSString *urlString = [NSString stringWithFormat:@"%@id=%@",mAssetDetailResult,info_id];
    HttpClient *client = [HttpClient defaultClient];
    [SVProgressHUD show];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:responseDic];
        self.assetModel = infoModel;
//        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    
    
    
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.itemTypeArray.count;//

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

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
            cell.itemContentLabel.text = self.assetModel.assetType;
            break;
        case 4:
            cell.itemContentLabel.text = self.assetModel.addressName;
            break;
        case 5:
            cell.itemContentLabel.text = self.assetModel.barcode;
            break;
            
        default:
            break;
    }
 
        return cell;
}
#pragma mark - btnClick
//增加按钮点击事件
-(void)manageBtnClick:(UIButton *)sender{
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorPoint:CGPointMake(kScreenW-50, 88) titleArray:@[@"领用申请",@"借用申请",@"维修申请",@"以旧换新申请",@"报废申请"]];
//    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.view titleArray:@[@"领用申请",@"借用申请",@"维修申请",@"以旧换新申请",@"报废申请"]];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
//    __weak typeof(menuView) weakMenuView = menuView;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
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
    };
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

