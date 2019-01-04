//
//  InventoryDetailVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/11.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "InventoryDetailVC.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "storeThingsModel.h"
#import "InventoryAssetModel.h"
#import "ApplyDetailTVCell.h"
#import "InventoryAssetsFormTVCell.h"
#import "AssetDetailVC.h"

static NSString* tableCellid = @"table_cell";
static NSString* listCell = @"listCell";
static NSString* inventoryingCell = @"inventorying_Cell";
@interface InventoryDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,barCodeDelegate>//4.遵守代理协议
@property (nonatomic, strong) NSArray *itemTypeArray;//盘点整体事项名称
@property (nonatomic, strong) NSArray *inventoryingItemArr;//正在盘点资产属性名称
@property(nonatomic,weak)UITableView *inventoryingTableView;//正在盘点的资产盘点详情view
@property(nonatomic,weak)UIView *backView;//背景阴影view
//@property(nonatomic,strong)NSMutableArray *storeThingsArr;//库房物品列表数据
@property(nonatomic,strong)NSMutableArray *inventoryAssetsArr;//选中的库房物品列表数据
@property(nonatomic,weak)UITextField *contentField;//实盘数量输入框
@property(nonatomic,strong)InventoryAssetModel *InventoryingModel;//正在盘点的资产model
@property(nonatomic,assign) CGRect activedTextFieldRect;//盘点中的已盘点数量textfield的相对rect
@property (nonatomic, copy) NSString *closedDateString;//结案日期
@end

