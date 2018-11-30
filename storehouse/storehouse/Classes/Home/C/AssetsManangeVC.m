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

static NSString* listCell = @"listCell";
@interface AssetsManangeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
//@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
//@property(nonatomic,weak)UITableView *storeTableView;//仓库可领用物料列表
//@property(nonatomic,weak)UIView *backView;//背景阴影view
@property(nonatomic,strong)NSMutableArray *assetsArr;//资产列表
//@property(nonatomic,strong)NSMutableArray *selectedThingsArr;//选中的库房物品列表数据
@property(nonatomic,weak)UITextField *searchField;//输入框

@end

@implementation AssetsManangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"增加" style:UIBarButtonItemStylePlain target:self action:@selector(addAssetBtnClick)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
//    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"备注说明", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //添加标题栏
//    [self setSearchBar];在viewwillapeear中添加
    //设置标题栏
    [self setTitleBar];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.left.right.bottom.offset(0);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AssetsManageTVCell class] forCellReuseIdentifier:listCell];
    
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
//添加标题栏
- (void)setTitleBar{
    //空白格
    UIView *emptyView = [[UIView alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(30);
        make.height.offset(35);
    }];
    //编号label
    UILabel *departmentLabel = [UILabel labelWithText:@"资产编码" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(emptyView.mas_right);
        make.width.offset(100);
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
#pragma searchResultUpdating
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *searchString = [self.searchField text];
    //把搜索中文转义
    searchString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"%@assetName=%@",mSearchResult,searchString];
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
        [self.tableView reloadData];
        
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

#pragma mark -request
///**
// *  请求仓库可用物品列表
// */
//- (void)requestmStoreThingsList
//{
//    [SVProgressHUD show];// 动画开始
//
//    HttpClient *httpManager = [HttpClient defaultClient];
//    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
//    [SVProgressHUD show];
//    [httpManager requestWithPath:mStoreThingsList method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        if ([dic[@"code"] isEqualToString:@"0"]) {
//            NSArray *listArr = dic[@"rows"];
//            NSMutableArray *mArr = [NSMutableArray array];
//            for (NSDictionary *dic in listArr) {
//                storeThingsModel *infoModel = [storeThingsModel mj_objectWithKeyValues:dic];
//                [mArr addObject:infoModel];
//            }
//
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
