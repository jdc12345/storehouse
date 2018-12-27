//
//  AssetsManangeVC.m
//  storehouse
//
//  Created by 万宇 on 2018/11/18.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "AssetsManangeVC.h"
#import "LaunchBaseTVCell.h"
#import "HttpClient.h"
#import "UILabel+Addition.h"
#import "AssetsManageTVCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "storeThingsModel.h"
#import "AssetModel.h"
#import <MJExtension.h>
#import "AssetDetailVC.h"
#import "AddAssetVC.h"
#import "ZWPullMenuView.h"
#import "InventoryTypeModel.h"
#import "WMHCalendarView.h"

static NSString* listCell = @"listCell";
static NSInteger start = 0;//上拉加载起始位置
@interface AssetsManangeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *assetsArr;//资产列表
//@property(nonatomic,strong)NSMutableArray *selectedThingsArr;//选中的库房物品列表数据
@property(nonatomic,weak)UITextField *searchField;//输入框
@property (nonatomic, strong) NSMutableArray *categorySecondLevelArray;//分类第二级数组
@property (nonatomic, strong) NSMutableArray *savePersonArray;//保管人列表数组
@property (nonatomic, copy) NSString *saveUserId;//提交需要参数：保管人id
@property (nonatomic, copy) NSString *categoryCode;//提交需要参数：类别码
@property (nonatomic, strong) NSMutableArray *addressSecondLevelArray;//分类第二级数组
@property (nonatomic, copy) NSString *addressCode;//提交需要参数：存放地码
@property (nonatomic, strong) NSMutableArray *departmentSecLevelArr;//请求回来的部门第二级数组
@property (nonatomic, copy) NSString *departmentCode;//部门编码
@property (nonatomic, copy) NSString *passEntryTimeBegin;//开始时间
@property (nonatomic, copy) NSString *passEntryTimeEnd;//结束时间
@property (nonatomic, strong) NSMutableArray *selectedSecLevelArr;//当前选中的方式第二级数组

@end

@implementation AssetsManangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"增加" style:UIBarButtonItemStylePlain target:self action:@selector(addAssetBtnClick)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //设置条件值初始值
    self.departmentCode = @"";
    self.categoryCode = @"";
    self.saveUserId = @"";
    self.passEntryTimeBegin = @"";
    self.passEntryTimeEnd = @"";
    self.addressCode = @"";
