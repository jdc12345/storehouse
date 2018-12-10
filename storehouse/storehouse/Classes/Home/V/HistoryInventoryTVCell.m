//
//  HistoryInventoryTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/12/10.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "HistoryInventoryTVCell.h"
#import "UILabel+Addition.h"

@interface HistoryInventoryTVCell()
@property(nonatomic,weak)UILabel *departmentLabel;
//@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *typeLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *stateLabel;
@property(nonatomic,weak)UIImageView *iconView;
@end
@implementation HistoryInventoryTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self setupUI];
    }
    return self;
}
-(void)setModel:(HistoryInventoryListModel *)model{
    _model = model;
    
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
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_select"]];
    [backView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
        make.size.offset(50);
    }];
    self.iconView = iconView;
    //审批人/部门label
    UILabel *departmentLabel = [UILabel labelWithText:@"待审批人：" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
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
    //类型label
    UILabel *typeLabel = [UILabel labelWithText:@"领用申请" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [backView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(departmentLabel);
        make.top.equalTo(departmentLabel.mas_bottom).offset(9);
    }];
    self.typeLabel = typeLabel;
    //时间label
    UILabel *timeLabel = [UILabel labelWithText:@"2018年7月2日" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:9];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(departmentLabel);
        make.top.equalTo(typeLabel.mas_bottom).offset(9);
    }];
    self.timeLabel = timeLabel;
    //状态label
    UILabel *stateLabel = [UILabel labelWithText:@"审批状态" andTextColor:[UIColor colorWithHexString:@"dc8268"] andFontSize:9];
    [backView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-15);
    }];
    self.stateLabel = stateLabel;
}
////msgType:消息类型,
////0=SYSTEM=系统消息，
////5=MESSAGE=私信，
////10=BUY=采购申请，
////15=CHECK=验收，
////20=INPUT=入库，
////25=OUTPUT=出库，
////30=RECIPIENT=领用，
////35=BORROW=借用，
////40=REVERT=归还，
////45=RETURN=退库，
////50=OLDFORNEW=以旧换新，
////55=DAMAGED=报损，
////60=MAINTAIN=维修，
////65=SCRAP=报废，
////70=INVENTORY=盘点，
////75=TRANSFER=转移
//- (void)setModel:(LaunchListModel *)model processStatus:(NSInteger)processStatus
//{
//    _model = model;
//    _processStatus = processStatus;
//    //    self.iconView.image = [UIImage imageNamed:model.avatar];
//    switch (processStatus) {
//        case 0:
//            self.departmentLabel.text = [NSString stringWithFormat:@"待审批人:%@",model.approvalTrueName];
//            break;
//        case 1:
//            self.departmentLabel.text = [NSString stringWithFormat:@"驳回人:%@",model.approvalTrueName];
//            break;
//        case 2:
//            self.departmentLabel.text = [NSString stringWithFormat:@"审批人:%@",model.approvalTrueName];
//            break;
//        case 3:
//            self.departmentLabel.text = [NSString stringWithFormat:@"待审批人:%@",model.approvalTrueName];
//            break;
//            
//        default:
//            break;
//    }
//    //    self.nameLabel.text = model.trueName;
//    switch ([model.msgType intValue]) {
//        case 10:
//            self.iconView.image = [UIImage imageNamed:@"采购申请_类型图标"];
//            self.typeLabel.text = @"采购申请";
//            break;
//        case 30:
//            self.iconView.image = [UIImage imageNamed:@"领用申请_类型图标"];
//            self.typeLabel.text = @"领用申请";
//            break;
//        case 35:
//            self.iconView.image = [UIImage imageNamed:@"借用申请_类型图标"];
//            self.typeLabel.text = @"借用申请";
//            break;
//        case 60:
//            self.iconView.image = [UIImage imageNamed:@"维修申请_类型图标"];
//            self.typeLabel.text = @"维修申请";
//            break;
//        case 50:
//            self.iconView.image = [UIImage imageNamed:@"以旧换新申请_类型图标"];
//            self.typeLabel.text = @"以旧换新申请";
//            break;
//        case 65:
//            self.iconView.image = [UIImage imageNamed:@"报废申请_类型图标"];
//            self.typeLabel.text = @"报废申请";
//            break;
//            //        case 40:
//            //            self.iconView.image = [UIImage imageNamed:@""];
//            //            self.typeLabel.text = @"归还申请";
//            //            break;
//        case 45:
//            self.iconView.image = [UIImage imageNamed:@"退库申请_类型图标"];
//            self.typeLabel.text = @"退库申请";
//            break;
//            
//        default:
//            break;
//    }
//    self.timeLabel.text = model.createTimeString;
//    switch (processStatus) {//申请状态：0审批中，1被驳回，2已完成，3已失效
//        case 0:
//            self.stateLabel.text = @"审批中";
//            break;
//        case 1:
//            self.stateLabel.text = @"被驳回";
//            break;
//        case 2:
//            self.stateLabel.text = @"已完成";
//            break;
//        case 3:
//            self.stateLabel.text = @"已失效";
//            break;
//            
//        default:
//            break;
//    }
//    //    self.imageIcon.image = [CPXLaunchTypeModel cellIconImageWithModelWithType:model.typeModel.type];
//    //    self.timeLabel.text = model.updatedAt;
//    //    self.typeLabel.text = model.typeModel.typeName;
//    //    self.expenseSnLabel.text = [NSString stringWithFormat:@"审批单号: %@", model.expenseSn];
//    //    [self setMoneyLabelHiddenWithType:model.typeModel.type];
//    //    [self setReasonLabelHiddenType:model.typeModel.type];
//    //    [self setNextNameLabelHiddenWithType:model.typeModel.type];
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

