//
//  LogInVC.m
//  storehouse
//
//  Created by 万宇 on 2018/8/2.
//  Copyright © 2018年 wanyu. All rights reserved.
//

#import "LogInVC.h"
#import "UILabel+Addition.h"
#import "HttpClient.h"
#import "CcUserModel.h"
#import <MJExtension.h>
#import "YYTabBarController.h"
#import "permissionTypeModel.h"

@interface LogInVC ()<UITextFieldDelegate>
@property(nonatomic,weak)UITextField *telNumberField;

@property(nonatomic,weak)UITextField *passWordField;
@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackGroundColorWithImage:[UIImage imageNamed:@"logIn_back"]];
    [self setupUI];
}
//把控制器背景设为图片
- (void)setBackGroundColorWithImage:(UIImage *)image
{
    UIImage *oldImage = image;
    
    UIGraphicsBeginImageContextWithOptions((CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)), NO, 0.0);
    [oldImage drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}
-(void)setupUI{
    //添加log图片
    UIImageView *logImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"telNum_login_leftView"]];
    [self.view addSubview:logImageView];
    [logImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(73);
        make.width.height.offset(75);
    }];
    logImageView.layer.cornerRadius = 37.5;
    logImageView.layer.masksToBounds = true;
//    //添加输入区域背景
//    UIView *inputView = [[UIView alloc]init];
//    inputView.backgroundColor = [UIColor whiteColor];
//    inputView.alpha = 0.9;
//    inputView.layer.masksToBounds = true;
//    inputView.layer.cornerRadius = 8;
//    [self.view addSubview:inputView];
//    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(logImageView.mas_bottom).offset(30*kiphone6);
//        make.width.offset(325*kiphone6);
//        make.height.offset(150*kiphone6);
//    }];
//    //添加电话label
//    UILabel *telNumLabel = [UILabel labelWithText:@"手机号" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
//    [inputView addSubview:telNumLabel];
//    [telNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15*kiphone6);
//        make.centerY.equalTo(inputView.mas_top).offset(25*kiphone6);
//    }];
    
    //添加电话textField
    UITextField *telNumberField = [[UITextField alloc]init];
    telNumberField.font = [UIFont systemFontOfSize:12];
    telNumberField.textColor = [UIColor colorWithHexString:@"ffffff"];
    telNumberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    telNumberField.layer.cornerRadius = 4;
    telNumberField.layer.borderColor = [UIColor colorWithHexString:@"d1dbe7"].CGColor;
    telNumberField.layer.borderWidth = 1;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView *telImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"telNum_login_leftView"]];
    [leftView addSubview:telImageView];
    [telImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(telImageView.bounds.size.width);
        make.height.offset(telImageView.bounds.size.height);
    }];
    telNumberField.leftView = leftView;
    telNumberField.leftViewMode = UITextFieldViewModeAlways;
    telNumberField.placeholder = @"请输入用户名";
    [telNumberField setValue:[UIColor colorWithHexString:@"ffffff"] forKeyPath:@"_placeholderLabel.textColor"];
    [telNumberField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:telNumberField];
    [telNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logImageView.mas_bottom).offset(44);
        make.centerX.equalTo(logImageView);
        make.width.offset(250);
        make.height.offset(44);
    }];
    self.telNumberField = telNumberField;
    telNumberField.delegate = self;
    
//    //添加图片验证码label
//    UILabel *imageCodeLabel = [UILabel labelWithText:@"随机码" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
//    [inputView addSubview:imageCodeLabel];
//    [imageCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15*kiphone6);
//        make.centerY.equalTo(line1.mas_bottom).offset(24*kiphone6);
//    }];
    