//    搜索条件栏
    [self setSearchConditionBar];
    //设置资产标题栏
    [self setTitleBar];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(125);
        make.left.right.bottom.offset(0);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AssetsManageTVCell class] forCellReuseIdentifier:listCell];
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf refreshHeader];
        
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf refreshFooter];
    }];
    //搜索条件网络请求
    [self requestDepartment];
    [self requestAddress];
    [self requestAssetsCategary];
    [self requestSavePersonList];
    
}
//添加搜索栏
- (void)setSearchBar{
    //输入框
    UITextField *searchField = [[UITextField alloc]init];
    [self.navigationController.navigationBar addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.offset(250);
        make.height.offset(35);
    }];
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
    searchField.placeholder = @"请输入资产名称、编号或型号";
    [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.rightView = view;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    [searchField.layer setMasksToBounds:YES];
    [searchField.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    //边框宽度
    [searchField.layer setBorderWidth:0.8];
    searchField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
}
//添加搜索条件栏
- (void)setSearchConditionBar{//科室、资产类别、保管人、时间段、存放地
    //科室label
    UILabel *departmentLabel = [UILabel labelWithText:@"科室" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:13];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(kScreenW*0.2);
        make.height.offset(30);
    }];
    //资产类别label
    UILabel *catagoryLabel = [UILabel labelWithText:@"资产类别" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:13];
    catagoryLabel.backgroundColor = [UIColor whiteColor];
    catagoryLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:catagoryLabel];
    [catagoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(departmentLabel);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(kScreenW*0.2);
        make.height.offset(30);
    }];
    //保管人label
    UILabel *saverLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:13];
    saverLabel.backgroundColor = [UIColor whiteColor];
    saverLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:saverLabel];
    [saverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(departmentLabel);
        make.left.equalTo(catagoryLabel.mas_right);
        make.width.offset(kScreenW*0.2);
        make.height.offset(30);
    }];
    //时间段label
    UILabel *timeLabel = [UILabel labelWithText:@"时间段" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:13];
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(departmentLabel);
        make.left.equalTo(saverLabel.mas_right);
        make.width.offset(kScreenW*0.2);
        make.height.offset(30);
    }];
    //存放地label
    UILabel *storelabel = [UILabel labelWithText:@"存放地" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:13];
    storelabel.backgroundColor = [UIColor whiteColor];
    storelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:storelabel];
    [storelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(departmentLabel);
        make.left.equalTo(timeLabel.mas_right);
        make.right.offset(0);
        make.height.offset(30);
    }];
    NSArray *titleArr = [NSArray arrayWithObjects:@"未选择",@"未选择",@"未选择",@"开始时间",@"结束时间",@"未选择", nil];
    //循环把各个按钮通用的部分设置
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor colorWithHexString:@"23b880"] forState:UIControlStateNormal];
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        [btn setBackgroundColor:[UIColor whiteColor]];
        UIImageView *triangle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightDown_triangle"]];
        [btn addSubview:triangle];
        [triangle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(0);
        }];
        //
        btn.tag = 30+i;
        //添加按钮的监听事件
        [btn addTarget:self action:@selector(searchConditionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i == 3) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenW*0.2*i);
                make.width.offset(kScreenW*0.2);
                make.top.offset(30);
                make.height.offset(30);
            }];
        }else if (i == 4) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenW*0.2*(i-1));
                make.width.offset(kScreenW*0.2);
                make.top.offset(60);
                make.height.offset(30);
            }];
        }else if (i == 5) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenW*0.2*(i-1));
                make.width.offset(kScreenW*0.2);
                make.top.offset(30);
                make.height.offset(60);
            }];
            [btn layoutIfNeeded];
            [btn.titleLabel setBounds:btn.bounds];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(kScreenW*0.2*i);
            make.width.offset(kScreenW*0.2);
            make.top.offset(30);
            make.height.offset(60);
        }];
        }
    }
}
//添加标题栏
- (void)setTitleBar{
    //空白格
    UIView *emptyView = [[UIView alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(90);
        make.left.offset(0);
        make.width.offset(40);
        make.height.offset(35);
    }];
    //编号label
    UILabel *departmentLabel = [UILabel labelWithText:@"资产数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(emptyView.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    //物品名称label
    UILabel *goodsNameLabel = [UILabel labelWithText:@"资产名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    goodsNameLabel.backgroundColor = [UIColor whiteColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    //保管人label
    UILabel *keeperLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    keeperLabel.backgroundColor = [UIColor whiteColor];
    keeperLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:keeperLabel];
    [keeperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(goodsNameLabel.mas_right);
        make.width.offset(75);
        make.height.offset(35);
    }];
    //storelabel
    UILabel *storelabel = [UILabel labelWithText:@"存放地" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    storelabel.backgroundColor = [UIColor whiteColor];
    storelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:storelabel];
    [storelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(keeperLabel.mas_right);
        make.right.offset(0);
        make.height.offset(35);
    }];
    
    [self.view layoutIfNeeded];
    [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:keeperLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:storelabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    
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
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetsArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetsManageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.assetModel = self.assetsArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetModel *model = self.assetsArr[indexPath.row];
    AssetDetailVC *vc = [[AssetDetailVC alloc] init];
    vc.assetModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
#pragma searchResultUpdating
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    参数：name=资产名称\departmentCode=部门编码\saveUserId=用户编号\passEntryTimeBegin=开始时间&passEntryTimeEnd=结束时间\addressCode=存放地点编码\categoryCode=类别、分类编码
    NSString *searchString = [self.searchField text];
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&departmentCode=%@&saveUserId=%@&passEntryTimeBegin=%@&passEntryTimeEnd=%@&addressCode=%@&categoryCode=%@&start=0&limit=6",mSearchResult,searchString,self.departmentCode,self.saveUserId,self.passEntryTimeBegin,self.passEntryTimeEnd,self.addressCode,self.categoryCode];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *client = [HttpClient defaultClient];
    [SVProgressHUD show];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        NSArray *responseArr = responseDic[@"rows"];
        NSMutableArray *assetsArr = [NSMutableArray array];
        for (NSDictionary *dict in responseArr){
            AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:dict];
            [assetsArr addObject:infoModel];
        }
        self.assetsArr = assetsArr;
        if (self.assetsArr.count>0) {
            start = self.assetsArr.count;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (start < 6) {//没有更多数据了
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{//有更多数据
                self.tableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
            }
            
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    
    
    
    return true;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
//    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}


#pragma mark - btnClick
//增加按钮点击事件
-(void)addAssetBtnClick{
    AddAssetVC *vc = [[AddAssetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置列表行为不可编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}
- (void)searchConditionBtnClick:(UIButton*)sender{
    __weak typeof(self) weakSelf = self;
    switch (sender.tag) {//第一级决定第二级标题数据源
        case 30:
            self.departmentCode = @"";
            [self textFieldShouldReturn:self.searchField];
            self.selectedSecLevelArr = self.departmentSecLevelArr;
            break;
        case 31:
            self.categoryCode = @"";
            [self textFieldShouldReturn:self.searchField];
            self.selectedSecLevelArr = self.categorySecondLevelArray;
            break;
        case 32:{//保管人列表
            self.saveUserId = @"";
            [self textFieldShouldReturn:self.searchField];
            NSMutableArray *titleArr = [NSMutableArray array];//标题数组
            for (CcUserModel *model in self.savePersonArray) {
                [titleArr addObject:model.trueName];
            }
            ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:titleArr];
            menuView.zwPullMenuStyle = PullMenuLightStyle;
            __weak typeof(menuView) weakMenuView = menuView;
            menuView.blockSelectedMenu = ^(NSInteger menuRow) {
                //            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
                sender.titleLabel.text = weakMenuView.titleArray[menuRow];
                CcUserModel *infoModel = weakSelf.savePersonArray[menuRow];
                weakSelf.saveUserId = infoModel.info_id;
                [weakSelf textFieldShouldReturn:weakSelf.searchField];
            };
        }
            return;
            break;
        case 33:{
            self.passEntryTimeBegin = @"";
            [self textFieldShouldReturn:self.searchField];
            WMHCalendarView *caView = [WMHCalendarView initCalendarViewWithShowView:self.view sureBtnTitleStr:@"确认" buttonIndex:^(NSString *dateStr) {
//                NSLog(@"%@",dateStr);
                sender.titleLabel.text = dateStr;
                weakSelf.passEntryTimeBegin = dateStr;
                [weakSelf textFieldShouldReturn:weakSelf.searchField];
                
            }];
            [self.view addSubview:caView];
            return;
        }
            break;
        case 34:{
            self.passEntryTimeEnd = @"";
            [self textFieldShouldReturn:self.searchField];
            WMHCalendarView *caView = [WMHCalendarView initCalendarViewWithShowView:self.view sureBtnTitleStr:@"确认" buttonIndex:^(NSString *dateStr) {
//                NSLog(@"%@",dateStr);
                sender.titleLabel.text = dateStr;
                weakSelf.passEntryTimeEnd = dateStr;
                [weakSelf textFieldShouldReturn:weakSelf.searchField];
                
            }];
            [self.view addSubview:caView];
            return;
        }
            break;
        case 35:
            self.addressCode = @"";
            [self textFieldShouldReturn:self.searchField];
            self.selectedSecLevelArr = self.addressSecondLevelArray;
            break;
            
        default:
            break;
    }
    if (self.selectedSecLevelArr.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请重新进入该页面"];
        return;
    }

    NSMutableArray *secondTitleArr = [NSMutableArray array];//第二级标题数组
    NSMutableArray *thirdTitleArr = [NSMutableArray array];//第三级标题数组
    NSMutableArray *fourTitleArr = [NSMutableArray array];//第四级标题数组
    for (InventoryTypeModel *model in weakSelf.selectedSecLevelArr) {//第二级标题数据源
        [secondTitleArr addObject:model.text];
    }
    ZWPullMenuView *secondMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:secondTitleArr];
    secondMenuView.zwPullMenuStyle = PullMenuLightStyle;
    __weak typeof(secondMenuView) weakSecondMenuView = secondMenuView;
    secondMenuView.blockSelectedMenu = ^(NSInteger menuRow) {//1
        
        sender.titleLabel.text = weakSecondMenuView.titleArray[menuRow];
        InventoryTypeModel *secModel = weakSelf.selectedSecLevelArr[menuRow];
        switch (sender.tag) {//根据具体点击按钮对应相应code
            case 30:
                weakSelf.departmentCode = secModel.treeCode;
                break;
            case 31:
                weakSelf.categoryCode = secModel.treeCode;
                break;
            case 35:
                weakSelf.addressCode = secModel.treeCode;
                break;
                
            default:
                break;
        }
        [self textFieldShouldReturn:self.searchField];
        if (secModel.children.count > 0) {//有三级页面
            for (NSDictionary *thirdDic in secModel.children) {
                InventoryTypeModel *thirdModel = [InventoryTypeModel mj_objectWithKeyValues:thirdDic];
                [thirdTitleArr addObject:thirdModel.text];//点击的第二级数据行对应的第三级标题数据源
            }
            ZWPullMenuView *thirdMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:thirdTitleArr];
            thirdMenuView.zwPullMenuStyle = PullMenuLightStyle;
            __weak typeof(thirdMenuView) weakThirdMenuView = thirdMenuView;
            thirdMenuView.blockSelectedMenu = ^(NSInteger menuRow) {//2
                
                sender.titleLabel.text = weakThirdMenuView.titleArray[menuRow];
                NSDictionary *selectedThirdLeveDic = secModel.children[menuRow];
                InventoryTypeModel *thirdModel = [InventoryTypeModel mj_objectWithKeyValues:selectedThirdLeveDic];
                switch (sender.tag) {//根据具体点击按钮对应相应code
                    case 30:
                        weakSelf.departmentCode = thirdModel.treeCode;
                        break;
                    case 31:
                        weakSelf.categoryCode = thirdModel.treeCode;
                        break;
                    case 35:
                        weakSelf.addressCode = thirdModel.treeCode;
                        break;
                        
                    default:
                        break;
                }
                [self textFieldShouldReturn:self.searchField];

                if (thirdModel.children.count > 0) {//有四级页面
                    for (NSDictionary *fourDic in thirdModel.children) {
                        InventoryTypeModel *fourModel = [InventoryTypeModel mj_objectWithKeyValues:fourDic];
                        [fourTitleArr addObject:fourModel.text];//点击的第三级数据行对应的第四级标题数据源
                    }
                    ZWPullMenuView *fourMenuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:fourTitleArr];
                    fourMenuView.zwPullMenuStyle = PullMenuLightStyle;
                    __weak typeof(fourMenuView) weakFourMenuView = fourMenuView;
                    fourMenuView.blockSelectedMenu = ^(NSInteger menuRow) {//3
                        
                        sender.titleLabel.text = weakFourMenuView.titleArray[menuRow];
                        NSDictionary *selectedFourLeveDic = thirdModel.children[menuRow];
                        InventoryTypeModel *fourthModel = [InventoryTypeModel mj_objectWithKeyValues:selectedFourLeveDic];
                        switch (sender.tag) {//根据具体点击按钮对应相应code
                            case 30:
                                weakSelf.departmentCode = fourthModel.treeCode;
                                break;
                            case 31:
                                weakSelf.categoryCode = fourthModel.treeCode;
                                break;
                            case 35:
                                weakSelf.addressCode = fourthModel.treeCode;
                                break;
                                
                            default:
                                break;
                        }
                        [self textFieldShouldReturn:self.searchField];
                    };
                }
            };
        }
    };
    
}

