//
//  CheckdetailVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/25.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "CheckdetailVC.h"
#import "ApplyDetailTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "BuyApplyDetailModel.h"
#import "ApproveDetailAssetTVCell.h"
#import "UILabel+Addition.h"

static NSString* tableCellid = @"table_cell";
static NSString* assetCellid = @"table_assetCellid";
@interface CheckdetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) NSMutableArray *assetsArray;//申请相关资产列表
@property (nonatomic, strong) BuyApplyDetailModel *buyModel;//请求的采购申请数据模型
@property(nonatomic,weak)UITextField *contentField;//备注意见
@property(nonatomic,weak)UIButton *yesBtn;
@property(nonatomic,weak)UIButton *noBtn;
@property(nonatomic,assign)NSInteger isChecked;//是否验收(0否1是)
@end

@implementation CheckdetailVC

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
    self.isChecked = 2;//初始化
}
-(void)setState:(NSInteger)state{
    _state = state;
    switch (state) {
        case 0:
            self.title = @"待验收";
            break;
        case 1:
            self.title = @"已验收";
            break;
        case 2:
            self.title = @"已退货";
            break;
            
        default:
            break;
    }
}
-(void)setModel:(BuyApplyDetailModel *)model{
    _model = model;
    [SVProgressHUD show];// 动画开始
    //http://192.168.1.168:8085/mobileapi/buyApply/get.do?id=1
    //    msgStatus：消息状态, 0=审批中，1=已审批
    NSString *listUrlStr = @"";
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"采购数量",@"生产厂家",@"采购类别",@"采购理由",@"审批备注",@"申请时间",@"采购单价",@"采购地点",@"验收评价", nil];
    
    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mbuyApplyDetail,model.info_id];
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *buyApplyDic = dic[@"buyApply"];
            BuyApplyDetailModel *buyModel = [BuyApplyDetailModel mj_objectWithKeyValues:buyApplyDic];
            self.buyModel = buyModel;
            
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
            cell.itemContentLabel.text = self.buyModel.buyCount;
            break;
        case 5:
            cell.itemContentLabel.text = self.buyModel.producerName;
            break;
        case 6:
            if ([self.buyModel.buyCate intValue] == 1) {
                cell.itemContentLabel.text = @"计划内";
            }else{
                cell.itemContentLabel.text = @"计划外";
            }
            
            break;
        case 7:
            cell.itemContentLabel.text = self.buyModel.buyReason;
            break;
        case 8:
            cell.itemContentLabel.text = self.buyModel.comment;
            break;
        case 9:
            cell.itemContentLabel.text = self.buyModel.applyTimeString;
            break;
        case 10:
            if (self.state == 0) {
                cell.contentField.hidden = false;
                cell.contentField.placeholder = @"选填";
                self.contentField = cell.contentField;
            }else{
                cell.contentField.hidden = true;
                cell.itemContentLabel.text = self.buyModel.buyWorth;
            }
            break;
        case 11:
            if (self.state == 0) {
                cell.contentField.hidden = false;
                cell.contentField.placeholder = @"选填";
                self.contentField = cell.contentField;
            }else{
                cell.contentField.hidden = true;
                cell.itemContentLabel.text = self.buyModel.buyAddress;
            }
            break;
        case 12:
            if (self.state == 0) {
                cell.contentField.hidden = false;
                cell.contentField.placeholder = @"选填";
                self.contentField = cell.contentField;
            }else{
                cell.contentField.hidden = true;
                cell.itemContentLabel.text = self.buyModel.acceptanceEvaluation;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //事项label
    UILabel *itemLabel = [UILabel labelWithText:@"验收意见" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [footerView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView.mas_top).offset(22);
        make.left.offset(15);
        make.width.offset(60);
    }];
    switch (self.state) {
        case 0://待验收
        {
            //yesbutton
            UIButton *yesBtn = [[UIButton alloc]init];
            yesBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [yesBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
            [yesBtn setTitle:@"是" forState:UIControlStateNormal];
            [footerView addSubview:yesBtn];
            [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemLabel);
                make.left.offset(95);
                make.width.offset(60);
                make.height.offset(64);
            }];
            [yesBtn setImage:[UIImage imageNamed:@"ifRepair_select"] forState:UIControlStateNormal];
            [yesBtn setImage:[UIImage imageNamed:@"ifRepair_selected"] forState:UIControlStateSelected];
            
            //nobutton
            UIButton *noBtn = [[UIButton alloc]init];
            noBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [noBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
            [noBtn setTitle:@"否" forState:UIControlStateNormal];
            [footerView addSubview:noBtn];
            [noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemLabel);
                make.left.equalTo(yesBtn.mas_right).offset(5);
                make.width.offset(60);
                make.height.offset(64);
            }];
            [noBtn setImage:[UIImage imageNamed:@"ifRepair_select"] forState:UIControlStateNormal];
            [noBtn setImage:[UIImage imageNamed:@"ifRepair_selected"] forState:UIControlStateSelected];
            yesBtn.tag = 60;
            noBtn.tag = 61;
            self.yesBtn = yesBtn;
            self.noBtn = noBtn;
            [yesBtn addTarget:self action:@selector(ifCheckedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [noBtn addTarget:self action:@selector(ifCheckedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
            //设置按钮内容[包括文字]的内边距
            yesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            noBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
            //设置按钮内容图片的内边距
            yesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            noBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            return footerView;
        }
            break;
        case 1://已验收
        {
            //事项内容label
            UILabel *contentLabel = [UILabel labelWithText:@"同意" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
            [footerView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemLabel);
                make.left.equalTo(itemLabel.mas_right).offset(15);
                make.width.offset(60);
            }];
            return footerView;
        }
        case 2://已退货
        {
            //事项内容label
            UILabel *contentLabel = [UILabel labelWithText:@"拒绝" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
            [footerView addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemLabel);
                make.left.equalTo(itemLabel.mas_right).offset(30);
                make.width.offset(60);
            }];
            return footerView;
        }
            break;
        default:
            break;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (self.state) {
        case 0:
            return 150;
            break;
        case 1:
        case 2:
            return 45;
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
//是否同意验收选择按钮点击事件
-(void)ifCheckedBtnClick:(UIButton*)sender{
    sender.selected =!sender.selected;
    if (sender.tag == 60) {//yesBtn
        if (sender.selected) {
            self.isChecked = 1;
            self.noBtn.selected = false;
        }else{
            self.isChecked = 0;
            self.noBtn.selected = true;
        }
    }else {//noBtn
        if (sender.selected) {
            self.isChecked = 0;
            self.yesBtn.selected = false;
        }else{
            self.isChecked = 1;
            self.yesBtn.selected = true;
        }
    }
}
//是否验收确定按钮点击事件
-(void)confirmCheckBtnClick:(UIButton*)sender{
//    出库入库》采购验收接口
//http://192.168.1.168:8085/mobileapi/buyApply/saveCheck.do
//    参数：
//    |id             |Long     |Y    |编号
//    |buyWorth       |Double   |N    |采购单价
//    |buyAddress     |String   |N    |采购地点
//    |acceptanceEvaluation|String    |N    |验收评价;
//    |acceptanceOpinion|Byte      |N    |验收意见;0=未处理，1=同意，2=退货
    //
    if (self.isChecked > 1) {
        [SVProgressHUD showInfoWithStatus:@"请选择是否完成维修"];
        return;
    }
    ApplyDetailTVCell *cell10 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    NSString *buyWorth = @"";//采购单价
    if (cell10.contentField.text.length > 0) {
        buyWorth = cell10.contentField.text;
    }
    ApplyDetailTVCell *cell11 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
    NSString *buyAddress = @"";//采购地点
    if (cell11.contentField.text.length > 0) {
        buyAddress = cell11.contentField.text;
    }
    ApplyDetailTVCell *cell12 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
    NSString *acceptanceEvaluation = @"";//验收评价
    if (cell12.contentField.text.length > 0) {
        acceptanceEvaluation = cell12.contentField.text;
    }
    sender.enabled = false;
    [SVProgressHUD show];// 动画开始
    NSString *reportUrlStr = [NSString stringWithFormat:@"%@&id=%@&acceptanceOpinion=%ld&buyWorth=%@&buyAddress=%@&acceptanceEvaluation=%@",mfpCheckConfirmRequest,self.model.info_id,self.isChecked,buyWorth,buyAddress,acceptanceEvaluation];
    
    reportUrlStr = [reportUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:reportUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            if (self.isChecked) {
                [SVProgressHUD showSuccessWithStatus:@"验收成功"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"已退货"];
            }
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
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

