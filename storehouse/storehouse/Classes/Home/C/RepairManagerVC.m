//
//  RepairManagerVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/21.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "RepairManagerVC.h"
//#import "LaunchBaseTVCell.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
//#import "LaunchFormTVCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
//#import "storeThingsModel.h"
#import <MJRefresh.h>
#import "ApplyDetailTVCell.h"
#import "RepairApplyDetailModel.h"
#import "FittingsListModel.h"
#import "RepairFittingTVCell.h"

static NSString* tableCellid = @"table_cell";
static NSString* listCell = @"listCell";
static NSInteger start = 0;//上拉加载起始位置
@interface RepairManagerVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,weak)UITableView *storeTableView;//仓库可领用物料列表
@property(nonatomic,weak)UIView *backView;//背景阴影view
@property(nonatomic,strong)NSMutableArray *storeThingsArr;//库房物品列表数据
@property(nonatomic,strong)NSMutableArray *selectedThingsArr;//选中的库房物品列表数据
@property(nonatomic,weak)UITextField *searchField;//输入框
@property(nonatomic,strong)RepairApplyDetailModel *repairModel;//维修申请model
@property(nonatomic,weak)UITextField *contentField;//故障说明
@property(nonatomic,weak)UIButton *yesBtn;
@property(nonatomic,weak)UIButton *noBtn;
@property(nonatomic,assign)NSInteger isFixed;//是否维修(0否1是)
@end