#pragma mark -懒加载
-(NSMutableArray *)selectedSecLevelArr{
    if (_selectedSecLevelArr == nil) {
        _selectedSecLevelArr = [NSMutableArray array];
    }
    return _selectedSecLevelArr;
}
-(NSMutableArray *)categorySecondLevelArray{
    if (_categorySecondLevelArray == nil) {
        _categorySecondLevelArray = [NSMutableArray array];
    }
    return _categorySecondLevelArray;
}

-(NSMutableArray *)addressSecondLevelArray{
    if (_addressSecondLevelArray == nil) {
        _addressSecondLevelArray = [NSMutableArray array];
    }
    return _addressSecondLevelArray;
}

-(NSMutableArray *)savePersonArray{
    if (_savePersonArray == nil) {
        _savePersonArray = [NSMutableArray array];
    }
    return _savePersonArray;
}
-(NSMutableArray *)departmentSecLevelArr{
    if (_departmentSecLevelArr == nil) {
        _departmentSecLevelArr = [NSMutableArray array];
    }
    return _departmentSecLevelArr;
}
//#pragma mark -request
//下拉刷新
-(void)refreshHeader{
    [SVProgressHUD show];// 动画开始
    __weak typeof(self) weakSelf = self;
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    NSString *searchString = [self.searchField text];
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&departmentCode=%@&saveUserId=%@&passEntryTimeBegin=%@&passEntryTimeEnd=%@&addressCode=%@&categoryCode=%@&start=0&limit=6",mSearchResult,searchString,self.departmentCode,self.saveUserId,self.passEntryTimeBegin,self.passEntryTimeEnd,self.addressCode,self.categoryCode];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *responseDic = (NSDictionary*)responseObject;
        if ([responseDic[@"code"] isEqualToString:@"0"]) {
        NSArray *responseArr = responseDic[@"rows"];
        NSMutableArray *assetsArr = [NSMutableArray array];
        for (NSDictionary *dict in responseArr){
            AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:dict];
            [assetsArr addObject:infoModel];
        }
        weakSelf.assetsArr = assetsArr;
        if (weakSelf.assetsArr.count>0) {
            start = weakSelf.assetsArr.count;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [weakSelf.searchField resignFirstResponder];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            if (start < 6) {//没有更多数据了
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{//有更多数据
                weakSelf.tableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
            }
        });
        }else if ([responseDic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.tableView.mj_header endRefreshing];
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
   NSString *searchString = [self.searchField text];
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&departmentCode=%@&saveUserId=%@&passEntryTimeBegin=%@&passEntryTimeEnd=%@&addressCode=%@&categoryCode=%@&start=%ld&limit=6",mSearchResult,searchString,self.departmentCode,self.saveUserId,self.passEntryTimeBegin,self.passEntryTimeEnd,self.addressCode,self.categoryCode,(long)start];
    //把搜索中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *responseArr = dic[@"rows"];
            NSMutableArray *assetsArr = [NSMutableArray array];
            for (NSDictionary *dict in responseArr){
                AssetModel *infoModel = [AssetModel mj_objectWithKeyValues:dict];
                [assetsArr addObject:infoModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                if (assetsArr.count>0) {
                    [weakSelf.assetsArr addObjectsFromArray:assetsArr];
                    start = weakSelf.assetsArr.count;
                    
                    [weakSelf.tableView reloadData];
                    if (start % 6 != 0) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            });
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [weakSelf.tableView.mj_header endRefreshing];
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setSearchBar];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.searchField removeFromSuperview];
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
