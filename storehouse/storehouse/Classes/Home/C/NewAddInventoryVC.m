//
//  NewAddInventoryVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/13.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "NewAddInventoryVC.h"
#import "LaunchBaseTVCell.h"
#import "ZWPullMenuView.h"
#import "HttpClient.h"
#import "NSString+URL.h"
#import <MJExtension.h>
#import "InventoryTypeModel.h"

static NSString* tableCellid = @"table_cell";
@interface NewAddInventoryVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) NSArray *inventoryTypeFirLevelArr;//盘点方式第一级标题数组
@property (nonatomic, copy) NSString *mode;//方式第一级编码
@property (nonatomic, strong) NSMutableArray *selectedSecLevelArr;//当前选中的方式第二级数组
@property (nonatomic, strong) NSMutableArray *departmentSecLevelArr;//请求回来的部门第二级数组
@property (nonatomic, strong) NSMutableArray *addressSecLevelArr;//请求回来的存放地第二级数组
@property (nonatomic, strong) NSMutableArray *categorySecLevelArr;//请求回来的部门第二级数组
@property (nonatomic, copy) NSString *code;//提交需要参数：子级编码

@end

@implementation NewAddInventoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新键盘点";
    self.itemTypeArray = [NSArray arrayWithObjects:@"盘点主题",@"资产说明",@"盘点方式", nil];
// 方式编码   科室/部门=0，存放地点=1，资产类别=2
    self.inventoryTypeFirLevelArr = [NSArray arrayWithObjects:@"科室部门",@"存放地点",@"资产类别", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    [self requestDepartment];
    [self requestAssetsCategary];
    [self requestAddress];
}

