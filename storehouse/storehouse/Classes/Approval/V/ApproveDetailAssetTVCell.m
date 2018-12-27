//
//  ApproveDetailAssetTVCell.m
//  storehouse
//
//  Created by 万宇 on 2018/12/16.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "ApproveDetailAssetTVCell.h"
#import "UILabel+Addition.h"

@interface ApproveDetailAssetTVCell()
//@property(nonatomic,weak)UILabel *codeNumLabel;//编号
@property(nonatomic,weak)UILabel *assetTypeLabel;//资产类型
@property(nonatomic,weak)UILabel *assetNameLabel;//资产名称
@end
@implementation ApproveDetailAssetTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //ui
        [self setupUI];
    }
    return self;
}

//设置选中的数据到资产列表
-(void)setModel:(ApproveDetailAssetModel *)model{
    _model = model;
    self.contentField.text = model.totalNum?:@"1";
    self.assetTypeLabel.text = model.categoryName;
    self.assetNameLabel.text = model.assetsName;
    self.selView.backgroundColor = [UIColor whiteColor];//去除复用cell后的选中效果
    self.selBtn.selected = false;
    self.selBtn.enabled = false;
    
}
-(void)setOutPutmodel:(ApproveDetailAssetModel *)outPutmodel{
    _outPutmodel = outPutmodel;
    if (self.outboundDateString.length > 0) {//已领用
        self.contentField.text = outPutmodel.num?:@"0";
    }else{//未领用
        self.contentField.text = outPutmodel.totalNum?:@"0";
    }
    self.assetTypeLabel.text = outPutmodel.categoryName;
    self.assetNameLabel.text = outPutmodel.assetsName;
    self.selView.backgroundColor = [UIColor whiteColor];//去除复用cell后的选中效果
    self.selBtn.selected = false;
    self.selBtn.enabled = false;
}
-(void)setBorrowModel:(ApproveDetailAssetModel *)borrowModel{
    _borrowModel = borrowModel;
    if (self.outboundDateString.length > 0) {//已借出
        self.contentField.text = borrowModel.num?:@"0";
    }else{//未领用
        self.contentField.text = borrowModel.totalNum?:@"0";
    }
    self.assetTypeLabel.text = borrowModel.categoryName;
    self.assetNameLabel.text = borrowModel.assetsName;
    self.selView.backgroundColor = [UIColor whiteColor];//去除复用cell后的选中效果
    self.selBtn.selected = false;
    self.selBtn.enabled = false;
}
- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //空白格
    UIButton *emptyBtn = [[UIButton alloc]init];
    emptyBtn.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:emptyBtn];
    [emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.width.offset(35);
    }];
    emptyBtn.selected = false;
    [emptyBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selBtn = emptyBtn;
    //空白格的小方块
    UIView *selView = [[UIView alloc]init];
    [selView setBackgroundColor:[UIColor whiteColor]];
    selView.layer.borderColor = [UIColor colorWithHexString:@"373a41"].CGColor;
    selView.layer.borderWidth = 1;
    [emptyBtn addSubview:selView];
    [selView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.offset(7);
        
    }];
    selView.userInteractionEnabled = false;
    self.selView = selView;
    //内容textfiled
    UITextField *conentField = [[UITextField alloc]init];
    conentField.returnKeyType = UIReturnKeyDone;
    conentField.enabled = false;//暂时
    //设置左边视图的宽度
    
    conentField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 9, 0)];
    conentField.font = [UIFont systemFontOfSize:12];
    conentField.textColor = [UIColor colorWithHexString:@"373a41"];
    conentField.textAlignment = NSTextAlignmentCenter;
    conentField.placeholder = @"请填写资产数量";
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    
    conentField.leftViewMode = UITextFieldViewModeAlways;
    conentField.backgroundColor = [UIColor whiteColor];
    //    conentField.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
    //    conentField.layer.borderWidth = 1;
    [self.contentView addSubview:conentField];
    [conentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(emptyBtn.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    self.contentField = conentField;
    //    //编号label
    //    UILabel *codeNumLabel = [UILabel labelWithText:@"数量" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    //    codeNumLabel.backgroundColor = [UIColor whiteColor];
    //    codeNumLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.contentView addSubview:codeNumLabel];
    //    [codeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(emptyBtn);
    //        make.left.equalTo(emptyBtn.mas_right);
    //        make.width.offset(100);
    //        make.height.offset(35);
    //    }];
    //    self.codeNumLabel = codeNumLabel;
    //assetTypeLabel资产类型
    UILabel *assetTypeLabel = [UILabel labelWithText:@"类别" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    assetTypeLabel.backgroundColor = [UIColor whiteColor];
    assetTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:assetTypeLabel];
    [assetTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(conentField.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    self.assetTypeLabel = assetTypeLabel;
    //assetNameLabel资产名称
    UILabel *assetNameLabel = [UILabel labelWithText:@"名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    assetNameLabel.backgroundColor = [UIColor whiteColor];
    assetNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:assetNameLabel];
    [assetNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyBtn);
        make.left.equalTo(assetTypeLabel.mas_right);
        make.width.offset(kScreenW-235);
        make.height.offset(35);
    }];
    self.assetNameLabel = assetNameLabel;
    [self layoutIfNeeded];
    [self setBorderWithView:emptyBtn top:false left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:conentField top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:assetTypeLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:assetNameLabel top:false left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
}
//选中按钮点击事件
- (void)selBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selView.backgroundColor = [UIColor colorWithHexString:@"373a41"];
    }else{
        self.selView.backgroundColor = [UIColor whiteColor];
    }
    if (self.model) {//库房物品列表
        self.ifSelectedBlock(self.model, sender.selected);//不论是否选中都传递
    }
    //    if (self.selectedThingsModel) {//已选中准备领用库房物品列表
    //        self.ifSelectedBlock(self.selectedThingsModel, sender.selected);//不论是否选中都传递
    //    }
    
}
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

