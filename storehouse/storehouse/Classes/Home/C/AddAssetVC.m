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
#import "InventoryTypeModel.h"
#import <MJExtension.h>

static NSString* tableCellid = @"table_cell";
@interface AddAssetVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
//@property (nonatomic, strong) NSMutableArray *categoryFirstLevelArray;//分类第一级数组
@property (nonatomic, strong) NSMutableArray *categorySecondLevelArray;//分类第二级数组
@property (nonatomic, strong) NSMutableArray *categoryThirdLevelArray;//分类第三级数组
@property (nonatomic, strong) NSMutableArray *savePersonArray;//保管人列表数组
@property (nonatomic, strong) NSString *savePersonId;//提交需要参数：保管人id
@property (nonatomic, strong) NSString *categoryCode;//提交需要参数：类别码
//@property (nonatomic, strong) NSMutableArray *addressFirstLevelArray;//分类第一级数组
@property (nonatomic, strong) NSMutableArray *addressSecondLevelArray;//分类第二级数组
@property (nonatomic, strong) NSMutableArray *addressThirdLevelArray;//分类第二级数组
@property (nonatomic, strong) NSString *addressCode;//提交需要参数：存放地码
@property(nonatomic,assign) CGRect activedTextFieldRect;//2.当前正在编辑的textField的frame相对于tableView的位置
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
    self.itemTypeArray = [NSArray arrayWithObjects:@"资产类别",@"资产名称",@"保 管 人",@"型    号",@"所在位置",@"资产编号",@"使用年限",@"价    格",@"数    量",@"计量单位",@"备    注", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    [self requestAssetsCategary];
    [self requestSavePersonList];
    [self requestAddress];
    //1.设置tableView的键盘退出模式：
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

#pragma mark - request
//资产类别请求
-(void)requestAssetsCategary{
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mAssrtsCategoryResult method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一级所有类别(指所有类别，不用显示)
            InventoryTypeModel *infoModel = [InventoryTypeModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                InventoryTypeModel *secondModel = [InventoryTypeModel mj_objectWithKeyValues:secondDic];
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
//    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.168:8085/mobileapi/saveAddress/findList.do"];
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:mAssetSaveAddressList method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject;
        for (NSDictionary *dic in responseArr) {//第一级所有类别(指所有类别，不用显示)
            InventoryTypeModel *infoModel = [InventoryTypeModel mj_objectWithKeyValues:dic];
            for (NSDictionary *secondDic in infoModel.children) {//第二级类别
                InventoryTypeModel *secondModel = [InventoryTypeModel mj_objectWithKeyValues:secondDic];
                [self.addressSecondLevelArray addObject:secondModel];
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
    LaunchBaseTVCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];//型号(选填)

    LaunchBaseTVCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (cell5.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写物品所在位置"];
        return;
    }
    LaunchBaseTVCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];//使用年限(选填)
    LaunchBaseTVCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];//价格(选填)
    
    LaunchBaseTVCell *cell9 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    if (cell9.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你入库物品数量"];
        return;
    }
    LaunchBaseTVCell *cell10 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    if (cell10.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写计量单位"];
        return;
    }
    LaunchBaseTVCell *cell11 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];//备注(选填)

    NSString *assetName = cell2.contentField.text;//资产名称
    NSString *specTyp = cell4.contentField.text;//规格型号(选填)
    NSString *useTimes = cell7.contentField.text;//使用年限(选填)
    NSString *worth = cell8.contentField.text;//价格(选填)
    NSString *num = cell9.contentField.text;//数量
    NSString *unit = cell10.contentField.text;//计量单位
    NSString *comment = cell11.contentField.text;//备注(选填)
    //http://192.168.1.168:8085/mobileapi/buyApply/save.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@&categoryCode=%@&assetName=%@&saveUserId=%@&specTyp=%@&addressCode=%@&barcode=%@&useTimes=%@&worth=%@&num=%@&unit=%@&comment=%@",mAssetSaveForStoreRequest,self.categoryCode,assetName,self.savePersonId,specTyp,self.addressCode,self.barCode,useTimes,worth,num,unit,comment];
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
        }
        sender.enabled = true;
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
    if ( indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 9) {
        cell.listButton.hidden = false;
        cell.listButton.tag = 100+indexPath.row;
        [cell.listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentField.tag = 50+indexPath.row;
    }
    if ( indexPath.row == 3){
        cell.contentField.placeholder = @"选填(单位元)";
    }if ( indexPath.row == 5){
        cell.contentField.text = self.barCode;
    }
    if ( indexPath.row == 6){
       cell.contentField.placeholder = @"选填(单位年)";
    }
    if ( indexPath.row == 7 || indexPath.row == 10) {
        cell.contentField.placeholder = @"选填";
    }
    if ( indexPath.row == 8){
        cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
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
            [SVProgressHUD showInfoWithStatus:@"请重新进入该页面"];
            return;
        }
        NSMutableArray *secondTitleArr = [NSMutableArray array];//第二级标题数组
        NSMutableArray *thirdTitleArr = [NSMutableArray array];//第三级标题数组
        for (InventoryTypeModel *model in self.categorySecondLevelArray) {
            [secondTitleArr addObject:model.text];
        }
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:secondTitleArr];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            InventoryTypeModel *secModel = self.categorySecondLevelArray[menuRow];
            if (secModel.children.count > 0) {//有三级选项
                [self.categoryThirdLevelArray removeAllObjects];
                for (NSDictionary *thirdDic in secModel.children) {
                    InventoryTypeModel *thirdModel = [InventoryTypeModel mj_objectWithKeyValues:thirdDic];
                    [self.categoryThirdLevelArray addObject:thirdModel];//点击的第二级数据行对应的第三级数据源
                    [thirdTitleArr addObject:thirdModel.text];//点击的第二级数据行对应的第三级标题数据源
                }
                ZWPullMenuView *secondMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:thirdTitleArr];
                secondMenuView.zwPullMenuStyle = PullMenuLightStyle;
                __weak typeof(secondMenuView) weakSecondMenuView = secondMenuView;
                weakSecondMenuView.blockSelectedMenu = ^(NSInteger menuRow) {
//                    NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
                    curruntCell.contentField.text = weakSecondMenuView.titleArray[menuRow];
                    InventoryTypeModel *model = self.categoryThirdLevelArray[menuRow];
                    self.categoryCode = model.treeCode;
                };
            }else {//没有三级选项
                
                curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
                self.categoryCode = secModel.treeCode;
            }
        };
    }else if (sender.tag == 104){//资产存放地
        if (self.addressSecondLevelArray.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"请重新进入该页面"];
            return;
        }
        NSMutableArray *secondTitleArr = [NSMutableArray array];//第二级标题数组
        NSMutableArray *thirdTitleArr = [NSMutableArray array];//第三级标题数组
        for (InventoryTypeModel *model in self.addressSecondLevelArray) {
            [secondTitleArr addObject:model.text];
        }
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:secondTitleArr];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
            //            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            InventoryTypeModel *secModel = self.addressSecondLevelArray[menuRow];
            if (secModel.children.count > 0) {//有三级选项(第一级没显示)
                [self.addressThirdLevelArray removeAllObjects];
                for (NSDictionary *thirdDic in secModel.children) {
                    InventoryTypeModel *thirdModel = [InventoryTypeModel mj_objectWithKeyValues:thirdDic];
                    [self.categoryThirdLevelArray addObject:thirdModel];//点击的第二级数据行对应的第三级数据源
                    [thirdTitleArr addObject:thirdModel.text];//点击的第二级数据行对应的第三级标题数据源
                }
                ZWPullMenuView *secondMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:thirdTitleArr];
                secondMenuView.zwPullMenuStyle = PullMenuLightStyle;
                __weak typeof(secondMenuView) weakSecondMenuView = secondMenuView;
                weakSecondMenuView.blockSelectedMenu = ^(NSInteger menuRow) {
//                    NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
                    curruntCell.contentField.text = weakSecondMenuView.titleArray[menuRow];
                    InventoryTypeModel *model = self.categoryThirdLevelArray[menuRow];
                    self.addressCode = model.treeCode;
                };
            }else {//没有三级选项
                
                curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
                self.addressCode = secModel.treeCode;
            }
        };
    }else if(sender.tag == 109){//计量单位
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:@[@"台",@"个",@"箱",@"支",@"袋",@"条"]];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
        };
    } else{//保管人列表
        NSMutableArray *titleArr = [NSMutableArray array];//标题数组
        for (CcUserModel *model in self.savePersonArray) {
            [titleArr addObject:model.trueName];
        }
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:titleArr];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
            CcUserModel *infoModel = self.savePersonArray[menuRow];
            self.savePersonId = infoModel.info_id;
        };
    }
    
}
//设置列表行为不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 50 || textField.tag == 52 || textField.tag == 54) {
            return false;
    }
    return true;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
