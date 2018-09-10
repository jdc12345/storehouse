//
//  ApplyVC.m
//  storehouse
//
//  Created by 万宇 on 2018/5/30.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "ApplyVC.h"
#import "LaunchMainHeaderView.h"
#import "LaunchPurchaseVC.h"
#import "LaunchGetUseVC.h"
#import "launchBorrowApplyVC.h"
#import "LaunchRepairVC.h"
#import "LaunchScrapVC.h"
#import "LaunchRetiringVC.h"
#import "LaunchSubListVC.h"
#import "CcUserModel.h"
#import "permissionTypeModel.h"
#import <MJExtension.h>

@interface ApplyVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,assign) BOOL                isHaveRegectRedPoint;
@property (nonatomic,assign) BOOL                isHaveStopRedPoint;
@property (nonatomic, strong) LaunchMainHeaderView   * headerView;
@property (nonatomic, strong) UICollectionView          * collectionView;
@property (nonatomic, strong) NSArray                   * launchTypeArray;
@property (nonatomic, strong) NSArray                   * launchTypeColorArray;

@end

@implementation ApplyVC

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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.title = @"申请";
    self.view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    self.isHaveRegectRedPoint = NO;
    self.isHaveStopRedPoint = NO;
    self.navigationItem.leftBarButtonItem = nil;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgActionRefreshLaunchType) name:MsgTokenActionWithLaunchTypeComleteRefreshList object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mggActionRefreshRejectTabTipPoint) name:MsgTokenActionWithLaunchExpenseRejected object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mggActionRefreshStopTabTipPoint) name:MsgTokenActionWithLaunchExpenseStoped object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgRequestLaunchTypeList) name:CPXLaunchManagerChangeTypeHiddenKey object:nil];
//    self.launchTypeArray = [[CPXDataBase defaultDataBase] launchTypeListModelArray];
    self.headerView.hidden = NO;
    [self.collectionView reloadData];
//    [self requestApplyTypeListIsHeaderRefresh:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self refreshLaunchTabRedPoint];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 请求发起类型

- (void) requestApplyTypeListIsHeaderRefresh:(BOOL)isHeaderRefresh
{
//    [[CPXHTTPClient instanceClient] requestApplyListIsNeedLoadingStatus:!isHeaderRefresh
//                                                          completeBlock:^(NSArray *dataArray, CPXError *error) {
//                                                              [self.collectionView.header endRefreshing];
//                                                              if (!error) {
//                                                                  self.launchTypeArray = dataArray;
//                                                                  [self.collectionView reloadData];
//                                                              }
//                                                          }];
}
#pragma mark - 懒加载
- (LaunchMainHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[LaunchMainHeaderView alloc] init];
        __weak typeof(self) weakSelf = self;
        [_headerView setClickApprovalBlock:^{//点击调转事件
            [weakSelf pushToExpenseSnListWithIndex:0];
        } clickRejectBlock:^{
            [weakSelf pushToExpenseSnListWithIndex:1];
            weakSelf.headerView.isHaveRegectRedPoint = NO;
        } clickConfirmBlock:^{
            [weakSelf pushToExpenseSnListWithIndex:2];
        } clickLossBlock:^{
            [weakSelf pushToExpenseSnListWithIndex:3];
            weakSelf.headerView.isHaveStopRedPoint = NO;
        }];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(2*kiphone6H);
            make.left.right.offset(0);
            make.height.mas_equalTo(68*kiphone6H);
        }];
    }
    return _headerView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 3;//cell行间距
        layout.minimumInteritemSpacing = 0;
        CGFloat itemWith = (kScreenW - 10) / 3;
        layout.itemSize = CGSizeMake(itemWith, 72*kiphone6H);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.offset(2);
            make.right.offset(-2);
            make.bottom.offset(0);
        }];
