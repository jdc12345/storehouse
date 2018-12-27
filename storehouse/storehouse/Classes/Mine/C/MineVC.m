//
//  MineVC.m
//  storehouse
//
//  Created by 万宇 on 2018/5/30.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "MineVC.h"
#import "PersonalTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "UILabel+Addition.h"
#import "ZWPullMenuView.h"
#import <Photos/Photos.h>
#import "MyNewsListVC.h"
#import <UIView+WebCache.h>
#import "MineAssetsVC.h"
#import "MineSettingVC.h"

@interface MineVC ()<UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *genderV;//性别
@property (nonatomic, strong) UIImageView *iconView;//头像
//@property (nonatomic, strong) YYHomeUserModel *personalModel;//用户个人信息
@property(nonatomic,weak)UIImage *image;//选中图片

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    //去除黑线
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.translucent = false;//关掉模糊
//    // 视图延伸不考虑透明的Bars(这里包含导航栏和状态栏)
//    // 意思就是延伸到边界
//    self.extendedLayoutIncludesOpaqueBars = true;//解决视图下移64
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.title = @"我的";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"我的消息",@"我的资产"],@[@"设置"]]];
    self.iconList =@[@[@"mine_news",@"mine_settings"],@[@"mine_wallet"]];
    
    //    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70 *kiphone6)];
    //    headView.backgroundColor = [UIColor whiteColor];
    //    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    //    [headView addSubview:imageV];
    //    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(headView).with.offset(20 *kiphone6);
    //        make.left.equalTo(headView).with.offset(20 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake((kScreenW -40*kiphone6), 30 *kiphone6));
    //    }];
    self.tableView.tableHeaderView = [self personInfomation];
    if (@available(iOS 11.0, *)) {
        //iOS 11
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{//不是iOS 11
        self.automaticallyAdjustsScrollViewInsets = false;
    }
}
- (UIView *)personInfomation{
    
    //添加头部视图
    //    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 310)];
    //    headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //    [self.view addSubview:headerView];
    //添加背景视图
    CGRect rect;
    if (kScreenH >= 812) {
        rect = CGRectMake(0, 0, kScreenW, 188+44);
    }else{
        rect = CGRectMake(0, 0, kScreenW, 188);
    }
    UIImageView *backView = [[UIImageView alloc]initWithFrame:rect];
    backView.userInteractionEnabled = true;
    //    [headerView addSubview:backView];
    UIImage *oldImage = [UIImage imageNamed:@"mine_headerBack"];
    backView.image = oldImage;
    //添加头像
    UIImageView *iconView = [[UIImageView alloc]init];
    UIImage *iconImage = [UIImage imageNamed:@"personal_select"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,[CcUserModel defaultClient].avatar];
    [iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:iconImage options:SDWebImageHandleCookies];//这个标志表示可以逐步下载图片，在下载过程中，网页能够逐步的显示图片。默认情况下，图片只在下载完成后一次性显示
//SDWebImageHandleCookies:通过设置NSMutableURLRequest来操作cookies保存到NSHTTPCookieStore。 HTTPShouldHandlerCookies = YES。
    iconView.image = iconImage;
    [backView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        if (kScreenH >= 812) {
            make.top.offset(32+44);
        }else{
            make.top.offset(32);
        }
        make.width.height.offset(79);
    }];
    iconView.layer.cornerRadius=79*0.5;//裁成圆角
    iconView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    iconView.layer.borderWidth = 1.5;
    iconView.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
    iconView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    //将手势添加至需要相应的view中
    [iconView addGestureRecognizer:tapGesture];
    CcUserModel *model = [CcUserModel defaultClient];
    //添加名字
    NSString *nameStr = [NSString stringWithFormat:@"姓名:%@",model.trueName];
    UILabel *namelabel = [UILabel labelWithText:nameStr andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
    [backView addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView);
        make.top.equalTo(iconView.mas_bottom).offset(13);
    }];
    
    self.nameLabel = namelabel;
    self.iconView = iconView;
    //添加电话
    NSString *telStr = [NSString stringWithFormat:@"电话:%@",model.telephone];
    UILabel *tellabel = [UILabel labelWithText:telStr andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
    [backView addSubview:tellabel];
    [tellabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconView);
        make.top.equalTo(namelabel.mas_bottom).offset(13);
    }];
    return backView;
}
#pragma mark - click
- (void)headViewClick{
//    YYPInfomartionViewController *pInfoVC = [[YYPInfomartionViewController alloc]init];
//    pInfoVC.personalModel = self.personalModel;
//    [self.navigationController pushViewController:pInfoVC animated:YES];
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:self.iconView titleArray:@[@"拍摄",@"相册"]];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
//    __weak typeof(menuView) weakMenuView = menuView;
    __weak typeof(self) weakSelf = self;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        switch (menuRow) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = weakSelf;
                picker.allowsEditing = YES; //可编辑
                //判断是否可以打开照相机
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    //摄像头
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                } else { //否则打开照片库
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                }
                [self presentViewController:picker animated:YES completion:nil];
            }
                break;
                case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES; //可编辑
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:picker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    };
}
#pragma mark - UIImagePickerControllerDelegate

//拍摄完成后要执行的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //    BOOL success;
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([mediaType isEqualToString:@"public.image"]) {
        //得到照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//新拍摄图片才需要存储
                //图片存入相册
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
        }
        [self.iconView setImage:image];
        self.image = image;
        [self postImageRequest];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CcUserModel *model = [CcUserModel defaultClient];
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[MyNewsListVC alloc]init] animated:YES];
        }else{
            MineAssetsVC *shopVC = [[MineAssetsVC alloc]init];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }else if (indexPath.section == 1){
        MineSettingVC *shopVC = [[MineSettingVC alloc]init];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataSource[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46 *kiphone6H;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    return headerView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalTVCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"YYPersonalTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.titleLabel.text = self.dataSource[indexPath.section][indexPath.row];
    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.section][indexPath.row]];
    
    return homeTableViewCell;
    
}

#pragma mark -
#pragma mark ------------Http client----------------------
- (void)postImageRequest{
    NSData *picData = UIImageJPEGRepresentation(self.image, 0.5);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [SVProgressHUD show];
    [manager POST:mPostAvatarRequest parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (picData) {
            //  图片上传
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"avatar%@.png", [formatter stringFromDate:[NSDate date]]];
            [formData appendPartWithFileData:picData name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSString *message = responseObject[@"message"];
        CcUserModel *defaultModel = [CcUserModel defaultClient];
        defaultModel.avatar = message;//后台返回图片地址赋值给本地存储
        [defaultModel saveAllInfo];
//        [message stringByRemovingPercentEncoding];
//        NSLog(@"房间图片上传== %@,%@", responseObject,message);
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
        }else{
            [SVProgressHUD showErrorWithStatus:message];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"错误信息=====%@", error.description);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败!"];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    [self httpRequest];
}
//如果仅设置当前页导航透明，需加入下面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{//如果有导航栏必须在导航栏重写- (UIViewController *)childViewControllerForStatusBarStyle{
    //    return self.topViewController;
    //}
    return UIStatusBarStyleLightContent;
}
#pragma mark -懒加载

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[PersonalTVCell class] forCellReuseIdentifier:@"YYPersonalTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
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
