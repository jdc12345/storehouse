//
//  InventoryAssetsFormTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/12/11.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "InventoryAssetsFormTVCell.h"
#import "UILabel+Addition.h"
@interface InventoryAssetsFormTVCell()
@property(nonatomic,weak)UILabel *willLabel;//待盘数量label
@property(nonatomic,weak)UILabel *hadLabel;//已盘数量label
@property(nonatomic,weak)UILabel *assetLabel;//资产名称label
@property(nonatomic,weak)UILabel *saverLabel;//保管人label
@property(nonatomic,weak)UILabel *addressLabel;//应存放地label
@end
@implementation InventoryAssetsFormTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //ui
        [self setupUI];
    }
    return self;
}
-(void)setInventoryAssetModel:(InventoryAssetModel *)inventoryAssetModel{
    _inventoryAssetModel = inventoryAssetModel;
    self.willLabel.text = inventoryAssetModel.num;
    self.hadLabel.text = inventoryAssetModel.inventoryNum;
    self.assetLabel.text = inventoryAssetModel.assetsName;
    self.saverLabel.text = inventoryAssetModel.saveUserName;
    self.addressLabel.text = inventoryAssetModel.orgAddressName;
    if ([inventoryAssetModel.inventoryNum intValue] >= [inventoryAssetModel.num intValue]) {//已盘完，没问题
        self.contentView.backgroundColor = [UIColor greenColor];
    }else if ([inventoryAssetModel.inventoryNum intValue] > 0 && [inventoryAssetModel.inventoryNum intValue] < [inventoryAssetModel.num intValue]){//正在盘或者已盘完有问题
        self.contentView.backgroundColor = [UIColor orangeColor];
    }else{//未盘
        self.contentView.backgroundColor = [UIColor redColor];
    }
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    self.contentView.backgroundColor = [UIColor redColor];
    //待盘数量label
    UILabel *willLabel = [UILabel labelWithText:@"待盘数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    willLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:willLabel];
    [willLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.width.offset(70);
        make.height.offset(35);
    }];
    self.willLabel = willLabel;
    //已盘数量label
    UILabel *hadLabel = [UILabel labelWithText:@"待盘数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    hadLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:hadLabel];
    [hadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(willLabel.mas_right);
        make.width.offset(70);
        make.height.offset(35);
    }];
    self.hadLabel = hadLabel;
    //assetLabel资产名称label
    UILabel *assetLabel = [UILabel labelWithText:@"资产名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    assetLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:assetLabel];
    [assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(hadLabel.mas_right);
        make.width.offset(70);
        make.height.offset(35);
    }];
    self.assetLabel = assetLabel;
    //保管人label
    UILabel *saverLabel = [UILabel labelWithText:@"保管人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    saverLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:saverLabel];
    [saverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(assetLabel.mas_right);
        make.width.offset(70);
        make.height.offset(35);
    }];
    self.saverLabel = saverLabel;
    //存放地label
    UILabel *addressLabel = [UILabel labelWithText:@"存放地" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(willLabel);
        make.left.equalTo(saverLabel.mas_right);
        make.width.offset(kScreenW-280);
        make.height.offset(35);
    }];
    self.addressLabel = addressLabel;
    [self.contentView layoutIfNeeded];
    [self setBorderWithView:willLabel top:false left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:hadLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:assetLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:saverLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:addressLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
}
////选中按钮点击事件
//- (void)selBtnClick:(UIButton*)sender
//{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        self.selView.backgroundColor = [UIColor colorWithHexString:@"373a41"];
//    }else{
//        self.selView.backgroundColor = [UIColor whiteColor];
//    }
//    if (self.storeThingModel) {//库房物品列表
//        self.ifSelectedBlock(self.storeThingModel, sender.selected);//不论是否选中都传递
//    }
//    //    if (self.selectedThingsModel) {//已选中准备领用库房物品列表
//    //        self.ifSelectedBlock(self.selectedThingsModel, sender.selected);//不论是否选中都传递
//    //    }
//
//}
//给view添加不同位置的边框
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

