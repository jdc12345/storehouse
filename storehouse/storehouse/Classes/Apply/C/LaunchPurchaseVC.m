//
//  LaunchPurchaseVC.m
//  storehouse
//
//  Created by 万宇 on 2018/7/23.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchPurchaseVC.h"
#import "LaunchBaseTVCell.h"
#import "ZWPullMenuView.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "NSString+URL.h"

static NSString* tableCellid = @"table_cell";
@interface LaunchPurchaseVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,assign) CGRect activedTextFieldRect;//2.当前正在编辑的textField的frame相对于tableView的位置
@end

@implementation LaunchPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"采购申请";
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(addLaunchBtnClick:)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"采购数量",@"生产厂家",@"采购类别",@"采购理由", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    //1.设置tableView的键盘退出模式：
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
       
}
//采购申请提交网络请求
- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
    LaunchBaseTVCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell1.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你所在的部门"];
        return;
    }
    LaunchBaseTVCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell2.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你申请的物品名称"];
        return;
    }
    LaunchBaseTVCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    LaunchBaseTVCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (cell4.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你申请物品的计量单位"];
        return;
    }
    
    LaunchBaseTVCell *cell6 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (cell6.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写你申请的物品采购数量"];
        return;
    }
    LaunchBaseTVCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    LaunchBaseTVCell *cell8 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (cell8.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你申请的物品采购类别"];
        return;
    }
    LaunchBaseTVCell *cell9 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    
//    NSString *info_id = [CcUserModel defaultClient].info_id;
    NSString *departmentCode = cell1.contentField.text;//申请部门
    NSString *assetName = cell2.contentField.text;//物品名称
    NSString *specTyp = cell3.contentField.text;//规格型号
    NSString *unit = cell4.contentField.text;//计量单位
//    NSString *worth = cell5.contentField.text;//预算价格
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
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@/mobileapi/buyApply/save.do?&companyId=1&departmentCode=%@&assetName=%@&specTyp=%@&unit=%@&buyCount=%@&producerName=%@&buyCate=%@&buyReason=%@",mPrefixUrl,departmentCode,assetName,specTyp,unit,buyCount,producerName,buyCate,buyReason];
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
    if (indexPath.row == 0) {
        CcUserModel *user = [CcUserModel defaultClient];
        cell.contentField.text = user.departmentName;
    }
    if (indexPath.row == 4) {
        cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if ( indexPath.row == 3 || indexPath.row == 6) {
        cell.listButton.hidden = false;
        cell.listButton.tag = 100+indexPath.row;
        [cell.listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentField.tag = 50+indexPath.row;
    }
    if (indexPath.row == 2 || indexPath.row == 5  || indexPath.row == 7) {
        cell.contentField.placeholder = @"选填";
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
    if (sender.tag == 100) {
//        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:@[@"软件部",@"财务部",@"行政部",@"人力资源部"]];
//        menuView.zwPullMenuStyle = PullMenuLightStyle;
//        __weak typeof(menuView) weakMenuView = menuView;
//        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
//            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
//        };
    }else if (sender.tag == 103){
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:@[@"台",@"个",@"箱",@"支",@"袋",@"条"]];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
        };
    }else{
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:@[@"计划内",@"计划外"]];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
//            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
        };
    }
    
}
//设置列表行为不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField.tag == 50 || textField.tag == 53 || textField.tag == 57) {
//        return false;
//    }
    [textField resignFirstResponder];
    return true;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的(自定义)
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