//4.第四步是关键一步，将tableView中正在编辑的textFiled的代理设成self.在代理方法中做如下处理：
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.tableView];
}
//5.在keyBoardWillShowWithNotification处理键盘弹出事件
- (void)keyBoardWillShowWithNotification:(NSNotification *)notification {
    //取出键盘最终的frame
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花费的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取最佳位置距离屏幕上方的距离
    if ((self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height-64)) {//键盘的高度 高于textView的高度 需要滚动,减64为了适应自定义键盘
        NSInteger nvaBarHeight;
        if (kScreenH > 736) {//iPhone X
            nvaBarHeight = 88;
        }else{
            nvaBarHeight = 64;
        }
        [UIView animateWithDuration:duration animations:^{
            self.tableView.contentOffset = CGPointMake(0, nvaBarHeight + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height)+20);
        }];
    }
}
//6.在KeyboardWillHideNotification处理键盘收起事件
- (void)KeyboardWillHideNotification:(NSNotification *)notification {
    //取出键盘弹出需要花费的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.tableView.contentOffset = CGPointMake(0,0);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
#pragma mark -懒加载

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

-(NSMutableArray *)addressSecondLevelArray{
    if (_addressSecondLevelArray == nil) {
        _addressSecondLevelArray = [NSMutableArray array];
    }
    return _addressSecondLevelArray;
}
-(NSMutableArray *)addressThirdLevelArray{
    if (_addressThirdLevelArray == nil) {
        _addressThirdLevelArray = [NSMutableArray array];
    }
    return _addressThirdLevelArray;
}
-(NSMutableArray *)savePersonArray{
    if (_savePersonArray == nil) {
        _savePersonArray = [NSMutableArray array];
    }
    return _savePersonArray;
}
#pragma -viewAppear\disappear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //3.注册键盘通知
    //.监听键盘弹出、收起事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
//7.移除键盘监听
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除键盘监听 直接按照通知名字去移除键盘通知, 这是正确方式
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
