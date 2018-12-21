//
//  PurchaseOrderDetailVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "PurchaseOrderDetailVC.h"
#import "ApplyDetailTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "BuyApplyDetailModel.h"
#import "ApproveDetailAssetTVCell.h"
#import "UILabel+Addition.h"

static NSString* tableCellid = @"table_cell";
static NSString* assetCellid = @"table_assetCellid";
@interface PurchaseOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) NSMutableArray *assetsArray;//申请相关资产列表
@property (nonatomic, strong) BuyApplyDetailModel *buyModel;//请求的采购申请数据模型
@property(nonatomic,weak)UITextField *contentField;//备注意见

@end

@implementation PurchaseOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.tableView registerClass:[ApproveDetailAssetTVCell class] forCellReuseIdentifier:assetCellid];
    
}
-(void)setState:(NSInteger)state{
    _state = state;
    switch (state) {
        case 1:
            self.title = @"待采购";
            break;
        case 2:
            self.title = @"采购中";
            break;
        case 3:
            self.title = @"已入库";
            break;
        case 4:
            self.title = @"已退货";
            break;
            
        default:
            break;
    }
}
-(void)setModel:(PurchaseOrderListModel *)model{
    _model = model;
    [SVProgressHUD show];// 动画开始
    //http://192.168.1.168:8085/mobileapi/buyApply/get.do?id=1
    //    msgStatus：消息状态, 0=审批中，1=已审批
    NSString *listUrlStr = @"";
    if (self.state == 1||self.state == 2) {
        self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由",@"审批备注",@"申请时间", nil];
    }else{
        self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由",@"审批备注",@"申请时间",@"采购单价",@"采购地点",@"验收评价",@"验收意见", nil];
    }
    
    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mbuyApplyDetail,model.info_id];
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *buyApplyDic = dic[@"buyApply"];
            BuyApplyDetailModel *buyModel = [BuyApplyDetailModel mj_objectWithKeyValues:buyApplyDic];
            self.buyModel = buyModel;
            
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
            cell.itemContentLabel.text = self.buyModel.departmentName;
            break;
        case 1:
            cell.itemContentLabel.text = self.buyModel.assetName;
            break;
        case 2:
            cell.itemContentLabel.text = self.buyModel.specTyp;
            break;
        case 3:
            cell.itemContentLabel.text = self.buyModel.unit;
            break;
        case 4:
            cell.itemContentLabel.text = self.buyModel.worth;
            break;
        case 5:
            cell.itemContentLabel.text = self.buyModel.buyCount;
            break;
        case 6:
            cell.itemContentLabel.text = self.buyModel.producerName;
            break;
        case 7:
            cell.itemContentLabel.text = self.buyModel.buyCate;
            break;
        case 8:
            cell.itemContentLabel.text = self.buyModel.buyReason;
            break;
        case 9:
            if (self.state == 1) {
                cell.contentField.hidden = false;
                self.contentField = cell.contentField;
            }else{
                cell.contentField.hidden = true;
                cell.itemContentLabel.text = self.buyModel.rejectReason;
            }
            break;
        case 10:
            cell.itemContentLabel.text = self.buyModel.applyTimeString;
            break;
        case 11:
            cell.itemContentLabel.text = self.buyModel.buyWorth;
            break;
        case 12:
            cell.itemContentLabel.text = self.buyModel.buyAddress;
            break;
        case 13:
            cell.itemContentLabel.text = self.buyModel.acceptanceEvaluation;
            break;
        case 14:
            if ([self.buyModel.acceptanceOpinion integerValue] == 1) {
                cell.itemContentLabel.text = @"同意";
            }else{
                cell.itemContentLabel.text = @"拒绝";
            }
            break;
            
        default:
            break;
    }
    
        return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (self.state) {
        case 1://待采购
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 180)];
            view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
            //驳回、同意、失效lebal
            //同意btn
            UIButton *agreeBtn = [[UIButton alloc]init];
            [agreeBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
            [agreeBtn setTitle:@"开始采购" forState:UIControlStateNormal];
            agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [agreeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            agreeBtn.layer.masksToBounds = YES;
            agreeBtn.layer.cornerRadius = 5;
            [view addSubview:agreeBtn];
            [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.offset(0);
                make.width.offset(100);
                make.height.offset(40);
            }];
            [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return view;
            }
            break;
        case 2://采购中
        case 3://已入库
        case 4://已退货
            return nil;
            break;
        default:
            break;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (self.state) {
        case 1:
            return 180;
            break;
        case 2:
        case 3:
        case 4:
            return 0;
            break;
            
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}


#pragma mark - btnClick
-(void)agreeBtnClick:(UIButton*)sender{
    int isAdopt;//是否同意
    if (sender.tag) {
        isAdopt = 1;
    }else{
        isAdopt = 0;
    }
//    开始采购接口
//http://192.168.1.168:8085/mobileapi/buyApply/startBuy.do?id=1
//    参数：
//    id=采购订单的编号
//    comment=备注
//    错误信息：
//    1=缺少参数：id
//    2=相关采购订单不存在
    NSString *listUrlStr = [NSString stringWithFormat:@"%@id=%@&comment=%@",mBegainbuyRequest,self.model.info_id,self.contentField.text];
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
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

