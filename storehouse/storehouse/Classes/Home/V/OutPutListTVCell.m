//
//  OutPutListTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/12/25.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "OutPutListTVCell.h"
#import "UILabel+Addition.h"

@interface OutPutListTVCell()
@property(nonatomic,weak)UILabel *departmentLabel;
//@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *assetNameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *stateLabel;
@property(nonatomic,weak)UIImageView *iconView;
@end
@implementation OutPutListTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self setupUI];
    }
    return self;
}
//验收
-(void)setCheckModel:(BuyApplyDetailModel *)checkModel{
    _checkModel = checkModel;
    self.departmentLabel.text = [NSString stringWithFormat:@"%@  %@",checkModel.departmentName,checkModel.applyUserName];
    [self.assetNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.departmentLabel);
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(9);
    }];
    self.assetNameLabel.text = checkModel.assetName;
    self.timeLabel.text = checkModel.applyTimeString;
//    根据 acceptanceOpinion 判断状态，0=待验收，1=已验收，2=已退货
    switch ([checkModel.acceptanceOpinion intValue]) {
        case 0:
            self.stateLabel.text = @"待验收";
            self.stateLabel.textColor = [UIColor colorWithHexString:@"dc8268"];
            break;
        case 1:
            self.stateLabel.text = @"已验收";
            self.stateLabel.textColor = [UIColor colorWithHexString:@"23b880"];
            break;
        case 2:
            self.stateLabel.text = @"已退货";
            self.stateLabel.textColor = [UIColor darkGrayColor];
            break;
            
        default:
            break;
    }
}
//领用
-(void)setGetModel:(GetApplyDetailModel *)getModel{
    _getModel = getModel;
    self.departmentLabel.text = [NSString stringWithFormat:@"%@  %@",getModel.departmentName,getModel.userName];
    [self.assetNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.departmentLabel);
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(9);
        make.height.offset(0);
    }];
    self.timeLabel.text = getModel.gmtCreateString;
    //    根据 outboundDate 领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
    if (getModel.outboundDateString.length > 0) {
        self.stateLabel.text = @"已领用";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"23b880"];
    }else{
        self.stateLabel.text = @"未领用";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"dc8268"];
    }
    
}
//借用
-(void)setBorrowModel:(borrowApplyDetailModel *)borrowModel{
    _borrowModel = borrowModel;
    self.departmentLabel.text = [NSString stringWithFormat:@"%@  %@",borrowModel.departmentName,borrowModel.userName];
    [self.assetNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.departmentLabel);
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(9);
        make.height.offset(0);
    }];
    self.timeLabel.text = borrowModel.gmtCreateString;
    //    状态：outboundDate 实际借出日期 来判断状态，为空=未出库，不为空=已出库；inboundDate 实际入库/归还日期 来判断状态，为空=未归还，不为空=已归还
    if (borrowModel.inboundDateString.length > 0) {
        self.stateLabel.text = @"已归还";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"23b880"];
    }else if (borrowModel.outboundDateString.length > 0) {
        self.stateLabel.text = @"已出库";
        self.stateLabel.textColor = [UIColor orangeColor];
    }else if (borrowModel.outboundDateString.length == 0) {
        self.stateLabel.text = @"未出库";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"dc8268"];
    }
}
//以旧换新
-(void)setReplaceModel:(ReplaceApplyDetailModel *)replaceModel{
    _replaceModel = replaceModel;
    self.departmentLabel.text = [NSString stringWithFormat:@"%@  %@",replaceModel.departmentName,replaceModel.userName];
    [self.assetNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.departmentLabel);
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(9);
    }];
    self.assetNameLabel.text = replaceModel.assetName;
    self.timeLabel.text = replaceModel.gmtCreateString;
    //    根据 outboundDate 领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
    if (replaceModel.outboundDateString.length > 0) {
        self.stateLabel.text = @"已更换";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"23b880"];
    }else{
        self.stateLabel.text = @"未更换";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"dc8268"];
    }
    
}
//退库
-(void)setBackModel:(GetApplyDetailModel *)backModel{
    _backModel = backModel;
    self.departmentLabel.text = [NSString stringWithFormat:@"%@  %@",backModel.departmentName,backModel.userName];
    [self.assetNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.departmentLabel);
        make.top.equalTo(self.departmentLabel.mas_bottom).offset(9);
        make.height.offset(0);
    }];
    self.timeLabel.text = backModel.gmtCreateString;
    //    根据 outboundDate 领用日期来判断是否已经领用，日期为空=未出库，不为空=已出库
    if (backModel.inboundDateString.length > 0) {
        self.stateLabel.text = @"已退库";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"23b880"];
    }else{
        self.stateLabel.text = @"未退库";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"dc8268"];
    }
    
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    //背景view
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);make.bottom.offset(-7);
    }];
    //iconview
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"people_image"]];
    [backView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.size.offset(50);
    }];
    self.iconView = iconView;
    //审批人/部门label
    UILabel *departmentLabel = [UILabel labelWithText:@"部门 姓名" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [backView addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(22);
        make.left.equalTo(iconView.mas_right).offset(10);
    }];
    self.departmentLabel = departmentLabel;
    //    //姓名label
    //    UILabel *nameLabel = [UILabel labelWithText:@"张三" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    //    [backView addSubview:nameLabel];
    //    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(departmentLabel);
    //        make.left.equalTo(departmentLabel.mas_right).offset(20);
    //    }];
    //    self.nameLabel = nameLabel;
    //采购物品名称label
    UILabel *assetNameLabel = [UILabel labelWithText:@"领用申请" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [backView addSubview:assetNameLabel];
    [assetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(departmentLabel);
        make.top.equalTo(departmentLabel.mas_bottom).offset(9);
    }];
    self.assetNameLabel = assetNameLabel;
    //时间label
    UILabel *timeLabel = [UILabel labelWithText:@"2018年7月2日" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:9];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(departmentLabel);
        make.top.equalTo(assetNameLabel.mas_bottom).offset(9);
    }];
    self.timeLabel = timeLabel;
    //状态label
    UILabel *stateLabel = [UILabel labelWithText:@"审批状态" andTextColor:[UIColor colorWithHexString:@"dc8268"] andFontSize:14];
    [backView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-15);
    }];
    self.stateLabel = stateLabel;
}
//msgType:消息类型,
//0=SYSTEM=系统消息，
//5=MESSAGE=私信，
//10=BUY=采购申请，
//15=CHECK=验收，
//20=INPUT=入库，
//25=OUTPUT=出库，
//30=RECIPIENT=领用，
//35=BORROW=借用，
//40=REVERT=归还，
//45=RETURN=退库，
//50=OLDFORNEW=以旧换新，
//55=DAMAGED=报损，
//60=MAINTAIN=维修，
//65=SCRAP=报废，
//70=INVENTORY=盘点，
//75=TRANSFER=转移

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

