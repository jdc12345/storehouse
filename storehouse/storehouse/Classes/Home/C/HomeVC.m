//
//  HomeVC.m
//  storehouse
//
//  Created by 万宇 on 2018/5/30.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "HomeVC.h"
#import "FunctionListFlowLayout.h"
#import "HomeFunctionCollectionViewCell.h"
#import "NSArray+Addition.h"
#import "HomeNoticeNewsTVCell.h"
#import "UILabel+Addition.h"
#import "HomePageScanVC.h"
#import "AssetsManangeVC.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "HomePageNoticeModel.h"
#import "PostNoticeVC.h"
#import "HomePageInventoryVC.h"

static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray* functionListData;//功能列表
@property(nonatomic,strong)NSMutableArray *noticeNewsArr;//通知消息数据源
@property(nonatomic,weak)UITableView *tableView;//仓库可领用物料列表
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //去除黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = false;//关掉模糊
    // 视图延伸不考虑透明的Bars(这里包含导航栏和状态栏)
    // 意思就是延伸到边界
    self.extendedLayoutIncludesOpaqueBars = true;//解决视图下移64
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
//       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"373a41"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.title = @"首页";
    //加载数据
    [self loadData];
}
-(UIStatusBarStyle)preferredStatusBarStyle{//如果有导航栏必须在导航栏重写- (UIViewController *)childViewControllerForStatusBarStyle{
    //    return self.topViewController;
    //}
    //默认导航栏样式：黑字
    return UIStatusBarStyleDefault;
}
- (void)loadData{
    NSString *urlString = [NSString stringWithFormat:@"%@msgType=0",mNoticeList];
    HttpClient *client = [HttpClient defaultClient];
    [client.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [client requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArr = (NSArray*)responseObject[@"rows"];
        for (NSDictionary *dic in responseArr) {
            HomePageNoticeModel *infoModel = [HomePageNoticeModel mj_objectWithKeyValues:dic];
            [self.noticeNewsArr addObject:infoModel];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    [self setUpUI];
}
- (void)setUpUI {
    //背景view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-self.tabBarController.tabBar.bounds.size.height)];
    backView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [self.view addSubview:backView];
    //功能列表(CollectionView)
    // 用来接收数据 方便设置数据源
    self.functionListData = [self loadFunctionListData];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 175*kiphone6H) collectionViewLayout:[[FunctionListFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [backView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset((kTopHeight+3)*kiphone6H);
        make.left.right.offset(0);
        make.height.offset(175*kiphone6H);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
//    // 注册单元格
    [collectionView registerClass:[HomeFunctionCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [backView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(5*kiphone6H);
        make.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[HomeNoticeNewsTVCell class] forCellReuseIdentifier:tableCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 46*kiphone6H;
    
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.functionListData.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    HomeFunctionCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.functionListModel = self.functionListData[indexPath.row];
    return cell;
}
//
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:{
            HomePageScanVC *vc = [[HomePageScanVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            HomePageInventoryVC *vc = [[HomePageInventoryVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
//        case 2:{
//            YJReportRepairVC *vc = [[YJReportRepairVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 3:{
//            YJExpressDeliveryVC *vc = [[YJExpressDeliveryVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
        case 4:{
            PostNoticeVC *vc = [[PostNoticeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:{
            AssetsManangeVC *vc = [[AssetsManangeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
//        case 6:{
//            YJHouseSearchListVC *vc = [[YJHouseSearchListVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 7:{
//            YJRenovationViewController *vc = [[YJRenovationViewController alloc] init];
//            vc.title = @"装修服务";
//            vc.businessId = 12;
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
            
            break;
            
        default:
            break;
    }
    
}
//
// 解析功能列表数据
- (NSArray*)loadFunctionListData
{
    return [NSArray objectListWithPlistName:@"HomeFunctionList.plist" clsName:@"HomeFunctionListModel"];
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticeNewsArr.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNoticeNewsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    cell.model = self.noticeNewsArr[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 32*kiphone6H)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *titlelabel = [UILabel labelWithText:@"通知" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:15];
    [titleView addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [titleView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0.5*kiphone6H);
    }];
    return titleView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*kiphone6H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46*kiphone6H;
//    // 2 .给tableview缓存行高属性赋值并计算
//    YJReportRepairRecordModel *comModel = self.recordArr[indexPath.row];// 2.1 找到这个cell对应的数据模型
//    NSString *thisId = [NSString stringWithFormat:@"%ld",comModel.info_id];// 2.2 取出模型对应id作为cell缓存行高对应key
//    CGFloat cacheHeight = [[self.cellHeightCache valueForKey:thisId] doubleValue];// 2.3 根据这个key取这个cell的高度
//    if (cacheHeight) {// 2.4 如果取得到就说明已经存过了，不需要再计算，直接返回这个高度
//        return cacheHeight;
//    }
//    YJRepairRecordTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:tableCellid];// 2.4 如果没有取到值说明是第一遍，需要取一个cell(作为计算模型)并给cell的数据model赋值，进而计算出这个cell的高度
//    commentCell.model = comModel;// 2.5 赋值并在cell中计算
//    [self.cellHeightCache setValue:@(commentCell.cellHeight) forKey:thisId];// 2.6 取cell计算出的高度存入tableview的缓存行高字典里，方便读取
//    //            NSLog(@"%@",self.cellHeightCache);
//    return commentCell.cellHeight;
}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    //    self.navBarBgAlpha = @"0.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
//    //    self.navigationController.navigationBar.translucent = true;
//    self.navigationController.navigationBarHidden = YES;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    
//    //    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
//}
#pragma mark -懒加载
-(NSMutableArray *)noticeNewsArr{
    if (_noticeNewsArr == nil) {
        _noticeNewsArr = [NSMutableArray array];
    }
    return _noticeNewsArr;
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
