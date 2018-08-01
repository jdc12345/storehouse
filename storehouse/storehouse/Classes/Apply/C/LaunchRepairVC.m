//
//  LaunchRepairVC.m
//  storehouse
//
//  Created by 万宇 on 2018/8/1.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LaunchRepairVC.h"
#import "LaunchBaseTVCell.h"
#import "ZWPullMenuView.h"

static NSString* tableCellid = @"table_cell";
@interface LaunchRepairVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称

@end

@implementation LaunchRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:nil action:nil];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"申请部门",@"申请人",@"物品名称",@"所在位置",@"备注说明", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.scrollEnabled = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LaunchBaseTVCell class] forCellReuseIdentifier:tableCellid];
    if (_applyType == 3) {
        self.title = @"维修申请";
    }else{
        self.title = @"以旧换新申请";
    }
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemTypeArray.count;//
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LaunchBaseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.listButton.hidden = false;
        cell.listButton.tag = 100+indexPath.row;
        [cell.listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentField.tag = 50+indexPath.row;
    }
    cell.contentField.delegate = self;
    cell.itemLabel.text = self.itemTypeArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
