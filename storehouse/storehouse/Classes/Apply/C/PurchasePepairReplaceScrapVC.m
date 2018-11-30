//
//  PurchasePepairReplaceScrapVC.m
//  storehouse
//
//  Created by 万宇 on 2018/9/14.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "PurchasePepairReplaceScrapVC.h"
#import "ApplyDetailTVCell.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "BuyApplyDetailModel.h"
#import "RepairApplyDetailModel.h"
#import "ScrapApplyDetailModel.h"

static NSString* tableCellid = @"table_cell";
@interface PurchasePepairReplaceScrapVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property (nonatomic, strong) BuyApplyDetailModel *buyModel;//请求的采购申请数据模型
@property (nonatomic, strong) RepairApplyDetailModel *repairModel;//请求的维修申请数据模型
@property (nonatomic, strong) RepairApplyDetailModel *replaceModel;//请求的以旧换新申请数据模型
@property (nonatomic, strong) ScrapApplyDetailModel *scrapModel;//请求的报废申请数据模型
@property(nonatomic,weak)UITextField *contentField;//审批原因
@end

@implementation PurchasePepairReplaceScrapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ApplyDetailTVCell class] forCellReuseIdentifier:tableCellid];
    self.title = @"申请详情";
    
}
-(void)setModel:(ApproveListModel *)model{
    _model = model;
    [SVProgressHUD show];// 动画开始
    //http://192.168.1.168:8085/mobileapi/buyApply/get.do?id=1
    //    msgStatus：消息状态, 0=审批中，1=已审批
    NSString *listUrlStr = @"";
    switch ([model.msgType intValue]) {
        case 10://采购申请
            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由",@"备注", nil];
            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mbuyApplyDetail,model.referId];
            break;
//        case 30://领用申请
//            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由", nil];
//            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetRecipientsDetail,model.referId];
//            break;
//        case 35://借用申请
//            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由", nil];
//            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetBorrowDetail,model.referId];
//            break;
        case 60://维修申请
            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"故障说明",@"备注", nil];
            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetmaintenanceLogDetail,model.referId];
            break;
        case 50://以旧换新申请
            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"备注说明",@"备注", nil];
            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetOldfornewDetail,model.referId];
            break;
        case 65://报废申请
            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"报废类型",@"报废日期",@"报废理由", nil];
            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetScrapDetail,model.referId];
            break;
            //        case 40:
            //            self.iconView.image = [UIImage imageNamed:@""];
            //            self.typeLabel.text = @"归还申请";
            //            break;
        case 45://退库申请
            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由", nil];
            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetReturnDetail,model.referId];
            break;
            
        default:
            break;
    }
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            switch ([model.msgType intValue]) {
                case 10://采购申请
                {
                    NSDictionary *buyApplyDic = dic[@"buyApply"];
                    BuyApplyDetailModel *buyModel = [BuyApplyDetailModel mj_objectWithKeyValues:buyApplyDic];
                    self.buyModel = buyModel;
                }
                    break;
//                case 30://领用申请
//                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetRecipientsDetail,model.referId];
//                    break;
//                case 35://借用申请
//                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetBorrowDetail,model.referId];
//                    break;
                case 60://维修申请
                {
                    NSDictionary *repairApplyDic = dic[@"maintenanceLog"];
                    RepairApplyDetailModel *repairModel = [RepairApplyDetailModel mj_objectWithKeyValues:repairApplyDic];
                    self.repairModel = repairModel;
                }
                    break;
                case 50://以旧换新申请
                {
                    NSDictionary *replaceApplyDic = dic[@"assetOldfornew"];
                    RepairApplyDetailModel *replaceModel = [RepairApplyDetailModel mj_objectWithKeyValues:replaceApplyDic];
                    self.replaceModel = replaceModel;
                }
                    break;
                case 65://报废申请
                {
                    NSDictionary *scrapApplyDic = dic[@"assetScrap"];
                    ScrapApplyDetailModel *scrapModel = [ScrapApplyDetailModel mj_objectWithKeyValues:scrapApplyDic];
                    self.scrapModel = scrapModel;
                }
                    break;
//                    //        case 40:
//                    //            self.iconView.image = [UIImage imageNamed:@""];
//                    //            self.typeLabel.text = @"归还申请";
//                    //            break;
//                case 45://退库申请
//                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetReturnDetail,model.referId];
//                    break;
                    
                default:
                    break;
            }
            
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
    switch ([self.model.msgType intValue]) {
        case 10://采购申请
        case 60://维修申请
        case 50://以旧换新申请
        case 65://报废申请
            return 1;
            break;
        case 30://领用申请
        case 35://借用申请
        case 45://退库申请
            return 2;
            break;
            
        default:
            break;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.itemTypeArray.count;//
    }else{
        return 2;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        
        cell.itemLabel.text = self.itemTypeArray[indexPath.row];
        switch ([self.model.msgType intValue]) {
            case 10://采购申请
            {
                if ([self.model.msgStatus integerValue] == 0) {//审批中
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
                            cell.contentField.hidden = false;
                            cell.itemContentLabel.text = @"";
                            self.contentField = cell.contentField;
                            break;
                            
                        default:
                            break;
                    }
                }else{//已审批
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
                            cell.contentField.hidden = true;
                            cell.itemContentLabel.text = @"--";
                            break;
                            
                        default:
                            break;
                    }
                    
                }

            }
                break;
            case 60://维修申请
            {
                if ([self.model.msgStatus integerValue] == 0) {//审批中
                    switch (indexPath.row) {
                        case 0:
                            cell.itemContentLabel.text = self.repairModel.departmentName;
                            break;
                        case 1:
                            cell.itemContentLabel.text = self.repairModel.userName;
                            break;
                        case 2:
                            cell.itemContentLabel.text = self.repairModel.assetName;
                            break;
                        case 3:
                            cell.itemContentLabel.text = self.repairModel.comment;
                            break;
                        case 4:
                            cell.contentField.hidden = false;
                            cell.itemContentLabel.text = @"";
                            self.contentField = cell.contentField;
                            break;
                            
                        default:
                            break;
                    }
                }else{//已审批
                    switch (indexPath.row) {
                        case 0:
                            cell.itemContentLabel.text = self.repairModel.departmentName;
                            break;
                        case 1:
                            cell.itemContentLabel.text = self.repairModel.userName;
                            break;
                        case 2:
                            cell.itemContentLabel.text = self.repairModel.assetName;
                            break;
                        case 3:
                            cell.itemContentLabel.text = self.repairModel.comment;
                            break;
                        case 4:
                            cell.contentField.hidden = true;
                            cell.itemContentLabel.text = @"--";
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                
            }
                break;
            case 50://以旧换新申请
            {
                if ([self.model.msgStatus integerValue] == 0) {//审批中
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
                            cell.itemContentLabel.text = self.replaceModel.comment;
                            break;
                        case 4:
                            cell.contentField.hidden = false;
                            cell.itemContentLabel.text = @"";
                            self.contentField = cell.contentField;
                            break;
                            
                        default:
                            break;
                    }
                }else{//已审批
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
                            cell.itemContentLabel.text = self.replaceModel.comment;
                            break;
                        case 4:
                            cell.contentField.hidden = true;
                            cell.itemContentLabel.text = @"--";
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                
            }
                break;
            case 65://报废申请
            {
                if ([self.model.msgStatus integerValue] == 0) {//审批中
                    switch (indexPath.row) {
                        case 0:
                            cell.itemContentLabel.text = self.scrapModel.departmentName;
                            break;
                        case 1:
                            cell.itemContentLabel.text = self.scrapModel.userName;
                            break;
                        case 2:
                            cell.itemContentLabel.text = self.scrapModel.assetsName;
                            break;
                        case 3:{
                            if ([self.scrapModel.scrapModeId integerValue] == 1) {//过期
                                cell.itemContentLabel.text = @"过期";
                            }else if ([self.scrapModel.scrapModeId integerValue] == 2){
                                cell.itemContentLabel.text = @"损坏";
                            }else if ([self.scrapModel.scrapModeId integerValue] == 3){
                                cell.itemContentLabel.text = @"丢失";
                            }else if ([self.scrapModel.scrapModeId integerValue] == 4){
                                cell.itemContentLabel.text = @"捐赠";
                            }
                        }
                            break;
                        case 4:
                            cell.itemContentLabel.text = self.scrapModel.scrapDateString;
                            break;
                        case 5:
                            cell.itemContentLabel.text = self.scrapModel.comment;
                            break;
                        case 6:
                            cell.contentField.hidden = false;
                            cell.itemContentLabel.text = @"";
                            self.contentField = cell.contentField;
                            break;
                            
                        default:
                            break;
                    }
                }else{//已审批
                    switch (indexPath.row) {
                        case 0:
                            cell.itemContentLabel.text = self.scrapModel.departmentName;
                            break;
                        case 1:
                            cell.itemContentLabel.text = self.scrapModel.userName;
                            break;
                        case 2:
                            cell.itemContentLabel.text = self.scrapModel.assetsName;
                            break;
                        case 3:{
                            if ([self.scrapModel.scrapModeId integerValue] == 1) {//过期
                                cell.itemContentLabel.text = @"过期";
                            }else if ([self.scrapModel.scrapModeId integerValue] == 2){
                                cell.itemContentLabel.text = @"损坏";
                            }else if ([self.scrapModel.scrapModeId integerValue] == 3){
                                cell.itemContentLabel.text = @"丢失";
                            }else if ([self.scrapModel.scrapModeId integerValue] == 4){
                                cell.itemContentLabel.text = @"捐赠";
                            }
                        }
                            break;
                        case 4:
                            cell.itemContentLabel.text = self.scrapModel.scrapDateString;
                            break;
                        case 5:
                            cell.itemContentLabel.text = self.scrapModel.comment;
                            break;
                        case 6:
                            cell.contentField.hidden = true;
                            cell.itemContentLabel.text = @"--";
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                
            }
                break;
//            case 30://领用申请
//
//                break;
                //                case 35://借用申请
                //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetBorrowDetail,model.referId];
                //                    break;
                
                //                case 50://以旧换新申请
                //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetOldfornewDetail,model.referId];
                //                    break;
                //                case 65://报废申请
                //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetScrapDetail,model.referId];
                //                    break;
                //                    //        case 40:
                //                    //            self.iconView.image = [UIImage imageNamed:@""];
                //                    //            self.typeLabel.text = @"归还申请";
                //                    //            break;
                //                case 45://退库申请
                //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetReturnDetail,model.referId];
                //                    break;
                
            default:
                break;
        }
        return cell;
    }else{
        ApplyDetailTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        
        cell.itemLabel.text = self.itemTypeArray[indexPath.row];
        
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 180)];
    view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];

    if ([self.model.msgStatus integerValue] == 0) {//审批中
        //同意btn
        UIButton *agreeBtn = [[UIButton alloc]init];
        [agreeBtn setBackgroundColor:[UIColor colorWithHexString:@"23b880"]];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [agreeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        agreeBtn.layer.masksToBounds = YES;
        agreeBtn.layer.cornerRadius = 5;
        [view addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.equalTo(view.mas_centerX).offset(-22);
            make.width.offset(100);
            make.height.offset(40);
        }];
        //驳回btn
        UIButton *rejectBtn = [[UIButton alloc]init];
        [rejectBtn setBackgroundColor:[UIColor colorWithHexString:@"dc8268"]];
        [rejectBtn setTitle:@"驳回" forState:UIControlStateNormal];
        rejectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rejectBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        rejectBtn.layer.masksToBounds = YES;
        rejectBtn.layer.cornerRadius = 5;
        [view addSubview:rejectBtn];
        [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.equalTo(view.mas_centerX).offset(22);
            make.width.offset(100);
            make.height.offset(40);
        }];
        agreeBtn.tag = 1;
        rejectBtn.tag = 0;
        [agreeBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rejectBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{//已审批
         //驳回、同意、失效lebal
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 2;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.offset(100);
            make.height.offset(40);
        }];
        switch ([self.model.approvalState  integerValue]) {
            case 1:
                label.textColor = [UIColor colorWithHexString:@"23b880"];
                label.text = @"已同意";
                break;
            case 2:
                label.textColor = [UIColor colorWithHexString:@"dc8268"];
                label.text = @"已驳回";
                break;
                
            default:
                break;
        }
       
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 180;
}
#pragma mark - btnClick
-(void)applyBtnClick:(UIButton*)sender{
    int isAdopt;//是否同意
    if (sender.tag) {
        isAdopt = 1;
    }else{
        isAdopt = 0;
    }
    NSString *rejectReason = self.contentField.text;
    //http://192.168.1.168:8085/mobileapi/buyApply/get.do?id=1
    //    msgStatus：消息状态, 0=审批中，1=被驳回，2=已完成，3=已失效  msgType:不传代表请求全部
    NSString *listUrlStr = @"";
    switch ([self.model.msgType intValue]) {
//            http://192.168.1.168:8085/mobileapi/buyApply/doApproval.do?id=2&isAdopt=1&rejectReason=
//            id=对应从待审批列表接口拿到的 refer_id
//            isAdopt=是否同意，1同意，0驳回
//            rejectReason=驳回原因
        case 10://采购申请
            listUrlStr = [NSString stringWithFormat:@"%@id=%@&isAdopt=%d&rejectReason=%@",mPurchaseApprove,self.model.referId,isAdopt,rejectReason];
            break;
            //        case 30://领用申请
            //            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由", nil];
            //            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetRecipientsDetail,model.referId];
            //            break;
            //        case 35://借用申请
            //            self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"物品名称",@"规格型号",@"计量单位",@"预算价格",@"采购数量",@"生产厂家",@"采购类别",@"采购理由", nil];
            //            listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetBorrowDetail,model.referId];
            //            break;
        case 60://维修申请
            listUrlStr = [NSString stringWithFormat:@"%@id=%@&isAdopt=%d&rejectReason=%@",mMaintenanceLogApprove,self.model.referId,isAdopt,rejectReason];
            break;
        case 50://以旧换新申请
            listUrlStr = [NSString stringWithFormat:@"%@id=%@&isAdopt=%d&rejectReason=%@",mReplaceApprove,self.model.referId,isAdopt,rejectReason];
            break;
        case 65://报废申请
            listUrlStr = [NSString stringWithFormat:@"%@id=%@&isAdopt=%d&rejectReason=%@",mAssetScrapApprove,self.model.referId,isAdopt,rejectReason];
            break;
            //        case 40:
            //            self.iconView.image = [UIImage imageNamed:@""];
            //            self.typeLabel.text = @"归还申请";
            //            break;
        case 45://退库申请
            listUrlStr = [NSString stringWithFormat:@"%@id=%@&isAdopt=%d&rejectReason=%@",mReturnStoreApprove,self.model.referId,isAdopt,rejectReason];
            break;
            
        default:
            break;
    }
    listUrlStr = [listUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    [SVProgressHUD show];
    [httpManager requestWithPath:listUrlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
//            switch ([model.msgType intValue]) {
//                case 10://采购申请
//                {
//                    NSDictionary *buyApplyDic = dic[@"buyApply"];
//                    BuyApplyDetailModel *buyModel = [BuyApplyDetailModel mj_objectWithKeyValues:buyApplyDic];
//                    self.buyModel = buyModel;
//                }
//                    break;
//                    //                case 30://领用申请
//                    //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetRecipientsDetail,model.referId];
//                    //                    break;
//                    //                case 35://借用申请
//                    //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetBorrowDetail,model.referId];
//                    //                    break;
//                case 60://维修申请
//                {
//                    NSDictionary *repairApplyDic = dic[@"maintenanceLog"];
//                    RepairApplyDetailModel *repairModel = [RepairApplyDetailModel mj_objectWithKeyValues:repairApplyDic];
//                    self.repairModel = repairModel;
//                }
//                    break;
//                case 50://以旧换新申请
//                {
//                    NSDictionary *replaceApplyDic = dic[@"assetOldfornew"];
//                    RepairApplyDetailModel *replaceModel = [RepairApplyDetailModel mj_objectWithKeyValues:replaceApplyDic];
//                    self.replaceModel = replaceModel;
//                }
//                    break;
//                case 65://报废申请
//                {
//                    NSDictionary *scrapApplyDic = dic[@"assetScrap"];
//                    ScrapApplyDetailModel *scrapModel = [ScrapApplyDetailModel mj_objectWithKeyValues:scrapApplyDic];
//                    self.scrapModel = scrapModel;
//                }
//                    break;
//                    //                    //        case 40:
//                    //                    //            self.iconView.image = [UIImage imageNamed:@""];
//                    //                    //            self.typeLabel.text = @"归还申请";
//                    //                    //            break;
//                    //                case 45://退库申请
//                    //                    listUrlStr = [NSString stringWithFormat:@"%@id=%@",mAssetReturnDetail,model.referId];
//                    //                    break;
//
//                default:
//                    break;
//            }
//
//            [self.tableView reloadData];
            
        }else if ([dic[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        return ;
    }];
    
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