//    //添加图片验证码textField
//    UITextField *imageCodeField = [[UITextField alloc]init];
//    imageCodeField.placeholder = @"请输入随机码";
//    imageCodeField.font = [UIFont systemFontOfSize:14];
//    imageCodeField.textColor = [UIColor colorWithHexString:@"333333"];
//    imageCodeField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
//    [inputView addSubview:imageCodeField];
//    [imageCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imageCodeLabel.mas_right).offset(20*kiphone6);
//        make.centerY.equalTo(imageCodeLabel);
//        make.width.offset(110);
//    }];
//    self.imageCodeField = imageCodeField;
//    imageCodeField.delegate = self;
//    //添加显示图片验证码的imageView
//    UIImageView *codeImageView = [[UIImageView alloc]init];
//    [inputView addSubview:codeImageView];
//    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-15*kiphone6);
//        make.centerY.equalTo(imageCodeField);
//        make.width.offset(100*kiphone6);
//        make.height.offset(35*kiphone6);
//    }];
//    self.codeImageView = codeImageView;
//    codeImageView.userInteractionEnabled = true;
    //添加点击更换图片事件
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
//    [codeImageView addGestureRecognizer:tap];
    
    //显示请求回来的图片
    //参数：当前时间毫秒
//    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
//    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
//    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
//    self.curTime = curTime;
//    //动态码图片url
//    NSString *codeUrlStr = [NSString stringWithFormat:@"%@/personal/imgcode.do?ts=%@",mPrefixUrl,curTime];
//    [codeImageView sd_setImageWithURL:[NSURL URLWithString:codeUrlStr] placeholderImage:nil options:SDWebImageHandleCookies];
//    //    [codeImageView sd_setImageWithURL:[NSURL URLWithString:codeUrlStr] placeholderImage:nil options:SDWebImageHandleCookies progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    //        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:codeUrlStr]];
//    //        NSDictionary* requestFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//    //        [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:@"DynamicCodeCookie"];
//    //        NSLog(@"----->%@",cookies.description);
//    //    }];
//
//    //添加line2
//    UIView *line2 = [[UIView alloc]init];
//    line2.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
//    [inputView addSubview:line2];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line1.mas_bottom).offset(49*kiphone6);
//        make.left.right.offset(0);
//        make.height.offset(1/[UIScreen mainScreen].scale);
//    }];
//    //添加验证码label
//    UILabel *codeNumLabel = [UILabel labelWithText:@"验证码" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
//    [inputView addSubview:codeNumLabel];
//    [codeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15*kiphone6);
//        make.centerY.equalTo(line2.mas_centerY).offset(25*kiphone6);
//    }];
    //添加密码textField
    UITextField *passWordField = [[UITextField alloc]init];
    passWordField.font = [UIFont systemFontOfSize:14];
    passWordField.textColor = [UIColor colorWithHexString:@"ffffff"];
    passWordField.layer.cornerRadius = 4;
    passWordField.layer.borderColor = [UIColor colorWithHexString:@"d1dbe7"].CGColor;
    passWordField.layer.borderWidth = 1;
    UIView *pLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    pLeftView.backgroundColor = [UIColor clearColor];
    UIImageView *passImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password_login_leftView"]];
    [pLeftView addSubview:passImageView];
    [passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(passImageView.bounds.size.width);
        make.height.offset(passImageView.bounds.size.height);
    }];
    passWordField.leftView = pLeftView;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    passWordField.placeholder = @"请输入密码";
    [passWordField setValue:[UIColor colorWithHexString:@"ffffff"] forKeyPath:@"_placeholderLabel.textColor"];
    [passWordField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    telNumberField.font = [UIFont systemFontOfSize:12];
    passWordField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    [self.view addSubview:passWordField];
    [passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telNumberField.mas_bottom).offset(44);
        make.centerX.equalTo(logImageView);
        make.width.offset(250);
        make.height.offset(44);
    }];
    self.passWordField = passWordField;
    
