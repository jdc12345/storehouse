//
//  HomePageInventoryVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "HomePageInventoryVC.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "HistoryInventoryVC.h"
#import "NSObject+Formula.h"
#import "HistoryInventoryListModel.h"
#import "PurchasePepairReplaceScrapVC.h"

static NSInteger apedStart = 0;//上拉加载起始位置
@interface HomePageInventoryVC ()<UIScrollViewDelegate,refreshDelegate>
//跟button的监听事件有关
//@property(weak, nonatomic)UIView *cardLineView;
//
@property(weak, nonatomic)UIScrollView *cardDetailView;
//根据scrollView滚动距离设置滚动线位置时候需要
@property(strong, nonatomic)NSArray *cardCategoryButtons;
//设置滚动线约束时候需要
@property(strong, nonatomic)UIView *cardsView;
//@property(nonatomic,strong)NSMutableArray *willApproveList;//待审批数据
@property(nonatomic,strong)NSMutableArray *inventoryList;//历史盘点数据
//子控制器
@property(weak, nonatomic)HistoryInventoryVC *willApVC;
@property(weak, nonatomic)HistoryInventoryVC *apedVC;
@end
@implementation HomePageInventoryVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //去除黑线
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = false;//关掉模糊
    // 视图延伸不考虑透明的Bars(这里包含导航栏和状态栏)
    // 意思就是延伸到边界
    self.extendedLayoutIncludesOpaqueBars = true;//解决视图下移64
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = @"新键盘点";
    [self setupUI];
    [self requestInventoryList];//历史盘点
}
/**
 *  请求历史盘点数据列表
 */
