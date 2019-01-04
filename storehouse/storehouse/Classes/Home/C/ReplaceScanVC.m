//
//  ReplaceScanVC.m
//  storehouse
//
//  Created by 万宇 on 2019/1/4.
//  Copyright © 2019 wanyu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "HttpClient.h"
#import "OutPutReplaceDetailVC.h"


/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

#import "ReplaceScanVC.h"

@interface ReplaceScanVC ()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}
@property (strong,nonatomic)AVCaptureDevice * device;//摄像头
@property (strong,nonatomic)AVCaptureDeviceInput * input;//摄像头输入
@property (strong,nonatomic)AVCaptureMetadataOutput * output;//摄像头输出
@property (strong,nonatomic)AVCaptureSession * session;//AVFoundation的核心类,用于捕捉视频和音频,协调视频和音频的输入和输出流.
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;//摄像头的视频预览层.
@property (nonatomic, strong) UIImageView * line;//扫描滚动的线

@end

@implementation ReplaceScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    // 意思就是延伸到边界
    self.extendedLayoutIncludesOpaqueBars = true;//解决视图下移64
    
    [self configView];
    
    // Do any additional setup after loading the view.
}

- (void)action{
    //    YJConnectWifiVC *addEquipmentVC  = [[YJConnectWifiVC alloc]init];
    //    [self.navigationController pushViewController:addEquipmentVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//1.设置扫描外框和图片
-(void)configView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (_session != nil && timer != nil) {
        [timer setFireDate:[NSDate date]];
        [_session startRunning];
    }
    if (_device == nil) {
        //2.画扫描框的外围阴影半透明区
        [self setCropRect:kScanRect];
        //3.设置摄像头和相关配置
        [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

//2.画扫描框的外围阴影半透明区
- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, CGRectMake(0, 0, kScreenW, kScreenH));
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}
//3.设置摄像头和相关配置
- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        HttpClient *httpManager = [HttpClient defaultClient];
        [SVProgressHUD show];
        [httpManager.manager.requestSerializer setValue:[CcUserModel defaultClient].userCookie forHTTPHeaderField:@"Cookie"];//设置之前登录请求返回的cookie并设置到接口请求中，以便服务器确认登录
        NSString *urlStr = [NSString stringWithFormat:@"%@barcode=%@",mScanResult,stringValue];
        [httpManager requestWithPath:urlStr method:HttpRequestGet parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                if (![dic[@"assetQrCode"] isKindOfClass:[NSNull class]]) {//数据库标注过物品
                    NSDictionary *lastDic = (NSDictionary *)dic[@"assetQrCode"];
                    NSNumber *isUse = (NSNumber*)lastDic[@"isUse"];
                    NSNumber *assetId = (NSNumber*)lastDic[@"assetId"];
                    int intIsUse = [isUse intValue];
                    int intAssetId = [assetId intValue];
                    
                    if (intIsUse != 0 && intAssetId != 0) {//已入库
                        
                        for (UIViewController* vc in self.navigationController.childViewControllers) {
                            if ([vc isKindOfClass:[OutPutReplaceDetailVC class]]) {
                                //3.设置代理
                                self.delegate = vc;
                                if ([self.delegate respondsToSelector:@selector(returnBarCode:)]) {
                                    [self.delegate returnBarCode:stringValue];
                                    [self.navigationController popViewControllerAnimated:true];
                                }
                            }
                        };
                        
                    }else if (intIsUse == 0){//未入库
                        //跳转入库页面
                        [SVProgressHUD showInfoWithStatus:@"该二维码未绑定资产"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:true];
                        });
                        
                    }
                    
                    //    ----------------------------------------------
                }else{//未知二维码结果
                    [SVProgressHUD showInfoWithStatus:@"你扫描的二维码无效"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:true];
                    });
                }
                
            }else if ([dic[@"code"] isEqualToString:@"-1"]){
                [SVProgressHUD showInfoWithStatus:@"登录已过期,请重新登录"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"请求失败,请重试"];
            [self.navigationController popViewControllerAnimated:true];
            return ;
        }];
        
        
        
        //        YJBindingEquipmentVC *addEquipmentVC  = [[YJBindingEquipmentVC alloc]init];
        //        addEquipmentVC.scanStr = stringValue;
        //        [self.navigationController pushViewController:addEquipmentVC animated:YES];
        NSArray *arry = metadataObject.corners;
        for (id temp in arry) {
            NSLog(@"%@",temp);
        }
        
        //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        //        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //            if (_session != nil && timer != nil) {
        //                [self action];
        //                //                [_session startRunning];
        //                //                [timer setFireDate:[NSDate date]];
        //                [_session stopRunning];
        //                //关闭定时器
        //                [timer setFireDate:[NSDate distantFuture]];
        //                //开启定时器
        ////                [scrollView.myTimer setFireDate:[NSDate distantPast]];
        //            }
        //
        //        }]];
        //        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        NSLog(@"无扫描信息");
        return;
    }
    
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