//    //添加获取验证码Btn
//    UIButton *getCodeBtn = [[UIButton alloc]init];
//    getCodeBtn.layer.masksToBounds = true;
//    getCodeBtn.layer.cornerRadius = 17.5*kiphone6;
//    [getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
//    [getCodeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//    [getCodeBtn setBackgroundColor:[UIColor colorWithHexString:@"#1ebeec"]];
//    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [inputView addSubview:getCodeBtn];
//    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-15*kiphone6);
//        make.centerY.equalTo(codeNumLabel);
//        make.width.offset(100*kiphone6);
//        make.height.offset(35*kiphone6);
//    }];
//    //点击事件
//    [getCodeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
//    //添加确认阅读条款Label---------需要修改添加链接
//    UILabel *readLabel = [UILabel labelWithText:@"我已确认阅读并同意《使用条款和隐私协议》" andTextColor:[UIColor blackColor] andFontSize:12];
//    [self.view addSubview:readLabel];
//    [readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputView.mas_bottom).offset(15*kiphone6);
//        make.centerX.equalTo(self.view).offset(10*kiphone6);
//    }];
//    //添加选择按钮
//    UIButton *selectBtn = [[UIButton alloc]init];
//    [selectBtn setImage:[UIImage imageNamed:@"logo_selected"] forState:UIControlStateNormal];
//    [self.view addSubview:selectBtn];
//    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputView.mas_bottom).offset(15*kiphone6);
//        make.centerY.equalTo(readLabel);
//        make.right.equalTo(readLabel.mas_left).offset(-5*kiphone6);
//    }];
    //添加登录Btn
    UIButton *logInBtn = [[UIButton alloc]init];
    logInBtn.layer.masksToBounds = true;
    logInBtn.layer.cornerRadius = 20;
    [logInBtn setTitle:@"登录" forState:UIControlStateNormal];
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
    if ([self.telNumberField.text isEqualToString:@"18511694068"]) {
//        CcUserModel *userModel = [CcUserModel defaultClient];
//        userModel.userToken = @"0E42DEF6581D286271F2BDB95014315B";
//        userModel.telephoneNum = @"18511694068";
//        [userModel saveAllInfo];
//        //跳转登录首页
//        YYTabBarController *tabBarVC = [[YYTabBarController alloc]init];
//        [SVProgressHUD dismiss];// 动画结束
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
        
    }else{
        if (![self valiMobile:self.telNumberField.text]||[self.passWordField.text isEqualToString:@""]) {
            [self showAlertWithMessage:@"请确认电话号码和验证码是否输入正确"];
            return;
        }
        //cookie
        //        NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
//        http://192.168.1.168:8085/admin/login?name=13717883005&password=12345
        NSString *urlString = [NSString stringWithFormat:@"%@/admin/login?name=%@&password=%@",mPrefixUrl,self.telNumberField.text,self.passWordField.text];
        HttpClient *httpManager = [HttpClient defaultClient];
//        [httpManager.manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"telphoneCodeCookie"] forHTTPHeaderField:@"Cookie"];//设置之前手机验证码请求返回的cookie并设置到登录请求中，以便服务器确认登录
        [SVProgressHUD show];
        [httpManager requestWithPath:urlString method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                NSDictionary *userDic = dic[@"User"];
                CcUserModel *defaultModel = [CcUserModel defaultClient];
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
                NSLog(@"------->%@",fields[@"Set-cookie"]);
                NSString *userCookie = fields[@"Set-cookie"];//获取当前cookie
                defaultModel.userCookie = userCookie;
                //保存用户信息
                [defaultModel saveAllInfo];
                //跳转登录首页
                YYTabBarController *firstVC = [[YYTabBarController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;
                
            }else{
                if ([dic[@"result"] isEqualToString:@""]) {
                    [self showAlertWithMessage:@"请确认电话号码正确以及网络是否正常"];
                }else{
                    [self showAlertWithMessage:@"请确认验证码正确"];
                }
                
                self.passWordField.text = nil;
                
            }
            [SVProgressHUD dismiss];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.telNumberField == textField)  //判断是否是我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
            //            textField.text = [textField.text substringToIndex:11];
            [self showAlertWithMessage:@"您输入的电话号码超过11位"];
            
            return NO;
        }
    }
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * toBeString = textField.text; //得到输入框的内容
    if (self.telNumberField == textField)  //判断是否是我们想要限定的那个输入框
        
    {
        
        if ([textField.text length] < 11){
            [self showAlertWithMessage:@"您输入的电话号码少于11位"];
            
            
        }else if ([textField.text length] == 11){
            if (![self valiMobile:toBeString]) {
                [self showAlertWithMessage:@"请输入正确的11位电话号码"];
                
            }
        }
    }
}
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
//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.telNumberField becomeFirstResponder];
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