- (void)requestInventoryList
{
    [SVProgressHUD show];// 动画开始
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@&start=0&limit=6",mInventoryList];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlStr method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSArray *listArr = dic[@"rows"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in listArr) {
                HistoryInventoryListModel *infoModel = [HistoryInventoryListModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
                self.inventoryList = mArr;
                //传数据
                self.apedVC.inventoryList = self.inventoryList;
                [self.apedVC.tableView reloadData];
                if (self.inventoryList.count>0) {
                    apedStart = self.inventoryList.count;
                }
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
#pragma mark - refreshDelegate
-(void)transViewController:(HistoryInventoryVC *)willApproveVC{
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
        NSString *urlStr = [NSString stringWithFormat:@"%@&start=0&limit=6",mInventoryList];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [httpManager requestWithPath:urlStr method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                NSArray *listArr = dic[@"rows"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in listArr) {
                    HistoryInventoryListModel *infoModel = [HistoryInventoryListModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                self.inventoryList = mArr;
                //传数据
                self.apedVC.inventoryList = self.inventoryList;
                if (self.apedVC.inventoryList.count>0) {
                    apedStart = self.apedVC.inventoryList.count;
                }
                [willApproveVC.tableView reloadData];//不刷新容易数组越界
                [willApproveVC.tableView.mj_header endRefreshing];
                willApproveVC.tableView.mj_footer.state = MJRefreshStateIdle;//改变footer的状态为初始化
                
            }else if ([dic[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [willApproveVC.tableView.mj_header endRefreshing];
            return ;
        }];
}
-(void)transForFootRefreshWithViewController:(HistoryInventoryVC *)willApproveVC{
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
        if (apedStart % 6 != 0) {//已经没有数据了，分页请求是按页请求的，只要已有数据数量没有超过最后一页的最大数量，再请求依然会返回最后一页的数据
            [willApproveVC.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@msgStatus=1&start=%ld&limit=6",mRequestApproveList,apedStart];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [httpManager requestWithPath:urlStr method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                NSArray *listArr = dic[@"rows"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in listArr) {
                    HistoryInventoryListModel *infoModel = [HistoryInventoryListModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                if (mArr.count>0) {
                    [self.apedVC.inventoryList addObjectsFromArray:mArr];
                    apedStart = self.apedVC.inventoryList.count;
                    [willApproveVC.tableView reloadData];
                    if (apedStart % 6 != 0) {
                        [willApproveVC.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [willApproveVC.tableView.mj_footer endRefreshing];
                    }
                }else{
                    [willApproveVC.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }else if ([dic[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [willApproveVC.tableView.mj_footer endRefreshing];
            return ;
        }];
}
-(void)transForPushDetailWithCell:(ApproveListModel *)model{
//    PurchasePepairReplaceScrapVC *detailVc = [[PurchasePepairReplaceScrapVC alloc]init];
//    detailVc.model = model;
//    [self.navigationController pushViewController:detailVc animated:true];
}
//
-(void)setupUI{
    //添加盘点分类
    UIView *cardsView = [[UIView alloc]init];
    cardsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardsView];
    //
    self.cardsView = cardsView;
    //添加分类按钮
    UIButton *ApprovedButton = [[UIButton alloc]init];
    UIButton *willApproveButton = [[UIButton alloc]init];
    //设置按钮标题
    [ApprovedButton setTitle:@"历史盘点" forState:UIControlStateNormal];
    [willApproveButton setTitle:@"新建盘点" forState:UIControlStateNormal];
    //把按钮添加到一个数组中
    NSArray *cardCategoryButtons = @[willApproveButton,ApprovedButton];
    //
    self.cardCategoryButtons = cardCategoryButtons;
    //循环把各个按钮通用的部分设置
    for (int i = 0; i < cardCategoryButtons.count; i ++) {
        UIButton *btn = cardCategoryButtons[i];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [btn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
//        [btn setBackgroundColor:[UIColor whiteColor]];
        //
        btn.tag = i;
        //添加按钮的监听事件
        [btn addTarget:self action:@selector(shopCategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cardsView addSubview:btn];
    }
    [willApproveButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    willApproveButton.backgroundColor = [UIColor colorWithHexString:@"1ebeec"];
    [ApprovedButton setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
    ApprovedButton.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    //添加盘点信息背景scrolliew
    UIScrollView *cardDetailView = [[UIScrollView alloc]init];
    //打开分页符
    cardDetailView.pagingEnabled = YES;
    //取消滚动条
    cardDetailView.showsVerticalScrollIndicator = NO;
    cardDetailView.showsHorizontalScrollIndicator = NO;
    cardDetailView.bounces = false;
    cardDetailView.backgroundColor = [UIColor orangeColor];
    //添加帖子详情
    [self.view addSubview:cardDetailView];
    //
    self.cardDetailView = cardDetailView;
    //
    self.cardDetailView.delegate = self;
    //
    HistoryInventoryVC *willApVC = [[HistoryInventoryVC alloc]init];
    HistoryInventoryVC *apedVC = [[HistoryInventoryVC alloc]init];
    //设置代理
    willApVC.delegate = self;
    apedVC.delegate = self;
    
    //
    willApVC.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    apedVC.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    //添加子控件的view
    [cardDetailView addSubview:willApVC.view];
    [cardDetailView addSubview:apedVC.view];
    //建立父子关系
    [self addChildViewController:willApVC];
    [self addChildViewController:apedVC];
    //告诉程序已经添加成功
    [willApVC didMoveToParentViewController:self];
    [apedVC didMoveToParentViewController:self];
    //
    self.willApVC = willApVC;
    self.apedVC = apedVC;
    //设置盘点分类约束
    [cardsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        if (kScreenH > 736) {//iPhone X
            make.bottom.offset(-34);
        }else{
            make.bottom.offset(0);
        }
        make.height.offset(44);
    }];
    //设置按钮约束
    [willApproveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.offset(kScreenW*0.5);
    }];
    [ApprovedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(willApproveButton.mas_right);
        make.width.offset(kScreenW*0.5);
    }];
    
    //约束
    [cardDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(88);
        make.bottom.equalTo(cardsView.mas_top);
    }];
    [cardDetailView layoutIfNeeded];
    [willApVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
    [apedVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(willApVC.view.mas_right);
        make.width.equalTo(cardDetailView);
        make.height.equalTo(cardDetailView);
        
    }];
}

//按钮点击事件
-(void)shopCategoryButtonClick:(UIButton*)sender{
    [sender setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"1ebeec"];
    for (UIButton *btn in self.cardCategoryButtons) {
        if (btn.tag != sender.tag) {
            [btn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }
    }
    [self.cardDetailView setContentOffset:CGPointMake(sender.tag*self.cardDetailView.bounds.size.width, 0) animated:YES];
}
////根据偏移距离设置滚动线的位置
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    //获取偏移量
//    CGFloat offSetX = self.cardDetailView.contentOffset.x;
////    NSLog(@"%f",offSetX);
//    //滑动改变相应btn'的文字颜色
//    UIButton *hotBtn = self.cardCategoryButtons[0];
//    UIButton *selectBtn = self.cardCategoryButtons[1];
//    if (offSetX >= kScreenW) {
////        [self.cardLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.width.offset(kScreenW*0.5);
////            make.height.offset(2);
////            make.bottom.equalTo(self.cardsView);
////            make.centerX.offset(kScreenW*0.25);
////        }];
//        [selectBtn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
//        [hotBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
//    }else{
////        [self.cardLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.width.offset(kScreenW*0.5);
////            make.height.offset(2);
////            make.bottom.equalTo(self.cardsView);
////            make.centerX.offset(-kScreenW*0.25);
////        }];
//        [hotBtn setTitleColor:[UIColor colorWithHexString:@"1ebeec"] forState:UIControlStateNormal];
//        [selectBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
//
//    }
//
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
