//
//  ModifyPasswordVC.m
//  storehouse
//
//  Created by 万宇 on 2018/12/23.
//  Copyright © 2018 wanyu. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "UILabel+Addition.h"
#import "HttpClient.h"
#import "CcUserModel.h"
#import <MJExtension.h>
#import "YYTabBarController.h"
#import "permissionTypeModel.h"

@interface ModifyPasswordVC ()<UITextFieldDelegate>
@property(nonatomic,weak)UITextField *oldNumberField;
@property(nonatomic,weak)UITextField *firstField;

@property(nonatomic,weak)UITextField *secondField;

@end

@implementation ModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self setupUI];
}
-(void)setupUI{
    //添加旧密码textField
    UITextField *oldNumberField = [[UITextField alloc]init];
    oldNumberField.font = [UIFont systemFontOfSize:12];
    oldNumberField.textColor = [UIColor darkTextColor];
    oldNumberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    oldNumberField.layer.cornerRadius = 4;
    oldNumberField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    oldNumberField.layer.borderWidth = 1;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView *telImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_modify"]];
    [leftView addSubview:telImageView];
    [telImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(telImageView.bounds.size.width);
        make.height.offset(telImageView.bounds.size.height);
    }];
    oldNumberField.leftView = leftView;
    oldNumberField.leftViewMode = UITextFieldViewModeAlways;
    oldNumberField.placeholder = @"请输入旧密码";
    [oldNumberField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [oldNumberField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:oldNumberField];
    [oldNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(44+150);
        make.centerX.offset(0);
        make.width.offset(250);
        make.height.offset(44);
    }];
    self.oldNumberField = oldNumberField;
    oldNumberField.delegate = self;
    //添加电话textField
    UITextField *telNumberField = [[UITextField alloc]init];
    telNumberField.font = [UIFont systemFontOfSize:12];
    telNumberField.textColor = [UIColor darkTextColor];
    telNumberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    telNumberField.layer.cornerRadius = 4;
    telNumberField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    telNumberField.layer.borderWidth = 1;
    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    leftView1.backgroundColor = [UIColor clearColor];
    UIImageView *telImageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_modify"]];
    [leftView1 addSubview:telImageView1];
    [telImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(telImageView1.bounds.size.width);
        make.height.offset(telImageView1.bounds.size.height);
    }];
    telNumberField.leftView = leftView1;
    telNumberField.leftViewMode = UITextFieldViewModeAlways;
    telNumberField.placeholder = @"请输入新密码";
    [telNumberField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [telNumberField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:telNumberField];
    [telNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldNumberField.mas_bottom).offset(44);
        make.centerX.offset(0);
        make.width.offset(250);
        make.height.offset(44);
    }];
    self.firstField = telNumberField;
    telNumberField.delegate = self;
    
    //添加密码textField
    UITextField *passWordField = [[UITextField alloc]init];
    passWordField.font = [UIFont systemFontOfSize:14];
    passWordField.textColor = [UIColor darkTextColor];
    passWordField.layer.cornerRadius = 4;
    passWordField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    passWordField.layer.borderWidth = 1;
    UIView *pLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    pLeftView.backgroundColor = [UIColor clearColor];
    UIImageView *passImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_modify"]];
    [pLeftView addSubview:passImageView];
    [passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(passImageView.bounds.size.width);
        make.height.offset(passImageView.bounds.size.height);
    }];
    passWordField.leftView = pLeftView;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    passWordField.placeholder = @"请再次输入密码";
    [passWordField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [passWordField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    telNumberField.font = [UIFont systemFontOfSize:12];
    passWordField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    [self.view addSubview:passWordField];
    [passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telNumberField.mas_bottom).offset(44);
        make.centerX.offset(0);
        make.width.offset(250);
        make.height.offset(44);
    }];
    self.secondField = passWordField;
    //添加确定Btn
    UIButton *logInBtn = [[UIButton alloc]init];
    logInBtn.layer.masksToBounds = true;
    logInBtn.layer.cornerRadius = 20;
    [logInBtn setTitle:@"确定" forState:UIControlStateNormal];
    [logInBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    logInBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [logInBtn setBackgroundColor:[UIColor colorWithHexString:@"dc8268"]];
    [self.view addSubview:logInBtn];
    [logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-49);
        make.width.offset(250);
        make.height.offset(40);
    }];
    //点击事件
    [logInBtn addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    //将手势添加至需要相应的view中
    [self.view addGestureRecognizer:tapGesture];
}
//执行手势触发的方法：
- (void)event:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//取消键盘
    
}
-(void)logIn:(UIButton*)sender{
    if (self.oldNumberField.text.length <1) {
        [self showAlertWithMessage:@"请输入旧密码并进行确认"];
        return;
    }
    if ([self.firstField.text isEqualToString:@"13014591689"]) {
        //        CcUserModel *userModel = [CcUserModel defaultClient];
        //        userModel.userToken = @"0E42DEF6581D286271F2BDB95014315B";
        //        userModel.telephoneNum = @"18511694068";
        //        [userModel saveAllInfo];
        //        //跳转登录首页
        //        YYTabBarController *tabBarVC = [[YYTabBarController alloc]init];
        //        [SVProgressHUD dismiss];// 动画结束
        //        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
        
    }else{
        if (self.firstField.text.length <1 || ![self.firstField.text isEqualToString:self.secondField.text]) {
            [self showAlertWithMessage:@"请输入新密码并进行确认"];
            return;
        }
//    http://192.168.1.168:8085/mobileapi/user/modPwd.do?password=oldpwd&password2=newpwd
//        password  必须，旧密码
//        password2 必须，新密码
        CcUserModel *defaultModel = [CcUserModel defaultClient];
        HttpClient *httpManager = [HttpClient defaultClient];
        [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
        NSString *urlString = [NSString stringWithFormat:@"%@password=%@&password2=%@",mModifyRequest,self.oldNumberField.text,self.firstField.text];
        //把中文转义
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [SVProgressHUD show];
        [httpManager requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                NSDictionary *userDic = dic[@"User"];
                CcUserModel *userModel = [CcUserModel mj_objectWithKeyValues:userDic];
                //                NSArray *permissionModelArr = userModel.permission;
                //                NSMutableArray *tempArr = [NSMutableArray array];
                //                for (NSDictionary *typeDic in permissionModelArr) {
                //                    permissionTypeModel *typeModel = [permissionTypeModel mj_objectWithKeyValues:typeDic];
                //                    [tempArr addObject:typeModel];
                //
                //                }
                //                defaultModel.permission = tempArr.copy;
                [defaultModel mj_setKeyValues:userModel];
                //获取cookie
                NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
                NSDictionary *fields = [response allHeaderFields]; //afnetworking写法
                //                NSLog(@"------->%@",fields[@"Set-cookie"]);
                NSString *userCookie = fields[@"Set-cookie"];//获取当前cookie
                defaultModel.userCookie = userCookie;
                //保存用户信息
                [defaultModel saveAllInfo];
                [self.navigationController popViewControllerAnimated:true];
                //跳转登录首页
//                YYTabBarController *firstVC = [[YYTabBarController alloc]init];
//                [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;
                
            }else{
                [SVProgressHUD showInfoWithStatus:dic[@"message"]];
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            return ;
        }];
    }
    
}

#pragma UItextdelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//
//{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//    {
//        return YES;
//    }
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    if ([toBeString length] < 6) { //如果输入框内容小于6则弹出警告
//        //            textField.text = [textField.text substringToIndex:11];
//        [self showAlertWithMessage:@"您输入的密码少于6位"];
//
//        return NO;
//    }
//    return YES;
//
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (self.firstField == textField)  //判断是否是我们想要限定的那个输入框
//    {
//
//        if ([textField.text length] < 6){
//            [self showAlertWithMessage:@"您输入的密码少于6位"];
//
//        }
//    }
//}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    NSString * toBeString = textField.text; //得到输入框的内容
//    if ([textField.text length] == 11){
//        if (![self valiMobile:toBeString]) {
//            [self showAlertWithMessage:@"请输入正确的11位电话号码"];
//            return false;
//        }
//    }
//    return true;
//
//}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.oldNumberField becomeFirstResponder];
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
