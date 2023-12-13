//
//  ViewController.m
//  ios-ocr
//
//  Created by ReidLee on 2020/8/18.
//  Copyright © 2020 ReidLee. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "esand_ocr/esand_ocr.h"

//屏幕宽度
#define  SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@end

@implementation ViewController
{
    OCRManager* _ocrManager;
    UITextView* _tvInfos;
    // 拍摄照片展示
    UIImageView* _imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 一砂LOGO
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo@3x"]];
    logoView.frame = CGRectMake(SCREEN_WIDTH/2-50, 30, 100, 100);
    [self.view addSubview:logoView];
    
    CGFloat btHeight = SCREEN_WIDTH/8;
    // 身份证正面
    UIButton* btFront = [self addButton: @"身份证正面" action:@selector(processOcr:) rect: CGRectMake(SCREEN_WIDTH/14, 150, 11*SCREEN_WIDTH/28, btHeight) identifier: @"ID_FRONT"];
    // 身份证反面
    UIButton* btBack = [self addButton: @"身份证反面" action:@selector(processOcr:) rect: CGRectMake(SCREEN_WIDTH/14, btFront.frame.origin.y + btFront.frame.size.height + 5, 11*SCREEN_WIDTH/28, btHeight) identifier: @"ID_BACK"];
    UIButton* btBank = [self addButton: @"银行卡" action:@selector(processOcr:) rect: CGRectMake(SCREEN_WIDTH/14, btBack.frame.origin.y + btBack.frame.size.height + 5, 11*SCREEN_WIDTH/28, btHeight) identifier: @"ID_BANK"];
    // 初始化日志显示界面
    [self initTvInfos: CGRectMake(0 ,btBank.frame.origin.y + btBank.frame.size.height + 15, self.view.frame.size.width, self.view.frame.size.height)];
    _ocrManager = [[OCRManager alloc] initWithViewController: self];
}

- (UIButton*)addButton:(NSString*) title action:(SEL)action rect: (CGRect) rect identifier: (NSString*) identifier {
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame =  rect;
    [bt setTitle: title forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:137.0/255.0 blue:47.0/255.0 alpha:1.0]];
    [bt.layer setCornerRadius:SCREEN_WIDTH/16];
    [bt addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    // 居中
    CGPoint posiction = CGPointMake(self.view.center.x, bt.center.y);
    bt.center = posiction;
    bt.accessibilityIdentifier = identifier;
    [self.view addSubview:bt];
    
    return bt;
}

- (void)initTvInfos: (CGRect) rect
{
    if (!_tvInfos) {
        _tvInfos = [[UITextView alloc]initWithFrame: rect];
        _tvInfos.pagingEnabled = YES;
        _tvInfos.clipsToBounds = YES;
        _tvInfos.layer.borderWidth = 1;
        _tvInfos.tag = 100;
        _tvInfos.editable = NO;
        _tvInfos.accessibilityIdentifier = @"txtLog";
        [self.view addSubview:_tvInfos];
    }
}

- (void)logMsg:(NSString*) content
{
    [self logWithContent:content color:[UIColor blackColor]];
}

- (void)logError:(NSString*)content
{
    [self logWithContent:content color:[UIColor redColor]];
}

- (void)logWithContent:(NSString*)content color:(UIColor*)color
{
    if (content == NULL) {
        return;
    }
    
    content = [NSString stringWithFormat:@"%@\n", content];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:content];
        [string addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, content.length)];
        NSMutableAttributedString* tvStr = [[NSMutableAttributedString alloc] initWithAttributedString: self->_tvInfos.attributedText];
        
        [tvStr appendAttributedString:string];
        [self->_tvInfos setAttributedText:tvStr];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    //从设置页面pop回来时，刷新界面
    [super viewWillAppear:animated];
}

/// 身份证正面
/// @param sender sender
-(IBAction) processOcr:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self->_tvInfos setAttributedText: nil];
    int ocrType = -1;
    if ([button.accessibilityIdentifier isEqualToString:@"ID_FRONT"]) { // 身份证正面
        ocrType = 0;
    } else if ([button.accessibilityIdentifier isEqualToString:@"ID_BACK"]) { // 身份证反面
        ocrType = 1;
    }else if ([button.accessibilityIdentifier isEqualToString:@"ID_BANK"]) { // 身份证反面
        ocrType = 2;
    }
    
    // 初始化(此段逻辑通常放在业务服务器端)
    NSString* url = @"https://edisocr.market.alicloudapi.com/ocr/init";
    NSString* body = [NSString stringWithFormat:@"ocrType=%i",ocrType];
    // APPPCODE 需要替换成您的 （APPCODE为访问阿里云服务的钥匙，每个用户都不一样，切勿泄漏，建议把这段逻辑放在服务器端以保护APPCODE）
    NSString* appcode = APPCODE;
    [AliyunHttpClient requestSync:url body:body appcode:appcode clientCallback:^(NSString * _Nonnull rspMsg) {
        if (rspMsg == nil) {
            [self logError: @"服务器返回数据为空"];
            return;
        }
        
        NSLog(@"初始化服务器端返回的数据： %@", rspMsg);
        NSError *error;
        NSData *jsonData = [rspMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            [self logError: @"服务器返回数据异常"];
            return;
        }
        
        NSString* code = [jsonDict objectForKey:@"code"];
        if (![@"0000" isEqualToString:code]) {
            [self logError: @"服务器执行失败"];
            return;
        }
        
        NSString* token = [jsonDict objectForKey:@"token"];
        // 发起认证操作
        [self->_ocrManager processOcr: ocrType token: token from:0 ocrCallBack:^(OcrResult* ocrResult) {
            // 显示执行结果
            [self logMsg: [NSString stringWithFormat: @"code = %@", ocrResult.code]];
            // 执行结果描述
            [self logMsg: [NSString stringWithFormat: @"msg = %@", ocrResult.msg]];
            // 请求ID
            [self logMsg: [NSString stringWithFormat: @"requestId = %@", ocrResult.requestId]];
            // 响应数据
            [self logMsg: [NSString stringWithFormat: @"data = %@", ocrResult.data]];
            if (ocrResult.image != nil) {
                // 显示拍摄的照片
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData* data = [[NSData alloc] initWithBase64EncodedString: ocrResult.image options:0];
                    UIImage* image = [UIImage imageWithData:data];
                    [self->_imgView setImage: image];
                });
            }
        }];
    }];
}

@end