@implementation InventoryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"结案" style:UIBarButtonItemStylePlain target:self action:@selector(addLaunchBtnClick:)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"盘点主题",@"盘点说明", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
    [self.tableView registerClass:[InventoryAssetsFormTVCell class] forCellReuseIdentifier:listCell];
    self.title = @"盘点详情";
    [self requestInventoryDetail];
}
//结案网络请求
- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
    if (self.closedDateString.length > 0) {
        [SVProgressHUD showInfoWithStatus:@"该盘点已结案"];
        return;
    }else{
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@id=%@&isClosed=isClosed",mInventoryOverRequest,self.infoModel.info_id];
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {

            [SVProgressHUD showSuccessWithStatus:@"结案成功"];
            self.closedDateString = @"1";//代表已结案
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
}
#pragma mark- 懒加载
-(UITableView *)inventoryingTableView{
    if (_inventoryingTableView == nil) {
        //添加tableView
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [self.view addSubview:backView];
        [self.view bringSubviewToFront:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        backView.userInteractionEnabled = YES;
        //添加tap手势：
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        [backView addGestureRecognizer:tapGesture];
        self.backView = backView;
        self.inventoryingItemArr = [NSArray arrayWithObjects:@"资产编码",@"资产名称",@"资产保管人",@"资产存放地",@"待盘数量",@"实盘数量",nil];
        UITableView *storeTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        //1.设置tableView的键盘退出模式：
        storeTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //2.监听键盘弹出事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];

        [self.view addSubview:storeTableView];
        [self.view bringSubviewToFront:storeTableView];
        [storeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.left.offset(30);
            make.right.offset(-30);
            make.height.offset(310);
        }];
        storeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [storeTableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:inventoryingCell];
        storeTableView.delegate =self;
        storeTableView.dataSource = self;
        storeTableView.rowHeight = UITableViewAutomaticDimension;
        storeTableView.estimatedRowHeight = 35;
        storeTableView.backgroundColor = [UIColor whiteColor];
        storeTableView.layer.cornerRadius = 10;
        storeTableView.layer.masksToBounds = true;
        //        storeTableView.layer.borderColor = [UIColor colorWithHexString:@"373a41"].CGColor;
        [self setBorderWithView:storeTableView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"373a41"] borderWidth:5];
        _inventoryingTableView = storeTableView;
        storeTableView.tableFooterView = [self setFooterView];
    }
    return _inventoryingTableView;
}
//添加搜索列表的尾部view
-(UIView *)setFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-60, 70)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    //确定button
    UIButton *confirmBtn = [[UIButton alloc]init];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [footerView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(80);
        make.height.offset(40);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
-(NSMutableArray *)inventoryAssetsArr{
    if (_inventoryAssetsArr == nil) {
        _inventoryAssetsArr = [NSMutableArray array];
    }
    return _inventoryAssetsArr;
}
//添加搜索栏
//- (UITextField *)setSearchBar{
//    //输入框
//    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 60, 35)];
//    searchField.delegate = self;
//    self.searchField = searchField;
//    searchField.clearButtonMode = UITextFieldViewModeAlways;//删除内容的❎
//    [searchField setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
//    //输入框左侧放大镜
//    UIImage *image = [UIImage imageNamed:@"assestManage_search"];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    [imageView sizeToFit];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width+5, imageView.frame.size.height)];
//    [view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(5);
//        make.top.right.bottom.offset(0);
//    }];
//    searchField.leftView = view;
//    searchField.placeholder = @"请输入资产名称";
//    [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
//    searchField.returnKeyType = UIReturnKeySearch;
//    searchField.rightViewMode = UITextFieldViewModeAlways;
//    [searchField.layer setMasksToBounds:YES];
//    [searchField.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//    //边框宽度
//    [searchField.layer setBorderWidth:0.8];
//    searchField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
//    return searchField;
//}
//添加搜索列表的尾部view
//-(UIView *)setFooterView{
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-60, 70)];
//    footerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    //确定button
//    UIButton *confirmBtn = [[UIButton alloc]init];
//    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
//    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [footerView addSubview:confirmBtn];
//    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.offset(0);
//        make.width.offset(80);
//        make.height.offset(40);
//    }];
//    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    return footerView;
//}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return 2;
    }else{
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section == 0) {
            return self.itemTypeArray.count;
        }
        return self.inventoryAssetsArr.count;
    }else{
        return self.inventoryingItemArr.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
            
            cell.itemLabel.text = self.itemTypeArray[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.itemContentLabel.text = self.infoModel.subject;
                    break;
                case 1:
                    cell.itemContentLabel.text = self.infoModel.info_description;
                    break;
            }
            return cell;
        }else{
            InventoryAssetsFormTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
            InventoryAssetModel *model = self.inventoryAssetsArr[indexPath.row];
            cell.inventoryAssetModel = model;            
            return cell;
        }
    }else{//tableView == inventoryingTableview
        ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:inventoryingCell forIndexPath:indexPath];
        cell.itemLabel.text = self.inventoryingItemArr[indexPath.row];
        switch (indexPath.row) {
            case 0://编码
                cell.itemContentLabel.text = self.InventoryingModel.barcode;
                break;
            case 1://资产名称
                cell.itemContentLabel.text = self.InventoryingModel.assetsName;
                break;
            case 2://资产保管人
                cell.itemContentLabel.text = self.InventoryingModel.saveUserName;
                break;
            case 3://资产存放地
                cell.itemContentLabel.text = self.InventoryingModel.orgAddressName;
                break;
            case 4://待盘数量
                cell.itemContentLabel.text = self.InventoryingModel.num;
                break;
            case 5://待盘数量
                cell.contentField.hidden = false;
                cell.itemContentLabel.text = @"";
                cell.contentField.text = self.InventoryingModel.inventoryNum;
                self.contentField = cell.contentField;
                cell.contentField.delegate = self;
                break;
            default:
                break;
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 44;
        }else{
            return 35;
        }
    }else{
        return 40;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (tableView == self.tableView && indexPath.section == 1) {
        InventoryAssetsFormTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        InventoryAssetModel *model = cell.inventoryAssetModel;
        AssetDetailVC *vc = [[AssetDetailVC alloc]init];
        vc.info_id = model.assetsId;
        vc.ifFromInventory = true;
        [self.navigationController pushViewController:vc animated:true];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 0;
        }
        return 70;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //横线1
    UIView *wLine1 = [[UIView alloc]init];
    wLine1.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
    [headerView addSubview:wLine1];
    [wLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(1);
    }];
