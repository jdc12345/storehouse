//
//  YYFeedbackViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/28.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYFeedbackViewController.h"
//#import "UIColor+Extension.h"
#import "HttpClient.h"
#import "CcUserModel.h"

@interface YYFeedbackViewController ()
@property (nonatomic, strong) UITextView *feedTextView;
@property (nonatomic, strong) UITextField *phoneTextF;
@end

@implementation YYFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.title = @"意见反馈";
    //提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sendFeedBack)];
    [rightButton setTintColor:[UIColor colorWithHexString:@"30a2d4"]];
    self.navigationItem.rightBarButtonItem = rightButton;
   
    [self createSubView];
    // Do any additional setup after loading the view.
}
- (void)createSubView{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"您的意见";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    UITextView *feedTextView = [[UITextView alloc]init];
//    feedTextView.scrollEnabled = NO;
    feedTextView.font = [UIFont systemFontOfSize:14];
    feedTextView.textColor = [UIColor colorWithHexString:@"333333"];
    feedTextView.layer.cornerRadius = 2.5;
    feedTextView.clipsToBounds = YES;
    feedTextView.backgroundColor = [UIColor whiteColor];
    feedTextView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    
    
    UILabel *wordCount = [[UILabel alloc]init];
    wordCount.text = @"0/200";
    wordCount.textColor = [UIColor colorWithHexString:@"b4b4b4"];
    wordCount.font = [UIFont systemFontOfSize:12];
    wordCount.textAlignment = NSTextAlignmentRight;
    
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"您的联系方式";
    phoneLabel.textColor = [UIColor colorWithHexString:@"333333"];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *cardLabel = [[UILabel alloc]init];
    cardLabel.backgroundColor = [UIColor whiteColor];
    cardLabel.layer.cornerRadius = 2.5;
    cardLabel.clipsToBounds = YES;
    
    UITextField *phoneTextF = [[UITextField alloc]init];
    phoneTextF.font = [UIFont systemFontOfSize:14];
    phoneTextF.textColor = [UIColor colorWithHexString:@"333333"];
    phoneTextF.placeholder = @"输入邮箱或者电话";
    
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:feedTextView];
    [self.view addSubview:wordCount];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:cardLabel];
    [self.view addSubview:phoneTextF];
    
    WS(ws);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenH > 736) {//iPhone X
            make.top.offset(88+12);
        }else{
            make.top.offset(64+12);
        }
        make.left.equalTo(ws.view).with.offset(20 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(300 ,14));
    }];
    [feedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(14 *kiphone6);
        make.left.equalTo(ws.view).with.offset(10 );
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 240 *kiphone6 ));
    }];
    [wordCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedTextView.mas_bottom).with.offset(10 *kiphone6);
        make.right.equalTo(ws.view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 12 *kiphone6 ));
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wordCount.mas_bottom).with.offset(15 *kiphone6);
        make.left.equalTo(ws.view).with.offset(20 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(300 ,14));
    }];
    
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(15 *kiphone6);
        make.left.equalTo(ws.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 60 *kiphone6 ));
    }];
    
    [phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardLabel.mas_centerY);
        make.centerX.equalTo(cardLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenW -40, 14 *kiphone6 ));
    }];
    
    self.feedTextView = feedTextView;
    self.phoneTextF = phoneTextF;
    
}
- (void)sendFeedBack{
//http://192.168.1.168:8085/mobileapi/feedback/save.do?content=%E6%88%91%E6%9C%89%E6%84%8F%E8%A7%81
//    content 必须，反馈内容
    HttpClient *httpManager = [HttpClient defaultClient];
    [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
    NSString *urlString = [NSString stringWithFormat:@"%@content=%@",mFeedBackRequest,self.feedTextView.text];
    //把中文转义
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpManager requestWithPath:urlString method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"提交成功%@",responseObject);

        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求出错"];
    }];
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
