//
//  OutPutBorrowDetailVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/27.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "OutPutBorrowDetailVC.h"
#import "ApplyDetailTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "GetApplyDetailModel.h"
#import "ApproveDetailAssetModel.h"
#import "ApproveDetailAssetTVCell.h"
#import "UILabel+Addition.h"

static NSString* tableCellid = @"table_cell";
static NSString* assetCellid = @"table_assetCellid";
@interface OutPutBorrowDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) NSMutableArray *assetsArray;//申请相关资产列表
@property (nonatomic, strong) borrowApplyDetailModel *borrowModel;//请求的借用申请数据模型

@end

@implementation OutPutBorrowDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"借用申请";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
    [self.tableView registerClass:[ApproveDetailAssetTVCell class] forCellReuseIdentifier:assetCellid];
    
}
-(void)setModel:(borrowApplyDetailModel *)model{
    _model = model;
    [SVProgressHUD show];// 动画开始
    //http://192.168.1.168:8085/mobileapi/buyApply/get.do?id=1
    //    msgStatus：消息状态, 0=审批中，1=已审批
    
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"借用备注",@"借用时间",@"预归还时间",@"申请时间",nil];
    NSString *listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetBorrowDetail,model.info_id];
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *getApplyDic = dic[@"assetBorrow"];
            borrowApplyDetailModel *model = [borrowApplyDetailModel mj_objectWithKeyValues:getApplyDic];
            if (model.assetList.count > 0) {
                [self.assetsArray removeAllObjects];
                for (NSDictionary *assetDic in model.assetList) {
                    ApproveDetailAssetModel *assetModel = [ApproveDetailAssetModel mj_objectWithKeyValues:assetDic];
                    [self.assetsArray addObject:assetModel];
                }
            }
            self.borrowModel = model;
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
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.itemTypeArray.count;//
    }else{
        return self.assetsArray.count;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        
        cell.itemLabel.text = self.itemTypeArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.itemContentLabel.text = self.borrowModel.departmentName;
                break;
            case 1:
                cell.itemContentLabel.text = self.borrowModel.userName;
                break;
            case 2:
                cell.itemContentLabel.text = self.borrowModel.comment;
                break;
            case 3:
                cell.itemContentLabel.text = self.borrowModel.borrowDateString;
                break;
            case 4:
                cell.itemContentLabel.text = self.borrowModel.willReturnDateString;
                break;
            case 5:
                cell.itemContentLabel.text = self.borrowModel.gmtCreateString;
                break;
                
            default:
                break;
        }
        
        return cell;
    }else{
        ApproveDetailAssetTVCell *cell = [tableView dequeueReusableCellWithIdentifier:assetCellid forIndexPath:indexPath];
        cell.outboundDateString = self.borrowModel.outboundDateString;//必须在model赋值前赋值
        cell.borrowModel = self.assetsArray[indexPath.row];
        if (self.borrowModel.outboundDateString.length < 1) {//未领用
            cell.contentField.tag = [cell.outPutmodel.info_id integerValue] + 50;//为了标记textfield查找对应cell的数据model
            cell.contentField.delegate = self;
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            cell.contentField.enabled = true;//因为和审批公用cell，那边不能编辑,领用过页面也不能显示
        }
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //确定button
    UIButton *confirmBtn = [[UIButton alloc]init];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    confirmBtn.layer.masksToBounds = true;
    confirmBtn.layer.cornerRadius = 5;
    [footerView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.equalTo(footerView.mas_top).offset(95);
        make.width.offset(80);
        make.height.offset(46);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.borrowModel.outboundDateString.length < 1) {//未领用
        [confirmBtn setTitle:@"确定借出" forState:UIControlStateNormal];
        confirmBtn.tag = 70;
    }else if (self.borrowModel.inboundDateString.length < 1){//未归还
        [confirmBtn setTitle:@"确定归还" forState:UIControlStateNormal];
        confirmBtn.tag = 71;
    }
     return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.borrowModel.outboundDateString.length < 1 ||self.borrowModel.inboundDateString.length < 1) {//未领用\未归还
        if (section == 1) {
            return 150;
        }else{
            return 0;
        }
        
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
    return 35;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //空白格
    UIView *emptyView = [[UIView alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.width.height.offset(35);
    }];
    //数量label
    UILabel *departmentLabel = [UILabel labelWithText:@"数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(emptyView.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    //类别label
    UILabel *ApplicantLabel = [UILabel labelWithText:@"类别" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    ApplicantLabel.backgroundColor = [UIColor whiteColor];
    ApplicantLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:ApplicantLabel];
    [ApplicantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    //物品名称label
    UILabel *goodsNameLabel = [UILabel labelWithText:@"名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    goodsNameLabel.backgroundColor = [UIColor whiteColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(ApplicantLabel.mas_right);
        make.width.offset(kScreenW-235);
        make.height.offset(35);
    }];
    [headerView layoutIfNeeded];
    [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:ApplicantLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    
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
#pragma mark - textFieldDelegate
//设置列表行为不可编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//输入文字时 一直监听
    
    //    if (textField != self.searchField&&textField.text.length == 0 && [string isEqualToString:@"0"]) {
    //        return NO;
    //    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    //    if (textField != self.searchField) {
    //    if ([textField.text integerValue] > 0) {//领用数量必须大于0
    
    NSInteger modelId = textField.tag - 50;
    if (self.assetsArray.count > 0) {
        [self.assetsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ApproveDetailAssetModel *model = obj;
            if (modelId == [model.info_id integerValue]) {
                model.totalNum = textField.text;//记录每次编辑的数字，方便刷新之后还是之前的数字
            }
        }];
        
    }
    //    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    //    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}
#pragma mark - btnClick
//确定按钮点击事件
-(void)confirmBtnClick:(UIButton*)sender{
    
    NSInteger ifBigZero = 0;//判断物品不能为空
    NSString *assetsIds = @"";//物品编号拼写
    if (self.assetsArray.count > 0) {
        for (int i = 0; i < self.assetsArray.count; i++) {
            ApproveDetailAssetModel *selModel = self.assetsArray[i];
            if (i == 0) {
                assetsIds = [NSString stringWithFormat:@"%@,%@",selModel.info_id,selModel.totalNum];
            }else{
                assetsIds = [NSString stringWithFormat:@"%@;%@,%@",assetsIds,selModel.info_id,selModel.totalNum];
            }
            ifBigZero += [selModel.totalNum integerValue];
        }
        if (ifBigZero == 0) {
            [SVProgressHUD showInfoWithStatus:@"领用物品数量不能为0"];
            return;
        }
    }
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr;
    if (sender.tag == 70) {//确定借出
        reportUrlStr = [NSString stringWithFormat:@"%@&id=%@&assetsIds=%@",mfpOutPutBorrowOutRequest,self.borrowModel.info_id,assetsIds];
    }else if (sender.tag == 71) {//确定归还
        reportUrlStr = [NSString stringWithFormat:@"%@&id=%@&assetsIds=%@",mfpOutPutBorrowReturnRequest,self.borrowModel.info_id,assetsIds];
    }
  
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            if (sender.tag == 70) {
                [SVProgressHUD showSuccessWithStatus:@"确认借出出库成功"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"确认归还入库成功"];
            }
            
            
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
#pragma mark - 懒加载
-(NSMutableArray *)assetsArray{
    if (_assetsArray == nil) {
        _assetsArray = [NSMutableArray array];
    }
    return _assetsArray;
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