@implementation RepairManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //提交按钮
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
    [self.tableView registerClass:[RepairFittingTVCell class] forCellReuseIdentifier:listCell];
    self.tableView.tableFooterView = [self viewForFooter];
}
//设置tableview的尾部视图
-(UIView *)viewForFooter{
    if (self.state == 2) {//维修记录
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        footerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        //事项label
        UILabel *itemLabel = [UILabel labelWithText:@"是否修复" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        [footerView addSubview:itemLabel];
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(15);
            make.width.offset(60);
        }];
        //selbutton
        UIButton *selBtn = [[UIButton alloc]init];
        selBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [selBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
        [footerView addSubview:selBtn];
        [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(95);
            make.width.offset(80);
            make.height.offset(44);
        }];
        [selBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [selBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        if ([self.repairModel.isFixed intValue] == 0) {
            [selBtn setTitle:@"否" forState:UIControlStateNormal];
            selBtn.selected = false;
        }else{
            [selBtn setTitle:@"是" forState:UIControlStateNormal];
            selBtn.selected = true;
        }
        return footerView;
    }else{//待维修
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
        footerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        //事项label
        UILabel *itemLabel = [UILabel labelWithText:@"是否修复" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        [footerView addSubview:itemLabel];
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footerView.mas_top).offset(22);
            make.left.offset(15);
            make.width.offset(60);
        }];
        //yesbutton
        UIButton *yesBtn = [[UIButton alloc]init];
        yesBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [yesBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
        [yesBtn setTitle:@"是" forState:UIControlStateNormal];
        [footerView addSubview:yesBtn];
        [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(itemLabel);
            make.left.offset(95);
            make.width.offset(80);
            make.height.offset(44);
        }];
        [yesBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [yesBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        //nobutton
        UIButton *noBtn = [[UIButton alloc]init];
        noBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [noBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
        [noBtn setTitle:@"否" forState:UIControlStateNormal];
        [footerView addSubview:noBtn];
        [noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(itemLabel);
            make.left.equalTo(yesBtn.mas_right).offset(35);
            make.width.offset(80);
            make.height.offset(44);
        }];
        [noBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [noBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        yesBtn.tag = 60;
        noBtn.tag = 61;
        self.yesBtn = yesBtn;
        self.noBtn = noBtn;
        [yesBtn addTarget:self action:@selector(ifFixBtnClick:) forControlEvents:UIControlEventTouchDragInside];
        [yesBtn addTarget:self action:@selector(ifFixBtnClick:) forControlEvents:UIControlEventTouchDragInside];
        //确定button
        UIButton *confirmBtn = [[UIButton alloc]init];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
        [confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [footerView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.equalTo(footerView.mas_top).offset(65);
            make.width.offset(80);
            make.height.offset(46);
        }];
        [confirmBtn addTarget:self action:@selector(confirmFixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
        
    }
    return nil;
}
-(void)setState:(NSInteger)state{
    _state = state;
    switch (state) {
        case 1:
            self.title = @"待维修";
            break;
        case 2:
            self.title = @"维修记录";
            break;
            
        default:
            break;
    }
}
-(void)setModel:(RepairManagerListModel *)model{
    _model = model;
    [SVProgressHUD show];// 动画开始
//    维修管理》根据ID查询维修申请详情接口
//http://192.168.1.168:8085/mobileapi/maintenanceLog/getManage.do?id=
//    参数：id=维修申请的编号
    NSString *listUrlStr = @"";
    if (self.state == 1) {
        self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"资产编码",@"维修类型",@"申请时间",@"备注说明",@"故障说明", nil];
    }else{
        self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"资产编码",@"维修类型",@"申请时间",@"备注说明",@"故障说明",@"维修时间", nil];
    }
    
    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mRepairManagerDetail,model.info_id];
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *repairDic = dic[@"maintenanceLog"];//维修记录数据
            RepairApplyDetailModel *repairModel = [RepairApplyDetailModel mj_objectWithKeyValues:repairDic];
            self.repairModel = repairModel;
            
            NSArray *fittingArr = dic[@"fittingsList"];//维修所用配件数据
            for (NSDictionary *dic in fittingArr) {
                FittingsListModel *fittingModel = [FittingsListModel mj_objectWithKeyValues:dic];
                [self.selectedThingsArr addObject:fittingModel];
            }
            
            [self.tableView reloadData];
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//采购申请提交网络请求
//- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
//    LaunchBaseTVCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    NSString *comment = @"";//备注说明
//    if (cell3.contentField.text.length > 0) {
//        comment = cell3.contentField.text;
//    }
//    
//    NSString *assetsIds = @"";//领用物品编号拼写
//    if (self.selectedThingsArr.count == 0) {
//        [SVProgressHUD showInfoWithStatus:@"请添加领用物品"];
//        return;
//    }else{
//        for (int i = 0; i < self.selectedThingsArr.count; i++) {
//            storeThingsModel *selModel = self.selectedThingsArr[i];
//            if (i == 0) {
//                assetsIds = [NSString stringWithFormat:@"%@,%@",selModel.info_id,selModel.num];
//            }else{
//                assetsIds = [NSString stringWithFormat:@"%@;%@,%@",assetsIds,selModel.info_id,selModel.num];
//            }
//            
//        }
//    }
//    //获取当前时间
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制 HH:mm:ss
//    
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    
//    //现在时间,你可以输出来看下是什么格式
//    
//    NSDate *datenow = [NSDate date];
//    
//    //----------将nsdate按formatter格式转成nsstring
//    
//    NSString *currentTimeString = [formatter stringFromDate:datenow];
//    
//    //    NSLog(@"currentTimeString =  %@",currentTimeString);
//    
//    //http://192.168.1.168:8085/mobileapi/assetRecipients/save.do?recipientsDate=2018-08-17&assetsIds=1,2
//    sender.enabled = false;
//    [SVProgressHUD show];// 动画开始
//    NSString *reportUrlStr = [NSString stringWithFormat:@"%@&recipientsDate=%@&assetsIds=%@&comment=%@",mLaunchGetStoreThings,currentTimeString,assetsIds,comment];
//    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    HttpClient *httpManager = [HttpClient defaultClient];
//    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
//    [SVProgressHUD show];
//    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            
//            [SVProgressHUD showSuccessWithStatus:@"发起成功"];
//        }else if ([dic[@"code"] isEqualToString:@"-1"]){
//            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
//        }
//        sender.enabled = true;
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//        sender.enabled = true;
//        return ;
//    }];
//}
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
        [storeTableView registerClass:[RepairFittingTVCell class] forCellReuseIdentifier:listCell];
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
        storeTableView.tableHeaderView = [self setSearchBar];
        storeTableView.tableFooterView = [self setFooterView];
        __weak typeof(self) weakSelf = self;
        //下拉刷新
        self.storeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [weakSelf refreshHeader];
            
        }];
        //上拉加载
        self.storeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            //Call this Block When enter the refresh status automatically
            [weakSelf refreshFooter];
        }];
    }
    return _storeTableView;
}
-(NSMutableArray *)selectedThingsArr{
    if (_selectedThingsArr == nil) {
        _selectedThingsArr = [NSMutableArray array];
    }
    return _selectedThingsArr;
}
//添加搜索栏
- (UITextField *)setSearchBar{
    //输入框
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 60, 35)];
    searchField.delegate = self;
    self.searchField = searchField;
    searchField.clearButtonMode = UITextFieldViewModeAlways;//删除内容的❎
    [searchField setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
    //输入框左侧放大镜
    UIImage *image = [UIImage imageNamed:@"assestManage_search"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [imageView sizeToFit];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width+5, imageView.frame.size.height)];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.right.bottom.offset(0);
    }];
    searchField.leftView = view;
    searchField.placeholder = @"请输入资产名称";
    [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    [searchField.layer setMasksToBounds:YES];
    [searchField.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    //边框宽度
    [searchField.layer setBorderWidth:0.8];
    searchField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    return searchField;
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
            ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
            
            cell.itemLabel.text = self.itemTypeArray[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.itemContentLabel.text = self.repairModel.departmentName;
                    break;
                case 1:
                    cell.itemContentLabel.text = self.repairModel.userName;
                    break;
                case 2:
                    cell.itemContentLabel.text = self.repairModel.assetName;
                    break;
                case 3:
                    cell.itemContentLabel.text = self.repairModel.barcode;
                    break;
                case 4:
                    if (self.repairModel.mainType) {
                        cell.itemContentLabel.text = @"重大维修";
                    }else{
                        cell.itemContentLabel.text = @"日常维修";
                    }
                    break;
                case 5:
                    cell.itemContentLabel.text = self.repairModel.repairDateString;
                    break;
                case 6:
                    cell.itemContentLabel.text = self.repairModel.rejectReason;
                    break;
                case 7:
                    if (self.state == 1) {//待维修
                        cell.contentField.hidden = false;
                        cell.itemContentLabel.text = @"";
                        self.contentField = cell.contentField;
                        break;
                    }else{
                        cell.itemContentLabel.text = self.repairModel.comment;
                        break;
                    }
                    break;
                case 8:
                    cell.itemContentLabel.text = self.repairModel.repairDateString;
                    break;

                default:
                    break;
            }
            
            return cell;
        }else{
            RepairFittingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
            FittingsListModel *model = self.selectedThingsArr[indexPath.row];
            cell.selectedThingsModel = model;
            cell.contentField.tag = [model.info_id integerValue] + 50;//为了标记textfield查找对应cell的数据model
            cell.contentField.delegate = self;
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            if (self.state != 1) {
                cell.contentField.enabled = false;
                cell.contentField.placeholder = @"1";
            }
            return cell;
        }
    }else{//tableView == storeTableview
        RepairFittingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
        FittingsListModel *model = self.storeThingsArr[indexPath.row];
        cell.storeThingModel = model;
        //block传递选中领用结果更新数据源
        __weak typeof(self) weakSelf = self;
        cell.ifSelectedBlock = ^(FittingsListModel *selModel, BOOL btnSelected) {
            selModel.isSelected = btnSelected;//赋值是否处于选中状态给数据，以便tableview刷新时候状态保留
            if (btnSelected) {//选中
                if (weakSelf.selectedThingsArr.count == 0){
                    [weakSelf.selectedThingsArr addObject:selModel];
                }else{
                    BOOL ifHas = false;
                    for (FittingsListModel *model in weakSelf.selectedThingsArr) {//去重
                        if (selModel.info_id == model.info_id && selModel.specTyp == model.specTyp) {
                            ifHas = true;//有重复
                        }
                    }
                    if(!ifHas){//无重复，新选中
                        [weakSelf.selectedThingsArr addObject:selModel];
                    }
                }
            }else{//去除选中
                if (weakSelf.selectedThingsArr.count > 0) {
                    [weakSelf.selectedThingsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        FittingsListModel *model = obj;
                        if (selModel.info_id == model.info_id && selModel.specTyp == model.specTyp) {
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
        UILabel *itemLabel = [UILabel labelWithText:@"配件明细" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        [headerView addSubview:itemLabel];
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_top).offset(17.5);
            make.left.offset(15);
            make.width.offset(60);
        }];
        itemLabel.text = @"配件明细";
        
        //button
        UIButton *delBtn = [[UIButton alloc]init];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [delBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
        [delBtn setTitle:@"增加" forState:UIControlStateNormal];
        [headerView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.width.offset(80);
            make.height.offset(35);
        }];
        [delBtn addTarget:self action:@selector(increaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.state != 1) {
            delBtn.hidden = true;
        }
        
        //空白格
        UIView *emptyView = [[UIView alloc]init];
        emptyView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:emptyView];
        [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.offset(0);
            make.width.height.offset(35);
        }];
        //物品名称label
        UILabel *goodsNameLabel = [UILabel labelWithText:@"名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        goodsNameLabel.backgroundColor = [UIColor whiteColor];
        goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:goodsNameLabel];
        
        [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(emptyView.mas_right);
            make.width.offset(100);
            make.height.offset(35);
        }];
        //类别label
        UILabel *ApplicantLabel = [UILabel labelWithText:@"型号" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        ApplicantLabel.backgroundColor = [UIColor whiteColor];
        ApplicantLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:ApplicantLabel];
        [ApplicantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(goodsNameLabel.mas_right);
            make.width.offset(100);
            make.height.offset(35);
        }];
        //数量label
        UILabel *departmentLabel = [UILabel labelWithText:@"数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        departmentLabel.backgroundColor = [UIColor whiteColor];
        departmentLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:departmentLabel];
        [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(ApplicantLabel.mas_right);
            make.width.offset(kScreenW-235);
            make.height.offset(35);
        }];
        [headerView layoutIfNeeded];
        [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:ApplicantLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        
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
        //物品名称label
        UILabel *goodsNameLabel = [UILabel labelWithText:@"名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        goodsNameLabel.backgroundColor = [UIColor whiteColor];
        goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:goodsNameLabel];
        [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(emptyView.mas_right);
            make.width.offset(100);
            make.top.bottom.offset(0);
        }];
        //类别label
        UILabel *ApplicantLabel = [UILabel labelWithText:@"型号" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        ApplicantLabel.backgroundColor = [UIColor whiteColor];
        ApplicantLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:ApplicantLabel];
        [ApplicantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(goodsNameLabel.mas_right);
            make.width.offset(100);
            make.top.bottom.offset(0);
        }];
        //编号label
        UILabel *departmentLabel = [UILabel labelWithText:@"数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
        departmentLabel.backgroundColor = [UIColor whiteColor];
        departmentLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:departmentLabel];
        [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(emptyView);
            make.left.equalTo(ApplicantLabel.mas_right);
            make.right.offset(0);
            make.top.bottom.offset(0);
        }];
        [headerView layoutIfNeeded];
        [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:ApplicantLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
        
        return headerView;
        
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        //只要实现这个方法，就实现了默认滑动删除！！！！！
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            FittingsListModel *delModel = [self.selectedThingsArr objectAtIndex:indexPath.row];//删除的数据model(必须放在删除前，否侧不是对应的数据)
            // 删除数据
            [self.selectedThingsArr removeObjectAtIndex:indexPath.row];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (self.storeThingsArr.count > 0) {//去除搜索列表的选中效果
                [self.storeThingsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FittingsListModel *model = obj;
                    if (delModel.info_id == model.info_id) {
                        model.isSelected = false;//修改删除的对应数据的选中状态
                        RepairFittingTVCell *cell = [self.storeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];//找到搜索列表对应cell
                        cell.selBtn.selected = NO;
                        cell.selView.backgroundColor = [UIColor whiteColor];
                    }
                }];
            }
        }
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
//增加按钮点击事件
-(void)increaseBtnClick:(UIButton*)sender{
    self.storeTableView.hidden = false;
    self.backView.hidden = false;
    
}
//是否维修选择按钮点击事件
-(void)ifFixBtnClick:(UIButton*)sender{
    sender.selected =!sender.selected;
    if (sender.tag == 60) {//yesBtn
        if (sender.selected) {
            self.isFixed = 1;
            self.noBtn.selected = false;
        }else{
            self.isFixed = 0;
            self.noBtn.selected = true;
        }
    }else{//noBtn
        if (sender.selected) {
            self.isFixed = 0;
            self.yesBtn.selected = false;
        }else{
            self.isFixed = 1;
            self.yesBtn.selected = true;
        }
    }
}
//是否维修确定按钮点击事件
//-(void)confirmFixBtnClick:(UIButton*)sender{
////    维修管理》维修编辑保存接口
////http://192.168.1.168:8085/mobileapi/assetRecipients/saveManage.do
////    参数：
////    id             |Long      |Y    |维修申请编号
////    maintenance    |String    |N    |维修方;
////    cost           |Double    |N    |维修费用;
////    isFixed        |Byte      |Y    |是否已修复;0=未修复，1=已修复
////    assetsIds      |String    |Y    |配件列表，格式：资产编号,数量;id,num;1,1;
////    错误码：
////    1=缺少参数：assetsIds
////    2=缺少参数：id
////    3=对应编号的申请不存在
////    4=缺少参数：isFixed
//    LaunchBaseTVCell *cell7 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
//    NSString *comment = @"";//备注说明
//    if (cell7.contentField.text.length > 0) {
//        comment = cell7.contentField.text;
//    }
//    
//    NSString *assetId = @"";//维修物品编号
//    if (!self.curruntSelectedThing) {
//        [SVProgressHUD showInfoWithStatus:@"请添加维修物品"];
//        
//        return;
//    }else{
//        assetId = self.curruntSelectedThing.info_id;
//    }
//    NSString *totalNum = @"";//维修物品数量
//    LaunchBaseTVCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
//    if (cell5.contentField.text.integerValue > 0) {
//        totalNum = cell5.contentField.text;
//    }else{
//        [SVProgressHUD showInfoWithStatus:@"请添加正确的维修数量"];
//        return;
//    }
//    //http://192.168.1.168:8085/mobileapi/maintenanceLog/save.do?assetId=1 维修
//    sender.enabled = false;
//    [SVProgressHUD show];// 动画开始
//    NSString *reportUrlStr = @"";
//    reportUrlStr = [NSString stringWithFormat:@"%@&assetId=%@&totalNum=%@&mainType=%ld&comment=%@",mRepairManagersaveManage,assetId,totalNum,self.mainType,comment];
//    
//    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    HttpClient *httpManager = [HttpClient defaultClient];
//    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
//    [SVProgressHUD show];
//    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            
//            [SVProgressHUD showSuccessWithStatus:@"发起成功"];
//        }else if ([dic[@"code"] isEqualToString:@"-1"]){
//            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
//        }
//        sender.enabled = true;
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//        sender.enabled = true;
//        return ;
//    }];
//}
//配件选择确定按钮点击事件
-(void)confirmBtnClick:(UIButton*)sender{
    self.storeTableView.hidden = true;
    self.backView.hidden = true;
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - textFieldDelegate
//设置列表行为不可编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.searchField) {//searchBar
        [self requestmStoreThingsListWith:textField.text];
    }
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//输入文字时 一直监听
    
    if (textField != self.searchField&&textField.text.length == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{//返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出第一响应者
    //    if (textField != self.searchField) {
    if ([textField.text integerValue] > 0) {//领用数量必须大于0
        
        NSInteger modelId = textField.tag - 50;
        if (self.selectedThingsArr.count > 0) {
            [self.selectedThingsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FittingsListModel *model = obj;
                if (modelId == [model.info_id integerValue]) {
                    model.num = textField.text;//记录每次编辑的数字，方便刷新之后还是之前的数字
                }
            }];
            
        }
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    //    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}

//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    self.backView.hidden = true;
    self.storeTableView.hidden = true;
    [self.searchField resignFirstResponder];
}
#pragma mark -request
/**
 *  请求仓库可用配件列表
 */
- (void)requestmStoreThingsListWith:(NSString*)searchName
{
    [SVProgressHUD show];// 动画开始
    
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    //把搜索中文转义
    searchName = [searchName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    http://192.168.1.168:8085/mobileapi/asset/fpRecipients.do?name=搜索内容
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=0&limit=6",mRepairManagerFittingsList,searchName];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                FittingsListModel *infoModel = [FittingsListModel mj_objectWithKeyValues:dic];
                infoModel.isSelected = false;//一开始请求回来数据是非选中状态
                [mArr addObject:infoModel];
            }
            self.storeThingsArr = mArr;
            if (self.storeThingsArr.count>0) {
                start = self.storeThingsArr.count;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [self.searchField resignFirstResponder];
                [self.storeTableView reloadData];
                [self.storeTableView.mj_header endRefreshing];
                if (start < 6) {//没有更多数据了
                    [self.storeTableView.mj_footer endRefreshingWithNoMoreData];
                }else{//有更多数据
                    self.storeTableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
                }
                
            });
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//下拉刷新
-(void)refreshHeader{
    [SVProgressHUD show];// 动画开始
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    //    http://192.168.1.168:8085/mobileapi/asset/fpRecipients.do?name=搜索内容
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=0&limit=6",mRepairManagerFittingsList,self.searchField.text];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                FittingsListModel *infoModel = [FittingsListModel mj_objectWithKeyValues:dic];
                infoModel.isSelected = false;//一开始请求回来数据是非选中状态
                [mArr addObject:infoModel];
            }
            weakSelf.storeThingsArr = mArr;
            if (weakSelf.storeThingsArr.count>0) {
                start = weakSelf.storeThingsArr.count;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [weakSelf.searchField resignFirstResponder];
                [weakSelf.storeTableView reloadData];
                [weakSelf.storeTableView.mj_header endRefreshing];
                if (start < 6) {//没有更多数据了
                    [weakSelf.storeTableView.mj_footer endRefreshingWithNoMoreData];
                }else{//有更多数据
                    weakSelf.storeTableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
                }
            });
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.storeTableView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
//上拉刷新
-(void)refreshFooter{
    [SVProgressHUD show];// 动画开始
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=%ld&limit=6",mRepairManagerFittingsList,self.searchField.text,(long)start];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                FittingsListModel *infoModel = [FittingsListModel mj_objectWithKeyValues:dic];
                infoModel.isSelected = false;//一开始请求回来数据是非选中状态
                [mArr addObject:infoModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (mArr.count>0) {
                    [weakSelf.storeThingsArr addObjectsFromArray:mArr];
                    start = weakSelf.storeThingsArr.count;
                    
                    [weakSelf.storeTableView reloadData];
                    if (start % 6 != 0) {
                        [weakSelf.storeTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.storeTableView.mj_footer endRefreshing];
                    }
                }else{
                    [weakSelf.storeTableView.mj_footer endRefreshingWithNoMoreData];
                }
            });
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.storeTableView.mj_header endRefreshing];
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
