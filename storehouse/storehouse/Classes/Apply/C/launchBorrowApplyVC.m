//
//  launchBorrowApplyVC.m
//  storehouse
//
//  Created by 万宇 on 2018/9/7.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "launchBorrowApplyVC.h"
#import "LaunchBaseTVCell.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import "LaunchFormTVCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "storeThingsModel.h"
#import "WMHCalendarView.h"

static NSString* tableCellid = @"table_cell";
static NSString* listCell = @"listCell";
@interface launchBorrowApplyVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,weak)UITableView *storeTableView;//仓库可领用物料列表
@property(nonatomic,weak)UIView *backView;//背景阴影view
@property(nonatomic,strong)NSMutableArray *storeThingsArr;//库房物品列表数据
@property(nonatomic,strong)NSMutableArray *selectedThingsArr;//选中的库房物品列表数据

@end

@implementation launchBorrowApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(addLaunchBtnClick:)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"备注说明",@"借用时间",@"归还时间",nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    [self.tableView registerClass:[LaunchFormTVCell class] forCellReuseIdentifier:listCell];
    self.title = @"借用申请";
}
//采购申请提交网络请求
- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
    LaunchBaseTVCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *comment = @"";//备注说明
    if (cell3.contentField.text.length > 0) {
        comment = cell3.contentField.text;
    }
    
    NSString *assetsIds = @"";//领用物品编号拼写
    if (self.selectedThingsArr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请添加领用物品"];
        return;
    }else{
        for (int i = 0; i < self.selectedThingsArr.count; i++) {
            storeThingsModel *selModel = self.selectedThingsArr[i];
            if (i == 0) {
                assetsIds = [NSString stringWithFormat:@"%@%@",assetsIds,selModel.info_id];
            }else{
                assetsIds = [NSString stringWithFormat:@"%@,%@",assetsIds,selModel.info_id];
            }
            
        }
    }
    //借用时间
    LaunchBaseTVCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *borrowDate = @"";//备注说明
    if (cell4.contentField.text.length > 0) {
        borrowDate = cell4.contentField.text;
    }else{
        [SVProgressHUD showInfoWithStatus:@"请选取借用时间"];
        return;
    }
    //借用时间
    LaunchBaseTVCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *willReturnDate = @"";//备注说明
    if (cell5.contentField.text.length > 0) {
        willReturnDate = cell5.contentField.text;
    }else{
        [SVProgressHUD showInfoWithStatus:@"请选取归还时间"];
        return;
    }
    //http://192.168.1.168:8085/mobileapi/assetBorrow/save.do?borrowDate=2018-08-17&willReturnDate=2018-08-27&assetsIds=1,2
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@&borrowDate=%@&willReturnDate=%@&assetsIds=%@&comment=%@",mLaunchBorrowStoreThings,borrowDate,willReturnDate,assetsIds,comment];
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
#pragma mark- 懒加载
-(UITableView *)storeTableView{
    if (_storeTableView == nil) {
        //添加tableView
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [self.view.window addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        backView.userInteractionEnabled = YES;
        //添加tap手势：
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        [backView addGestureRecognizer:tapGesture];
        self.backView = backView;
        UITableView *storeTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [self.view.window addSubview:storeTableView];
        [storeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.left.offset(30);
            make.right.offset(-30);
            make.height.offset(370);
        }];
        storeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [storeTableView registerClass:[LaunchFormTVCell class] forCellReuseIdentifier:listCell];
        storeTableView.delegate =self;
        storeTableView.dataSource = self;
        storeTableView.rowHeight = UITableViewAutomaticDimension;
        storeTableView.estimatedRowHeight = 35;
        storeTableView.backgroundColor = [UIColor whiteColor];
        storeTableView.layer.cornerRadius = 10;
        storeTableView.layer.masksToBounds = true;
        //        storeTableView.layer.borderColor = [UIColor colorWithHexString:@"373a41"].CGColor;
        [self setBorderWithView:storeTableView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"373a41"] borderWidth:5];
        _storeTableView = storeTableView;
    }
    return _storeTableView;
}
-(NSMutableArray *)selectedThingsArr{
    if (_selectedThingsArr == nil) {
        _selectedThingsArr = [NSMutableArray array];
    }
    return _selectedThingsArr;
}

