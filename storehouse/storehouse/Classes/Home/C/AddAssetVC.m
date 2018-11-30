//
//  AddAssetVC.m
//  storehouse
//
//  Created by 万宇 on 2018/11/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "AddAssetVC.h"
#import "LaunchBaseTVCell.h"
#import "ZWPullMenuView.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "NSString+URL.h"
#import "AssetCategoryModel.h"
#import <MJExtension.h>
#import "CcUserModel.h"

static NSString* tableCellid = @"table_cell";
@interface AddAssetVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) NSMutableArray *categoryFirstLevelArray;//分类第一级数组
@property (nonatomic, strong) NSMutableArray *categorySecondLevelArray;//分类第二级数组
@property (nonatomic, strong) NSMutableArray *categoryThirdLevelArray;//分类第三级数组
@property (nonatomic, strong) NSMutableArray *savePersonArray;//保管人列表数组
@property (nonatomic, strong) NSString *categoryCode;//提交需要参数：类别码
@end

@implementation AddAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"增加入库";
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(addLaunchBtnClick:)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"资产类别",@"资产名称",@"保管人",@"型号",@"所在位置",@"资产编号", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    [self requestAssetsCategary];
    [self requestSavePersonList];
    [self requestAddress];
}
#pragma mark - request
//资产类别请求
-(void)requestAssetsCategary{
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mAssrtsCategoryResult method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一级所有类别(指所有类别，不用显示)
            AssetCategoryModel *infoModel = [AssetCategoryModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                AssetCategoryModel *secondModel = [AssetCategoryModel mj_objectWithKeyValues:secondDic];
                [self.categorySecondLevelArray addObject:secondModel];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//保管地点请求
-(void)requestAddress{
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.168:8085/mobileapi/saveAddress/findList.do"];
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一级所有类别(指所有类别，不用显示)
            AssetCategoryModel *infoModel = [AssetCategoryModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                AssetCategoryModel *secondModel = [AssetCategoryModel mj_objectWithKeyValues:secondDic];
                [self.categorySecondLevelArray addObject:secondModel];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//保管人列表请求
-(void)requestSavePersonList{
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mAssetSavePersonList method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject[@"rows"];
        for (NSDictionary *dic in responseArr) {
            CcUserModel *infoModel = [CcUserModel mj_objectWithKeyValues:dic];
            [self.savePersonArray addObject:infoModel];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//提交网络请求
- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
    LaunchBaseTVCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell1.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择资产类别"];
        return;
    }
    LaunchBaseTVCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell2.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写资产名称"];
        return;
    }
    LaunchBaseTVCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (cell3.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择保管人"];
        return;
    }
    LaunchBaseTVCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (cell4.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写物品型号"];
        return;
    }
    LaunchBaseTVCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (cell5.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写物品所在位置"];
        return;
    }
    
    
    
    LaunchBaseTVCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if (cell6.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你申请的物品采购数量"];
        return;
    }
    LaunchBaseTVCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (cell7.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你申请物品的生产厂家"];
        return;
    }
    LaunchBaseTVCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    if (cell8.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你申请的物品采购类别"];
        return;
    }
    LaunchBaseTVCell *cell9 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    if (cell9.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你申请的物品采购理由"];
        return;
    }
    //    NSString *info_id = [CcUserModel defaultClient].info_id;
    NSString *departmentCode = cell1.contentField.text;//申请部门
    NSString *assetName = cell2.contentField.text;//物品名称
    NSString *specTyp = cell3.contentField.text;//规格型号
    NSString *unit = cell4.contentField.text;//计量单位
    NSString *worth = cell5.contentField.text;//预算价格
    NSString *buyCount = cell6.contentField.text;//采购数量
    NSString *producerName = cell7.contentField.text;//生产厂家
    NSString *buyCate;//采购类别
    if ([cell8.contentField.text isEqualToString:@"计划内"]) {
        buyCate = @"1";
    }else{
        buyCate = @"2";
    }
    NSString *buyReason = cell9.contentField.text;//采购理由
    //http://192.168.1.168:8085/mobileapi/buyApply/save.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@/mobileapi/buyApply/save.do?&companyId=1&departmentCode=%@&assetName=%@&specTyp=%@&unit=%@&worth=%@&buyCount=%@&producerName=%@&buyCate=%@&buyReason=%@",mPrefixUrl,departmentCode,assetName,specTyp,unit,worth,buyCount,producerName,buyCate,buyReason];
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"发起成功"];
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        sender.enabled = true;
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        sender.enabled = true;
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
    LaunchBaseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    if ( indexPath.row == 0 || indexPath.row == 2) {
        cell.listButton.hidden = false;
        cell.listButton.tag = 100+indexPath.row;
        [cell.listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentField.tag = 50+indexPath.row;
    }
    cell.contentField.delegate = self;
    cell.itemLabel.text = self.itemTypeArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

//列表按钮点击事件
-(void)listButtonClick:(UIButton*)sender{
    LaunchBaseTVCell *curruntCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag-100) inSection:0]];
    if (sender.tag == 100){//资产类别
        if (self.categorySecondLevelArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"请重试"];
            return;
        }
        NSMutableArray *secondTitleArr = [NSMutableArray array];//第二级标题数组
        NSMutableArray *thirdTitleArr = [NSMutableArray array];//第三级标题数组
        for (AssetCategoryModel *model in self.categorySecondLevelArray) {
            [secondTitleArr addObject:model.text];
        }
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:secondTitleArr];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            AssetCategoryModel *secModel = self.categorySecondLevelArray[menuRow];
            if (secModel.children.count > 0) {//有三级选项
                [self.categoryThirdLevelArray removeAllObjects];
                for (NSDictionary *thirdDic in secModel.children) {
                    AssetCategoryModel *thirdModel = [AssetCategoryModel mj_objectWithKeyValues:thirdDic];
                    [self.categoryThirdLevelArray addObject:thirdModel];//点击的第二级数据行对应的第三级数据源
                    [thirdTitleArr addObject:thirdModel.text];//点击的第二级数据行对应的第三级标题数据源
                }
                ZWPullMenuView *secondMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:thirdTitleArr];
                secondMenuView.zwPullMenuStyle = PullMenuLightStyle;
                __weak typeof(secondMenuView) weakSecondMenuView = secondMenuView;
                weakSecondMenuView.blockSelectedMenu = ^(NSInteger menuRow) {
                    NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
                    curruntCell.contentField.text = weakSecondMenuView.titleArray[menuRow];
                    AssetCategoryModel *model = self.categoryThirdLevelArray[menuRow];
                    self.categoryCode = model.treeCode;
                };
            }else {//没有三级选项
                
                curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
                self.categoryCode = secModel.treeCode;
            }
        };
    }else{//保管人列表
        NSMutableArray *titleArr = [NSMutableArray array];//标题数组
        for (CcUserModel *model in self.savePersonArray) {
            [titleArr addObject:model.trueName];
        }
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:titleArr];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
        };
    }
    
}
//设置列表行为不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 50 || textField.tag == 52) {
            return false;
    }
    return true;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
#pragma mark -懒加载
-(NSMutableArray *)categoryFirstLevelArray{
    if (_categoryFirstLevelArray == nil) {
        _categoryFirstLevelArray = [NSMutableArray array];
    }
    return _categoryFirstLevelArray;
}
-(NSMutableArray *)categorySecondLevelArray{
    if (_categorySecondLevelArray == nil) {
        _categorySecondLevelArray = [NSMutableArray array];
    }
    return _categorySecondLevelArray;
}
-(NSMutableArray *)categoryThirdLevelArray{
    if (_categoryThirdLevelArray == nil) {
        _categoryThirdLevelArray = [NSMutableArray array];
    }
    return _categoryThirdLevelArray;
}
-(NSMutableArray *)savePersonArray{
    if (_savePersonArray == nil) {
        _savePersonArray = [NSMutableArray array];
    }
    return _savePersonArray;
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