#pragma mark - request
//资产所属部门分类请求
-(void)requestDepartment{
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mInventoryDepartmentRequest method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一层所有类别(指所有类别，不用显示)
            InventoryTypeModel *infoModel = [InventoryTypeModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                InventoryTypeModel *secondModel = [InventoryTypeModel mj_objectWithKeyValues:secondDic];
                [self.departmentSecLevelArr addObject:secondModel];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//资产类别分类请求
-(void)requestAssetsCategary{
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mInventoryCategoryRequest method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一层所有类别(指所有类别，不用显示)
            InventoryTypeModel *infoModel = [InventoryTypeModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                InventoryTypeModel *secondModel = [InventoryTypeModel mj_objectWithKeyValues:secondDic];
                [self.categorySecLevelArr addObject:secondModel];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//保管地点请求
-(void)requestAddress{
    //    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.168:8085/mobileapi/saveAddress/findList.do"];
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mInventorySaveAddressRequest method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一层所有类别(指所有类别，不用显示)
            InventoryTypeModel *infoModel = [InventoryTypeModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                InventoryTypeModel *secondModel = [InventoryTypeModel mj_objectWithKeyValues:secondDic];
                [self.addressSecLevelArr addObject:secondModel];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//通过传值来发起新建
-(void)setIfCompleteNewInventory:(BOOL)ifCompleteNewInventory{
    if (ifCompleteNewInventory) {
        [self addLaunchBtnClick];
    }
}
//提交网络请求
- (void)addLaunchBtnClick{
    LaunchBaseTVCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell1.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写盘点主题"];
        return;
    }
    LaunchBaseTVCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    if (cell2.contentField.text.length==0) {
//        [SVProgressHUD showInfoWithStatus:@"请填写盘点说明"];
//        return;
//    }
    LaunchBaseTVCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (cell3.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择盘点方式"];
        return;
    }
    if (self.code.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择细分类别"];
        return;
    }
//    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
//    http://192.168.1.168:8085/mobileapi/inventory/saveBy.do?mode=0&code=01&subject=
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@mode=%@&code=%@&subject=%@&description=%@",mInventoryCompleteRequest,self.mode,self.code,cell1.contentField.text,cell2.contentField.text];
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"发起成功"];
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }else if ([dic[@"code"] isEqualToString:@"3"]){
            [SVProgressHUD showInfoWithStatus:dic[@"message"]];
        }
//        sender.enabled = true;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
//        sender.enabled = true;
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
    if (indexPath.row == 2) {
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
    if (self.categorySecLevelArr.count == 0||self.departmentSecLevelArr.count == 0||self.addressSecLevelArr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请重新进入该页面"];
        return;
    }
    NSMutableArray *secondTitleArr = [NSMutableArray array];//第二级标题数组
    NSMutableArray *thirdTitleArr = [NSMutableArray array];//第三级标题数组
    NSMutableArray *fourTitleArr = [NSMutableArray array];//第四级标题数组
    ZWPullMenuView *firView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:self.inventoryTypeFirLevelArr];
    firView.zwPullMenuStyle = PullMenuLightStyle;
    __weak typeof(self) weakSelf = self;
    firView.blockSelectedMenu = ^(NSInteger menuRow) {//1
        
        switch (menuRow) {//第一级决定第二级标题数据源
            case 0:
                weakSelf.selectedSecLevelArr = weakSelf.departmentSecLevelArr;
                weakSelf.mode = @"0";
                break;
            case 1:
                weakSelf.selectedSecLevelArr = weakSelf.addressSecLevelArr;
                weakSelf.mode = @"1";
                break;
            case 2:
                weakSelf.selectedSecLevelArr = weakSelf.categorySecLevelArr;
                weakSelf.mode = @"2";
                break;
                
            default:
                break;
        }
        for (InventoryTypeModel *model in weakSelf.selectedSecLevelArr) {//第二级标题数据源
            [secondTitleArr addObject:model.text];
        }
        ZWPullMenuView *secondMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:secondTitleArr];
        secondMenuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(secondMenuView) weakSecondMenuView = secondMenuView;
        secondMenuView.blockSelectedMenu = ^(NSInteger menuRow) {//2
            
            curruntCell.contentField.text = weakSecondMenuView.titleArray[menuRow];
            InventoryTypeModel *secModel = weakSelf.selectedSecLevelArr[menuRow];
            weakSelf.code = secModel.treeCode;
            if (secModel.children.count > 0) {//有三级页面
                for (NSDictionary *thirdDic in secModel.children) {
                    InventoryTypeModel *thirdModel = [InventoryTypeModel mj_objectWithKeyValues:thirdDic];
                    [thirdTitleArr addObject:thirdModel.text];//点击的第二级数据行对应的第三级标题数据源
                }
                ZWPullMenuView *thirdMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:thirdTitleArr];
                thirdMenuView.zwPullMenuStyle = PullMenuLightStyle;
                __weak typeof(thirdMenuView) weakThirdMenuView = thirdMenuView;
                thirdMenuView.blockSelectedMenu = ^(NSInteger menuRow) {//3
                    
                    curruntCell.contentField.text = weakThirdMenuView.titleArray[menuRow];
                    NSDictionary *selectedThirdLeveDic = secModel.children[menuRow];
                    InventoryTypeModel *thirdModel = [InventoryTypeModel mj_objectWithKeyValues:selectedThirdLeveDic];
                    weakSelf.code = thirdModel.treeCode;
                    if (thirdModel.children.count > 0) {//有四级页面
                        for (NSDictionary *fourDic in thirdModel.children) {
                            InventoryTypeModel *fourModel = [InventoryTypeModel mj_objectWithKeyValues:fourDic];
                            [fourTitleArr addObject:fourModel.text];//点击的第三级数据行对应的第四级标题数据源
                        }
                        ZWPullMenuView *fourMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:fourTitleArr];
                        fourMenuView.zwPullMenuStyle = PullMenuLightStyle;
                        __weak typeof(fourMenuView) weakFourMenuView = fourMenuView;
                        fourMenuView.blockSelectedMenu = ^(NSInteger menuRow) {//3
                            
                            curruntCell.contentField.text = weakFourMenuView.titleArray[menuRow];
                            NSDictionary *selectedFourLeveDic = thirdModel.children[menuRow];
                            InventoryTypeModel *fourthModel = [InventoryTypeModel mj_objectWithKeyValues:selectedFourLeveDic];
                            weakSelf.code = fourthModel.treeCode;
                        };
                    }
                };
            }
        };
        
        };
  
}
//设置列表行为不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ( textField.tag == 52 ) {
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

-(NSMutableArray *)selectedSecLevelArr{
    if (_selectedSecLevelArr == nil) {
        _selectedSecLevelArr = [NSMutableArray array];
    }
    return _selectedSecLevelArr;
}
-(NSMutableArray *)departmentSecLevelArr{
    if (_departmentSecLevelArr == nil) {
        _departmentSecLevelArr = [NSMutableArray array];
    }
    return _departmentSecLevelArr;
}

-(NSMutableArray *)addressSecLevelArr{
    if (_addressSecLevelArr == nil) {
        _addressSecLevelArr = [NSMutableArray array];
    }
    return _addressSecLevelArr;
}
-(NSMutableArray *)categorySecLevelArr{
    if (_categorySecLevelArr == nil) {
        _categorySecLevelArr = [NSMutableArray array];
    }
    return _categorySecLevelArr;
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