//- (void)setApplyType:(NSInteger)applyType{
//    _applyType = applyType;
//    if (_applyType == 1) {
//        self.title = @"领用申请";
//        self.itemLabel.text = @"领用明细";
//    }else{
//        self.title = @"借用申请";
//        self.itemLabel.text = @"借用明细";
//    }
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
        return self.selectedThingsArr.count;
    }else{
        return self.storeThingsArr.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            LaunchBaseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
            CcUserModel *user = [CcUserModel defaultClient];
            if (indexPath.row == 0) {
                cell.contentField.text = user.departmentName;
            }
            if (indexPath.row == 1) {
                cell.contentField.text = user.trueName;
            }
            if ( indexPath.row == 3 || indexPath.row == 4) {
                cell.listButton.hidden = false;
                cell.listButton.tag = 100+indexPath.row;
                [cell.listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.contentField.tag = 50+indexPath.row;
            }
            cell.contentField.delegate = self;
            cell.itemLabel.text = self.itemTypeArray[indexPath.row];
            
            return cell;
        }else{
            LaunchFormTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
            storeThingsModel *model = self.selectedThingsArr[indexPath.row];
            cell.selectedThingsModel = model;
            //        //block传递选中删除领用结果
            //        __weak typeof(self) weakSelf = self;
            //        __weak typeof(cell) weakCell = cell;
            //        cell.ifSelectedBlock = ^(storeThingsModel *selModel, BOOL btnSelected) {
            //            if (btnSelected) {//选中
            //                [weakSelf.selectedThingsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                    storeThingsModel *model = obj;
            //                    if (selModel.info_id == model.info_id && selModel.assetType == model.assetType) {
            //                        [weakSelf.selectedThingsArr removeObject:model];
            //                        weakCell.selectedThingsModel = selModel;
            //                        //去除库房物品列表对应物品选中效果
            //                        for (int i = 0; i < weakSelf.storeThingsArr.count; i++) {
            //                            storeThingsModel *model = weakSelf.storeThingsArr[i];
            //                                if (selModel.info_id == model.info_id && selModel.assetType == model.assetType) {
            //                                    LaunchFormTVCell *cell = [weakSelf.storeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            //                                    cell.selBtn.selected = false;
            //                                    cell.selView.backgroundColor = [UIColor whiteColor];
            //                                }
            //                        }
            //
            //                    }
            //                }];
            //            }else{//去除选中
            //                if (weakSelf.selectedThingsArr.count == 0){
            //                    [weakSelf.selectedThingsArr addObject:selModel];
            //                }else{
            //                    BOOL ifHas = false;
            //                    for (storeThingsModel *model in weakSelf.selectedThingsArr) {//去重
            //                        if (selModel.info_id == model.info_id && selModel.assetType == model.assetType) {
            //                            ifHas = true;
            //                        }
            //                    }
            //                    if(!ifHas){
            //                        [weakSelf.selectedThingsArr addObject:selModel];
            //                    }
            //                }
            //                //添加库房物品列表对应物品选中效果
            //                for (int i = 0; i < weakSelf.storeThingsArr.count; i++) {
            //                    storeThingsModel *model = weakSelf.storeThingsArr[i];
            //                    if (selModel.info_id == model.info_id && selModel.assetType == model.assetType) {
            //                        LaunchFormTVCell *cell = [weakSelf.storeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            //                        cell.selBtn.selected = true;
            //                        cell.selView.backgroundColor = [UIColor colorWithHexString:@"373a41"];
            //                    }
            //                }
            //            }
            //
            //        };
            return cell;
        }
    }else{//tableView == storeTableview
        LaunchFormTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
        storeThingsModel *model = self.storeThingsArr[indexPath.row];
        cell.storeThingModel = model;
        //block传递选中领用结果
        __weak typeof(self) weakSelf = self;
        cell.ifSelectedBlock = ^(storeThingsModel *selModel, BOOL btnSelected) {
            if (btnSelected) {//选中
                if (weakSelf.selectedThingsArr.count == 0){
                    [weakSelf.selectedThingsArr addObject:selModel];
                }else{
                    BOOL ifHas = false;
                    for (storeThingsModel *model in weakSelf.selectedThingsArr) {//去重
                        if (selModel.info_id == model.info_id && selModel.assetType == model.assetType) {
                            ifHas = true;
                        }
                    }
                    if(!ifHas){
                        [weakSelf.selectedThingsArr addObject:selModel];
                    }
                }
            }else{//去除选中
                if (weakSelf.selectedThingsArr.count > 0) {
                    [weakSelf.selectedThingsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        storeThingsModel *model = obj;
                        if (selModel.info_id == model.info_id && selModel.assetType == model.assetType) {
                            [weakSelf.selectedThingsArr removeObject:model];
                        }
                    }];
                    
                }
            }
            
        };
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
        return 35;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 0;
        }
        return 70;
    }else{
        return 40;
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
        //事项label
        UILabel *itemLabel = [UILabel labelWithText:@"借用明细" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        [headerView addSubview:itemLabel];
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_top).offset(17.5);
            make.left.offset(15);
            make.width.offset(60);
        }];
        itemLabel.text = @"借用明细";
        //删除button
        UIButton *delBtn = [[UIButton alloc]init];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [delBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
        [delBtn setTitle:@"增加/删除" forState:UIControlStateNormal];
        [headerView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.width.offset(80);
            make.height.offset(35);
        }];
        [delBtn addTarget:self action:@selector(increaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //    //增加button
        //    UIButton *increaseBtn = [[UIButton alloc]init];
        //    increaseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //    [increaseBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
        //    [increaseBtn setTitle:@"增加" forState:UIControlStateNormal];
        //    [headerView addSubview:increaseBtn];
        //    [increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.offset(0);
        //        make.width.offset(60);
        //        make.height.offset(35);
        //        make.right.equalTo(delBtn.mas_left);
        //    }];
        //    [increaseBtn addTarget:self action:@selector(increaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //空白格
        UIView *emptyView = [[UIView alloc]init];
        emptyView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.offset(0);
            make.width.height.offset(35);
        }];
        //编号label
        UILabel *departmentLabel = [UILabel labelWithText:@"编号" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
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
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-60, 40)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        //空白格
        UIView *emptyView = [[UIView alloc]init];
        emptyView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.offset(0);
            make.width.offset(35);
        }];
        //编号label
        UILabel *departmentLabel = [UILabel labelWithText:@"编号" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        departmentLabel.backgroundColor = [UIColor whiteColor];
        departmentLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:departmentLabel];
        [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(emptyView.mas_right);
            make.width.offset(100);
            make.top.bottom.offset(0);
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
            make.top.bottom.offset(0);
        }];
        //物品名称label
        UILabel *goodsNameLabel = [UILabel labelWithText:@"名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        goodsNameLabel.backgroundColor = [UIColor whiteColor];
        goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:goodsNameLabel];
        [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(ApplicantLabel.mas_right);
            make.right.offset(0);
            make.top.bottom.offset(0);
        }];
        [headerView layoutIfNeeded];
        [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:ApplicantLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        
        return headerView;
        
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return nil;
    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-60, 70)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    //确定button
    UIButton *confirmBtn = [[UIButton alloc]init];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [headerView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(80);
        make.height.offset(40);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 0;
    }else{
        return 70;
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
//增加/删除按钮点击事件
-(void)increaseBtnClick:(UIButton*)sender{
    [self requestmStoreThingsList];
}
////删除按钮点击事件
//-(void)delBtnClick:(UIButton*)sender{
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}
//确定按钮点击事件
-(void)confirmBtnClick:(UIButton*)sender{
    self.storeTableView.hidden = true;
    self.backView.hidden = true;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
//列表日期选择按钮点击事件
-(void)listButtonClick:(UIButton*)sender{
    WMHCalendarView *caView = [WMHCalendarView initCalendarViewWithShowView:self.view sureBtnTitleStr:@"确认" buttonIndex:^(NSString *dateStr) {
        NSLog(@"%@",dateStr);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-100 inSection:0];
        LaunchBaseTVCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.contentField.text = dateStr;
    }];
    [self.view addSubview:caView];
}
//设置列表行为不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        if (textField.tag == 52 || textField.tag == 53) {
            return false;
        }
    return true;
}
//设置列表行为不可编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    self.backView.hidden = true;
    self.storeTableView.hidden = true;
}
#pragma mark -request
/**
 *  请求仓库可用物品列表
 */
- (void)requestmStoreThingsList
{
    [SVProgressHUD show];// 动画开始
    
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:mStoreThingsList method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.storeThingsArr = mArr;
            [self.storeTableView reloadData];
            self.storeTableView.hidden = false;
            self.backView.hidden = false;
            
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        [SVProgressHUD dismiss];
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
