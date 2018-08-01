//
//  LaunchGetUseVC.m
//  storehouse
//
//  Created by 万宇 on 2018/7/30.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchGetUseVC.h"
#import "LaunchBaseTVCell.h"
#import "ZWPullMenuView.h"
#import "UILabel+Addition.h"
#import "LaunchFormTVCell.h"

static NSString* tableCellid = @"table_cell";
static NSString* listCell = @"listCell";

@interface LaunchGetUseVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@end

@implementation LaunchGetUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:nil action:nil];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"备注说明", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    [self.tableView registerClass:[LaunchFormTVCell class] forCellReuseIdentifier:listCell];
    if (_applyType == 1) {
        self.title = @"领用申请";
    }else if (_applyType == 2){
        self.title = @"借用申请";
    }else{
        self.title = @"归还申请";
    }
}
//- (void)setApplyType:(NSInteger)applyType{
//    _applyType = applyType;
//    if (_applyType == 1) {
//        self.title = @"领用申请";
//        self.itemLabel.text = @"领用明细";
//    }else{
//        self.title = @"借用申请";
//        self.itemLabel.text = @"借用明细";
//    }
//}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.itemTypeArray.count;
    }
    return 2;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LaunchBaseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.listButton.hidden = false;
            cell.listButton.tag = 100;
            [cell.listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.contentField.tag = 50;
        }
        cell.contentField.delegate = self;
        cell.itemLabel.text = self.itemTypeArray[indexPath.row];
        
        return cell;
    }else{
        LaunchFormTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 35;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    //横线1
    UIView *wLine1 = [[UIView alloc]init];
    wLine1.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
    [headerView addSubview:wLine1];
    [wLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(1);
    }];
    //事项label
    UILabel *itemLabel = [UILabel labelWithText:@"领用明细" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    [headerView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_top).offset(17.5);
        make.left.offset(15);
        make.width.offset(60);
    }];
    if (self.applyType == 1) {
        itemLabel.text = @"领用明细";
    }else if (self.applyType == 2){
        itemLabel.text = @"借用明细";
    }else{
        itemLabel.text = @"归还明细";
    }
    //删除button
    UIButton *delBtn = [[UIButton alloc]init];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [delBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [headerView addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.width.offset(60);
        make.height.offset(35);
    }];
    //增加button
    UIButton *increaseBtn = [[UIButton alloc]init];
    increaseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [increaseBtn setTitleColor:[UIColor colorWithHexString:@"30a2d4"] forState:UIControlStateNormal];
    [increaseBtn setTitle:@"增加" forState:UIControlStateNormal];
    [headerView addSubview:increaseBtn];
    [increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.offset(60);
        make.height.offset(35);
        make.right.equalTo(delBtn.mas_left);
    }];
    
    //空白格
    UIView *emptyView = [[UIView alloc]init];
    emptyView.backgroundColor = [UIColor whiteColor];
//    emptyView.layer.borderColor = [UIColor colorWithHexString:@"a0a0a0"].CGColor;
//    emptyView.layer.borderWidth = 1;
    [headerView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.width.height.offset(35);
    }];
    //申请部门label
    UILabel *departmentLabel = [UILabel labelWithText:@"申请部门" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    departmentLabel.backgroundColor = [UIColor whiteColor];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:departmentLabel];
    [departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(emptyView.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    //申请人label
    UILabel *ApplicantLabel = [UILabel labelWithText:@"申请人" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    ApplicantLabel.backgroundColor = [UIColor whiteColor];
    ApplicantLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:ApplicantLabel];
    [ApplicantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(departmentLabel.mas_right);
        make.width.offset(100);
        make.height.offset(35);
    }];
    //物品名称label
    UILabel *goodsNameLabel = [UILabel labelWithText:@"物品名称" andTextColor:[UIColor colorWithHexString:@"373a41"] andFontSize:12];
    goodsNameLabel.backgroundColor = [UIColor whiteColor];
    goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(emptyView);
        make.left.equalTo(ApplicantLabel.mas_right);
        make.width.offset(kScreenW-235);
        make.height.offset(35);
    }];
    [headerView layoutIfNeeded];
    [self setBorderWithView:emptyView top:true left:true bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:departmentLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:ApplicantLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];
    [self setBorderWithView:goodsNameLabel top:true left:false bottom:true right:true borderColor:[UIColor colorWithHexString:@"a0a0a0"] borderWidth:1];

    return headerView;
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
//列表按钮点击事件
-(void)listButtonClick:(UIButton*)sender{
    LaunchBaseTVCell *curruntCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(sender.tag-100) inSection:0]];
    if (sender.tag == 100) {
        ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:@[@"软件部",@"财务部",@"行政部",@"人力资源部"]];
        menuView.zwPullMenuStyle = PullMenuLightStyle;
        __weak typeof(menuView) weakMenuView = menuView;
        menuView.blockSelectedMenu = ^(NSInteger menuRow) {
            NSLog(@"action----->%ld",(long)menuRow);//menuRow为点击的行号
            curruntCell.contentField.text = weakMenuView.titleArray[menuRow];
        };
    }
}
//设置列表行为不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 50) {
        return false;
    }
    return true;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