//    扫码盘点btn
    UIButton *delBtn = [[UIButton alloc]init];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [delBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
    [delBtn setTitle:@"扫码盘点" forState:UIControlStateNormal];
    [headerView addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.width.offset(80);
        make.height.offset(35);
    }];
    [delBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //待盘数量label
    UILabel *willLabel = [UILabel labelWithText:@"待盘数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    willLabel.backgroundColor = [UIColor whiteColor];
    willLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:willLabel];
    [willLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.width.offset(70);
        make.height.offset(35);
    }];
        //已盘数量label
    UILabel *hadLabel = [UILabel labelWithText:@"已盘数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    hadLabel.backgroundColor = [UIColor whiteColor];
    hadLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:hadLabel];
    [hadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(willLabel.mas_right);
        make.width.offset(70);
        make.height.offset(35);
    }];
    //资产名称label
    UILabel *assetLabel = [UILabel labelWithText:@"资产名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    assetLabel.backgroundColor = [UIColor whiteColor];
    assetLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:assetLabel];
    [assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(hadLabel.mas_right);
        make.width.offset(70);
        make.height.offset(35);
    }];
    //保管人label
    UILabel *saverLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    saverLabel.backgroundColor = [UIColor whiteColor];
    saverLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:saverLabel];
    [saverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(assetLabel.mas_right);
        make.width.offset(70);
        make.height.offset(35);
    }];
    //存放地label
    UILabel *addressLabel = [UILabel labelWithText:@"存放地" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    addressLabel.backgroundColor = [UIColor whiteColor];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(saverLabel.mas_right);
        make.width.offset(kScreenW-280);
        make.height.offset(35);
    }];
    [headerView layoutIfNeeded];
    [self setBorderWithView:willLabel top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:hadLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:assetLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:saverLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:addressLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
 
        return headerView;
    }else{

        return nil;

    }
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
//扫码盘点按钮点击事件
-(void)scanBtnClick:(UIButton*)sender{
    if (self.closedDateString.length > 0) {
        [SVProgressHUD showInfoWithStatus:@"该盘点已结案不能进行操作"];
    }else{
        InventoryScanVC *vc = [[InventoryScanVC alloc]init];
        [self.navigationController pushViewController:vc animated:true];
    }
}
////删除按钮点击事件
//-(void)delBtnClick:(UIButton*)sender{
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}
//确定按钮点击事件
-(void)confirmBtnClick:(UIButton*)sender{
//    执行盘点操作,扫码盘点，手工盘点接口
    [SVProgressHUD show];// 动画开始
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@id=%@&inventoryNum=%@",mInventoryScanConfirmRequest,self.InventoryingModel.info_id,self.InventoryingModel.inventoryNum];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            self.inventoryingTableView.hidden = true;
            self.backView.hidden = true;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    
}
#pragma mark - textFieldDelegate
////设置列表行为不可编辑
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField == self.searchField) {//searchBar
//        [self requestmStoreThingsListWith:textField.text];
//    }
//    return [textField resignFirstResponder];
//}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
//}
//
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{//输入文字时 一直监听
//
//    if (textField != self.searchField&&textField.text.length == 0 && [string isEqualToString:@"0"]) {
//        return NO;
//    }
//    return YES;
//}
//
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    //    if (textField != self.searchField) {
    if ([textField.text integerValue] > 0 || [textField.text integerValue] == 0) {//领用数量必须大于0
        self.InventoryingModel.inventoryNum = textField.text;
        return true;

    }else{
        return false;
    }
    
}
//-(BOOL)textFieldShouldClear:(UITextField *)textField{
//    //    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
//    return true;
//}
//3.第三步是关键一步，将tableView中正在编辑的textFiled的代理设成self.在代理方法中做如下处理：
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.backView];
}
//4.在keyBoardWillShowWithNotification处理键盘弹出事件
- (void)keyBoardWillShowWithNotification:(NSNotification *)notification {
    //取出键盘最终的frame
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花费的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取最佳位置距离屏幕上方的距离
    if ((self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height)) {//键盘的高度 高于textView的高度 需要滚动
        [UIView animateWithDuration:duration animations:^{
            self.inventoryingTableView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height));
        }];
    }
}
-(void)dealloc{
    //第一种方法.这里可以移除该控制器下的所有通知
    // 移除当前所有通知
//    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    //第二种方法.这里可以移除该控制器下名称为tongzhi的通知
//    //移除名称为tongzhi的那个通知
//    NSLog(@"移除了名称为tongzhi的通知");
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    self.backView.hidden = true;
    self.inventoryingTableView.hidden = true;
//    [self.searchField resignFirstResponder];
}
#pragma mark -barcodeDelegate
//5.执行代理协议
-(void)returnBarCode:(NSString *)barCode{
    BOOL ifEffective = false;//是否是盘点中的二维码
    for (InventoryAssetModel *model in self.inventoryAssetsArr) {
        if ([model.barcode isEqualToString:barCode]) {
            self.InventoryingModel = model;
            [self.inventoryingTableView reloadData];
            ifEffective = true;
        }
    }
    if (ifEffective) {
        //是盘点中的二维码
        self.backView.hidden = false;
        self.inventoryingTableView.hidden = false;
    }else{
        //不是盘点中的二维码
        [SVProgressHUD showInfoWithStatus:@"该码不属于这次盘点内容"];
    }
}
#pragma mark -request
/**
 *  请求盘点详情
 */
