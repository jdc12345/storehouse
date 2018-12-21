//
//  approveListTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/9/11.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "approveListTVCell.h"
#import "UILabel+Addition.h"

@interface approveListTVCell()
@property(nonatomic,weak)UILabel *approveConentLabel;

@property(nonatomic,weak)UILabel *stateLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@end
@implementation approveListTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self setupUI];
    }
    return self;
}
-(void)setModel:(ApproveListModel *)model{
    _model = model;
    self.approveConentLabel.text = [NSString stringWithFormat:@"%@发起的%@",model.trueName,model.title];
    if (model.createTimeString.length > 10) {
        self.timeLabel.text = [model.createTimeString substringToIndex:10];
    }else{
        
        self.timeLabel.text = model.createTimeString;
    }
//    msgStatus：消息状态, 0=审批中，1=已审批
    if ([model.msgStatus isEqualToString:@"0"]) {
        self.stateLabel.text = @"待审批";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"dc8268"];
    }else if ([model.msgStatus isEqualToString:@"1"]){
        self.stateLabel.text = @"已审批";
        self.stateLabel.textColor = [UIColor colorWithHexString:@"23b880"];
    }
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    //背景view
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);make.bottom.offset(-5);
    }];
    //审批内容label
    UILabel *approveConentLabel = [UILabel labelWithText:@"待审批人：" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [backView addSubview:approveConentLabel];
    [approveConentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    self.approveConentLabel = approveConentLabel;
    //时间label
    UILabel *timeLabel = [UILabel labelWithText:@"申请时间" andTextColor:[UIColor colorWithHexString:@"dc8268"] andFontSize:15];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(approveConentLabel.mas_right).offset(45);
    }];
    self.timeLabel = timeLabel;
    //状态label
    UILabel *stateLabel = [UILabel labelWithText:@"审批状态" andTextColor:[UIColor colorWithHexString:@"dc8268"] andFontSize:15];
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