//        __weak typeof(self) weakSelf = self;
//        [_collectionView addLegendHeaderWithRefreshingBlock:^{
//            [weakSelf requestApplyTypeListIsHeaderRefresh:YES];
//        }];
//        _collectionView.header.updatedTimeHidden = YES;
    }
    return _collectionView;
}
-(NSArray *)launchTypeArray{
    if (_launchTypeArray == nil) {
        _launchTypeArray = [NSArray arrayWithObjects:@"采购申请",@"领用申请",@"借用申请",@"维修申请",@"以旧换新申请",@"报废申请",@"退库申请", nil];
    }
    return _launchTypeArray;
}
-(NSArray *)launchTypeColorArray{
    if (_launchTypeColorArray == nil) {
        _launchTypeColorArray = [NSArray arrayWithObjects:@"2face4",@"23b880",@"bf9e51",@"9073ab",@"dc8268",@"0aa5d5",@"bf9e51", nil];
    }
    return _launchTypeColorArray;
}
#pragma mark - 按钮点击事件
- (void) pushToExpenseSnListWithIndex:(NSInteger)index
{
    LaunchSubListVC *launchListVC = [[LaunchSubListVC alloc] init];
    launchListVC.index = index;
//    launchListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:launchListVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.launchTypeArray.count;
}
//
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:self.launchTypeColorArray[indexPath.row]];
    UILabel *itemLabel = [[UILabel alloc]init];
    itemLabel.font = [UIFont systemFontOfSize:15];
    itemLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [cell.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    itemLabel.text = self.launchTypeArray[indexPath.row];
    return cell;
}
//
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            CcUserModel *defaulModel = [CcUserModel defaultClient];
            if (defaulModel.permission.count > 0) {
                BOOL flag = false;
            for (NSDictionary *permissionDic in defaulModel.permission) {
                permissionTypeModel *perModel = [permissionTypeModel mj_objectWithKeyValues:permissionDic];
                //每次需遍历判断是否有该权限码和对应的权限
                if ([perModel.target isEqualToString:@"buyApply"]&&[perModel.operaton isEqualToString:@"create"]) {
                    LaunchPurchaseVC *launchPurchaseVC = [[LaunchPurchaseVC alloc]init];
                    [self.navigationController pushViewController:launchPurchaseVC animated:true];
                    flag = true;
                    break;
                }
            }
                if (flag == false) {
                    [SVProgressHUD showInfoWithStatus:@"你没有该权限"];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"你没有任何申请权限"];
            }
        }
            break;
        case 1:
        {
            LaunchGetUseVC *launchGetUseVC = [[LaunchGetUseVC alloc]init];
            [self.navigationController pushViewController:launchGetUseVC animated:true];
        }
            break;
        case 2:
        {
            launchBorrowApplyVC *launchBorrowVC = [[launchBorrowApplyVC alloc]init];
            [self.navigationController pushViewController:launchBorrowVC animated:true];
        }
            break;
        case 3:
        {
            LaunchRepairVC *launchRepairVC = [[LaunchRepairVC alloc]init];
            launchRepairVC.applyType = 3;
            [self.navigationController pushViewController:launchRepairVC animated:true];
        }
            break;
        case 4:
        {
            LaunchRepairVC *launchReplaceVC = [[LaunchRepairVC alloc]init];
            launchReplaceVC.applyType = 4;
            [self.navigationController pushViewController:launchReplaceVC animated:true];
        }
            break;
        case 5:
        {
            LaunchScrapVC *launchScrapVC = [[LaunchScrapVC alloc]init];
            [self.navigationController pushViewController:launchScrapVC animated:true];
        }
            break;
//        case 6:
//        {
//            LaunchGetUseVC *launchReturnVC = [[LaunchGetUseVC alloc]init];
//            launchReturnVC.applyType = 6;
//            [self.navigationController pushViewController:launchReturnVC animated:true];
//        }
//            break;
        case 6:
        {
            LaunchRetiringVC *launchRetiringVC = [[LaunchRetiringVC alloc]init];
            [self.navigationController pushViewController:launchRetiringVC animated:true];
        }
            break;
            
        default:
            break;
    }
    
    

//    if (self.launchTypeArray.count > indexPath.row) {
//        CPXLaunchTypeModel * typeModel = [self.launchTypeArray objectAtIndex:indexPath.row];
//        [CPXCommonDataModel instanceCommonData].launchTypeModel = typeModel;
//        UIViewController *launchVC = [CPXLaunchVCManager launchBaseVCWithTypeId:typeModel.type];
//        launchVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:launchVC animated:YES];
//    }
}
//
//#pragma mark - msgAction
//
//- (void)msgRequestLaunchTypeList
//{
//    [self.collectionView.header beginRefreshing];
//}
//
//- (void)msgActionRefreshLaunchType{
//    [self.collectionView reloadData];
//}
//
//- (void)mggActionRefreshRejectTabTipPoint{
//    self.isHaveRegectRedPoint = YES;
//    self.headerView.isHaveRegectRedPoint = self.isHaveRegectRedPoint;
//    [self refreshLaunchTabRedPoint];
//}
//
//- (void)mggActionRefreshStopTabTipPoint{
//    self.isHaveStopRedPoint = YES;
//    self.headerView.isHaveStopRedPoint = self.isHaveStopRedPoint;
//    [self refreshLaunchTabRedPoint];
//}
//
//- (void)refreshLaunchTabRedPoint{
//    NSInteger currentTab = [self.tabBarController selectedIndex];
//    if (currentTab == 1 || (!self.isHaveRegectRedPoint && !self.isHaveStopRedPoint)) {
//        //隐藏底部红点
//        UITabBar *tabBar = self.appDelegate.tabBarController.tabBar;
//        [tabBar hideNotifyAtIndex:1];
//    }else{
//        //显示底部红点
//        UITabBar *tabBar = self.appDelegate.tabBarController.tabBar;
//        [tabBar showNotifyAtIndex:1];
//    }
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