- (void)requestInventoryDetail
{
    [SVProgressHUD show];// 动画开始
    
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@id=%@",mInventoryDetailRequest,self.infoModel.info_id];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *inventoryDic = dic[@"inventory"];
            self.closedDateString = inventoryDic[@"closedDateString"];
            NSArray *listArr = inventoryDic[@"assetList"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                InventoryAssetModel *infoModel = [InventoryAssetModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.inventoryAssetsArr = mArr;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [self.tableView reloadData];
                
            });
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
////下拉刷新
//-(void)refreshHeader{
//    [SVProgressHUD show];// 动画开始
//    __weak typeof(self) weakSelf = self;
//    HttpClient *httpManager = [HttpClient defaultClient];
//    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
//    [SVProgressHUD show];
//    //    http://192.168.1.168:8085/mobileapi/asset/fpRecipients.do?name=搜索内容
//    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=0&limit=6",mStoreThingsList,self.searchField.text];
//    //把搜索中文转义
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            NSArray *listArr = dic[@"rows"];
//            NSMutableArray *mArr = [NSMutableArray array];
//            for (NSDictionary *dic in listArr) {
//                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
//                infoModel.isSelected = false;//一开始请求回来数据是非选中状态
//                [mArr addObject:infoModel];
//            }
//            weakSelf.storeThingsArr = mArr;
//            if (weakSelf.storeThingsArr.count>0) {
//                start = weakSelf.storeThingsArr.count;
//            }
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // UI更新代码
//                [weakSelf.searchField resignFirstResponder];
//                [weakSelf.storeTableView reloadData];
//                [weakSelf.storeTableView.mj_header endRefreshing];
//                if (start < 6) {//没有更多数据了
//                    [weakSelf.storeTableView.mj_footer endRefreshingWithNoMoreData];
//                }else{//有更多数据
//                    weakSelf.storeTableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
//                }
//            });
//
//        }else if ([dic[@"code"] isEqualToString:@"-1"]){
//            [weakSelf.storeTableView.mj_header endRefreshing];
//            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//        return ;
//    }];
//}
////上拉刷新
//-(void)refreshFooter{
//    [SVProgressHUD show];// 动画开始
//    __weak typeof(self) weakSelf = self;
//    HttpClient *httpManager = [HttpClient defaultClient];
//    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
//    [SVProgressHUD show];
//    //    http://192.168.1.168:8085/mobileapi/asset/fpRecipients.do?name=搜索内容
//    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=%ld&limit=6",mStoreThingsList,self.searchField.text,(long)start];
//    //把搜索中文转义
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            NSArray *listArr = dic[@"rows"];
//            NSMutableArray *mArr = [NSMutableArray array];
//            for (NSDictionary *dic in listArr) {
//                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
//                infoModel.isSelected = false;//一开始请求回来数据是非选中状态
//                [mArr addObject:infoModel];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // UI更新代码
//                if (mArr.count>0) {
//                    [weakSelf.storeThingsArr addObjectsFromArray:mArr];
//                    start = weakSelf.storeThingsArr.count;
//
//                    [weakSelf.storeTableView reloadData];
//                    if (start % 6 != 0) {
//                        [weakSelf.storeTableView.mj_footer endRefreshingWithNoMoreData];
//                    }else{
//                        [weakSelf.storeTableView.mj_footer endRefreshing];
//                    }
//                }else{
//                    [weakSelf.storeTableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            });
//
//        }else if ([dic[@"code"] isEqualToString:@"-1"]){
//            [weakSelf.storeTableView.mj_header endRefreshing];
//            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//        return ;
//    }];
//}


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
