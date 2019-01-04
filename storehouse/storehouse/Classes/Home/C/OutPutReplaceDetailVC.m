//
//  OutPutReplaceDetailVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/27.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "OutPutReplaceDetailVC.h"
#import "ApplyDetailTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
//#import "BuyApplyDetailModel.h"
//#import "ApproveDetailAssetTVCell.h"
#import "UILabel+Addition.h"
#import "ReplaceScanVC.h"

static NSString* tableCellid = @"table_cell";
static NSString* assetCellid = @"table_assetCellid";
@interface OutPutReplaceDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,barCodeDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) NSMutableArray *assetsArray;//申请相关资产列表
@property (nonatomic, strong) ReplaceApplyDetailModel *replaceModel;//请求的以旧换新申请数据模型
@property(nonatomic,weak)UITextField *barCodeField;//更换资产编码
@property(nonatomic,weak)UITextField *nameField;//更换资产名称
@property(nonatomic,weak)UITextField *numField;//更换资产数量
//@property(nonatomic,assign)NSInteger isChecked;//是否验收(0否1是)
@end

@implementation OutPutReplaceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"以旧换新";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    self.tableView.scrollEnabled = true;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
//    [self.tableView registerClass:[ApproveDetailAssetTVCell class] forCellReuseIdentifier:assetCellid];
//    self.isChecked = 2;//初始化
}
-(void)setModel:(ReplaceApplyDetailModel *)model{
    _model = model;
    [SVProgressHUD show];// 动画开始
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"旧物名称",@"旧物编码",@"旧物数量",@"申请时间", @"备注说明",@"新物名称",@"新物编码",@"新物数量",nil];
    
    NSString *listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetOldfornewDetail,model.info_id];
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *replaceApplyDic = dic[@"assetOldfornew"];
            ReplaceApplyDetailModel *replaceModel = [ReplaceApplyDetailModel mj_objectWithKeyValues:replaceApplyDic];
            self.replaceModel = replaceModel;
            
            [self.tableView reloadData];
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemTypeArray.count;//
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    
    cell.itemLabel.text = self.itemTypeArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.itemContentLabel.text = self.replaceModel.departmentName;
            break;
        case 1:
            cell.itemContentLabel.text = self.replaceModel.userName;
            break;
        case 2:
            cell.itemContentLabel.text = self.replaceModel.assetName;
            break;
        case 3:
            cell.itemContentLabel.text = self.replaceModel.num;
            break;
        case 4:
            cell.itemContentLabel.text = self.replaceModel.num;
            break;
        case 5:
            cell.itemContentLabel.text = self.replaceModel.comment;
            break;
        case 6:
            cell.itemContentLabel.text = self.replaceModel.gmtCreateString;
            break;
        case 7:
            if (self.model.outboundDateString.length > 0) {//已更换
                cell.itemContentLabel.text = self.replaceModel.info_newAssetName;
            }else{//未更换，新物品名称
                cell.contentField.hidden = false;
                self.nameField = cell.contentField;
                cell.contentField.delegate = self;
                cell.contentField.enabled = false;
                //扫一扫按钮
                UIButton *scanButton = [[UIButton alloc]init];
                [scanButton setImage:[UIImage imageNamed:@"replace_scan"] forState:UIControlStateNormal];
                scanButton.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
                scanButton.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
                scanButton.layer.borderWidth = 1;
                [cell.contentView addSubview:scanButton];
                [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(cell.contentField);
                    make.right.offset(-31);
                    make.width.offset(35);
                }];
                [scanButton addTarget:self action:@selector(newAssetReplace) forControlEvents:UIControlEventTouchUpInside];
//                self.listButton = scanButton;
            }
            break;
        case 8:
            if (self.model.outboundDateString.length > 0) {//已更换
                cell.itemContentLabel.text = self.replaceModel.num;
            }else{//未更换，新物品编码
                cell.contentField.hidden = false;
//                cell.contentField.text = self.replaceModel.totalNum;
                self.barCodeField = cell.contentField;
                cell.contentField.delegate = self;
                cell.contentField.enabled = false;
            }
            break;
        case 9:
            if (self.model.outboundDateString.length > 0) {//已更换
                cell.itemContentLabel.text = self.replaceModel.num;
            }else{//未更换，新物品数量
                cell.contentField.hidden = false;
//                cell.contentField.text = self.replaceModel.totalNum;
                self.numField = cell.contentField;
                cell.contentField.delegate = self;
                cell.contentField.enabled = false;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.model.outboundDateString.length == 0) {//未更换
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        footerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        //确定button
        UIButton *confirmBtn = [[UIButton alloc]init];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
        [confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.layer.masksToBounds = true;
        confirmBtn.layer.cornerRadius = 5;
        [footerView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.equalTo(footerView.mas_top).offset(95);
            make.width.offset(80);
            make.height.offset(46);
        }];
        [confirmBtn addTarget:self action:@selector(confirmCheckBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }else{
        return nil;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.model.outboundDateString.length == 0) {//未更换
      return 150;
    }else{
      return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

#pragma mark -barcodeDelegate
//5.执行代理协议
-(void)returnBarCode:(NSString *)barCode{
    self.barCodeField.text = barCode;
    
}
#pragma mark - btnClick
//扫描获取替换信息
-(void)newAssetReplace{
    ReplaceScanVC *vc = [[ReplaceScanVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
    
}

//是否验收确定按钮点击事件
-(void)confirmCheckBtnClick:(UIButton*)sender{
//    出库入库》以旧换新》执行更换接口
//http://192.168.1.168:8085/mobileapi/assetOldfornew/saveChange.do
//    参数：
//    |id             |Long     |Y    |编号
//    |num            |Integer  |Y    |实际更新数量
//    |newAssetId     |Long     |N    |新的资产编号
//    错误码：
//    1=缺少参数：id
//    2=缺少参数：num
//    3=对应编号的以旧换新申请不存在！
    if (self.numField.text.intValue < 1) {
        [SVProgressHUD showInfoWithStatus:@"更换数量不能小于1"];
        return;
    }
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@&id=%@&num=%@&newAssetId=%@",mfpOutPutAssetRepalceConfirmRequest,self.model.info_id,self.numField.text,self.replaceModel.info_newAssetId];
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"更换成功"];
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }else{
            [SVProgressHUD showInfoWithStatus:dic[@"message"]];
        }
        sender.enabled = true;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        sender.enabled = true;
        return ;
    }];
}
#pragma mark - 懒加载
-(NSMutableArray *)assetsArray{
    if (_assetsArray == nil) {
        _assetsArray = [NSMutableArray array];
    }
    return _assetsArray;
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
