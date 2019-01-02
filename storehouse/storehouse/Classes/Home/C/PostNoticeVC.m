//
//  PostNoticeVC.m
//  storehouse
//
//  Created by 万宇 on 2018/11/20.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "PostNoticeVC.h"
#import "ZWPullMenuView.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "NSString+URL.h"
#import "PostNoticeTVCell.h"

static NSString* tableCellid = @"table_cell";
@interface PostNoticeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *itemTypeArray;//事项名称
@property(nonatomic,weak)UITableView *tableView;

@end

@implementation PostNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布通知";
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(addLaunchBtnClick:)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.itemTypeArray = [NSArray arrayWithObjects:@"通知标题",@"通知内容", nil];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        //添加tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        _tableView = tableView;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.left.right.bottom.offset(0);
        }];
        self.tableView.scrollEnabled = false;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[PostNoticeTVCell class] forCellReuseIdentifier:tableCellid];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
//采购申请提交网络请求
- (void)addLaunchBtnClick:(UIBarButtonItem*)sender{
    PostNoticeTVCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell1.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写通知标题"];
        return;
    }
    PostNoticeTVCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell2.contentField.text.length==0) {
        [SVProgressHUD showInfoWithStatus:@"请填写通知内容"];
        return;
    }

    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = [NSString stringWithFormat:@"%@&msgType =0&title=%@&content=%@",mPostNotice,cell1.contentField.text,cell2.contentField.text];
    [SVProgressHUD show];
    //把中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //        NSLog(@"提交成功%@",responseObject);
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求出错"];
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
    PostNoticeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    if (indexPath.row == 0) {
//        cell.contentField.placeholder = @"通知标题";
    }else{
       cell.contentField.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    }
//    cell.contentField.delegate = self;
    cell.itemLabel.text = self.itemTypeArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 35;
    }else{
        return 250;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

////设置列表行为不可编辑
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    //    if (textField.tag == 50 || textField.tag == 53 || textField.tag == 57) {
//    //        return false;
//    //    }
//    return true;
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    return [textField resignFirstResponder];
//}
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

