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

static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
@interface HomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray* functionListData;//功能列表
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    NSLog(@"sta:%f,nav:%f",kStatusBarHeight,kTopHeight);
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
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
//// cell点击事件
//- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
//{
//    switch (indexPath.row) {
//        case 0:{
//            YJPropertyBillVC *vc = [[YJPropertyBillVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 1:{
//            YJLifepaymentVC *vc = [[YJLifepaymentVC alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
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
//        case 4:{
//            YJNearbyShopViewController *vc = [[YJNearbyShopViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 5:{
//            YJRenovationViewController *vc = [[YJRenovationViewController alloc] init];
//            vc.title = @"家政服务";
//            vc.businessId = 11;
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
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
//            
//            break;
//            
//        default:
//            break;
//    }
//    
//}
//
// 解析功能列表数据
- (NSArray*)loadFunctionListData
{
    return [NSArray objectListWithPlistName:@"HomeFunctionList.plist" clsName:@"HomeFunctionListModel"];
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
