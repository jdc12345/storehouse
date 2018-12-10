//
//  LaunchOldForNewVC.m
//  storehouse
//
//  Created by 万宇 on 2018/11/28.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "LaunchOldForNewVC.h"
#import "LaunchBaseTVCell.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import "LaunchFormTVCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "storeThingsModel.h"

static NSString* tableCellid = @"table_cell";
static NSString* listCell = @"listCell";
static NSInteger start = 0;//上拉加载起始位置
@interface LaunchOldForNewVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,weak)UITableView *storeTableView;//自己名下物料列表
@property(nonatomic,weak)UIView *backView;//背景阴影view
@property(nonatomic,strong)NSMutableArray *storeThingsArr;//自己名下物料列表数据
@property(nonatomic,strong)storeThingsModel *curruntSelectedThing;//选中的自己名下要维修物品
@property(nonatomic,strong)NSIndexPath *oldSelectedThingIndex;//之前选中的自己名下要维修物品序号
@property(nonatomic,weak)UITextField *searchField;//输入框
@end

@implementation LaunchOldForNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(addLaunchBtnClick:)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"物品数量",@"备注说明", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    [self.tableView registerClass:[LaunchFormTVCell class] forCellReuseIdentifier:listCell];
    self.title = @"以旧换新申请";
    
}
//维修、以旧换新申请提交网络请求
- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
    LaunchBaseTVCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *totalNum = @"";//维修物品数量
    if (cell4.contentField.text.integerValue  > 0) {
        totalNum = cell4.contentField.text;
    }else{
        [SVProgressHUD showInfoWithStatus:@"请添加正确的维修数量"];
        return;
    }
    NSString *comment = @"";//备注说明
    LaunchBaseTVCell *cell5 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (cell5.contentField.text.length > 0) {
        comment = cell5.contentField.text;
    }
    NSString *assetId = @"";//领用物品编号拼写
    if (!self.curruntSelectedThing) {
        [SVProgressHUD showInfoWithStatus:@"请添加以旧换新物品"];
        return;
    }else{
        assetId = self.curruntSelectedThing.info_id;
    }
    //http://192.168.1.168:8085/mobileapi/maintenanceLog/save.do?assetId=1 维修
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = @"";
        //获取当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制 HH:mm:ss
        
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        //    http://192.168.1.168:8085/mobileapi/assetOldfornew/save.do?changeDate=2018-08-17&assetId=1 以旧换新
    
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        reportUrlStr = [NSString stringWithFormat:@"%@&changeDate=%@&assetId=%@&totalNum=%@&comment=%@",mLaunchReplaceThing,currentTimeString,assetId,totalNum,comment];
    
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
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        
        return self.itemTypeArray.count;
        
    }else{
        return self.storeThingsArr.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        LaunchBaseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        CcUserModel *user = [CcUserModel defaultClient];
        if (indexPath.row == 0) {
            cell.contentField.text = user.departmentName;
        }
        if (indexPath.row == 1) {
            cell.contentField.text = user.trueName;
        }
        if ( indexPath.row == 2) {
            cell.listButton.hidden = false;
            cell.listButton.tag = 100+indexPath.row;
            [cell.listButton addTarget:self action:@selector(repairThingsListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.contentField.tag = 50+indexPath.row;
        }
        if (indexPath.row == 3) {
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
        }
        cell.contentField.delegate = self;
        cell.itemLabel.text = self.itemTypeArray[indexPath.row];
        
        return cell;
        
    }else{//tableView == storeTableview
        LaunchFormTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
        storeThingsModel *model = self.storeThingsArr[indexPath.row];
        cell.storeThingModel = model;
        //block传递选中领用结果
        __weak typeof(self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;
        cell.ifSelectedBlock = ^(storeThingsModel *selModel, BOOL btnSelected) {
            selModel.isSelected = btnSelected;//赋值是否处于选中状态给数据，以便tableview刷新时候状态保留
            if (btnSelected) {//选中
                if (!weakSelf.curruntSelectedThing){
                    weakSelf.curruntSelectedThing = selModel;
                    weakSelf.oldSelectedThingIndex = indexPath;
                }else{
                    weakSelf.curruntSelectedThing = selModel;
                    LaunchFormTVCell *oldCell = [tableView cellForRowAtIndexPath:weakSelf.oldSelectedThingIndex];
                    oldCell.selBtn.selected = false;
                    oldCell.selView.backgroundColor = [UIColor whiteColor];//去除oldCell选中效果
                    storeThingsModel *oldModel = weakSelf.storeThingsArr[weakSelf.oldSelectedThingIndex.row];
                    oldModel.isSelected = false;
                    weakSelf.oldSelectedThingIndex = indexPath;
                }
            }else{//去除选中
                weakSelf.curruntSelectedThing = nil;
                weakCell.selBtn.selected = false;
                weakCell.selView.backgroundColor = [UIColor whiteColor];//去除oldCell选中效果
            }
            
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 44;
        
    }else{
        return 35;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 0;
    }else{
        return 40;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return nil;
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
-(void)repairThingsListBtnClick:(UIButton*)sender{
    self.storeTableView.hidden = false;
    self.backView.hidden = false;
//    [self requestmStoreThingsList];
}
//确定按钮点击事件
-(void)confirmBtnClick:(UIButton*)sender{
    self.storeTableView.hidden = true;
    self.backView.hidden = true;
    if (self.curruntSelectedThing) {
        LaunchBaseTVCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.contentField.text = self.curruntSelectedThing.assetName;
    }
}
#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    //    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}
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
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    self.backView.hidden = true;
    self.storeTableView.hidden = true;
    [self.searchField resignFirstResponder];
}
#pragma mark -request
/**
 *  请求仓库可用物品列表
 */
//- (void)requestmStoreThingsList
//{
//    [SVProgressHUD show];// 动画开始
//    //    http://192.168.1.168:8085/mobileapi/asset/findMyList.do
//    HttpClient *httpManager = [HttpClient defaultClient];
//    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
//    [SVProgressHUD show];
//    [httpManager requestWithPath:mHaveThingsList method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            NSArray *listArr = dic[@"rows"];
//            NSMutableArray *mArr = [NSMutableArray array];
//            for (NSDictionary *dic in listArr) {
//                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
//                [mArr addObject:infoModel];
//            }
//            self.storeThingsArr = mArr;
//            [self.storeTableView reloadData];
//            self.storeTableView.hidden = false;
//            self.backView.hidden = false;
//            
//            
//        }else if ([dic[@"code"] isEqualToString:@"-1"]){
//            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
//        }
//        [SVProgressHUD dismiss];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];
//        return ;
//    }];
//}

- (void)requestmStoreThingsListWith:(NSString*)searchName
{
    [SVProgressHUD show];// 动画开始
    
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    //把搜索中文转义
    searchName = [searchName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    http://192.168.1.168:8085/mobileapi/asset/fpRecipients.do?name=搜索内容
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=0&limit=6",mStoreOldfornewThingsList,searchName];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
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
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=0&limit=6",mStoreOldfornewThingsList,self.searchField.text];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
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
    //    http://192.168.1.168:8085/mobileapi/asset/fpRecipients.do?name=搜索内容
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&start=%ld&limit=6",mStoreOldfornewThingsList,self.searchField.text,(long)start];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
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