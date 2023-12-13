//
//  OCRManager.h
//  Esand-Ocr
//
//  Created by ReidLee on 2020/8/18.
//  Copyright © 2020 ReidLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OcrResult.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString* currentToken; // 当前token
/// OCR结果回调块定义
typedef void (^OCRCallback)(OcrResult* ocrResult);

/// OCR 管理类
@interface OCRManager : NSObject

/// 初始化函数
- (id) initWithViewController:(UIViewController*) vc;

/// 执行OCR操作
/// @param ocrType OCR类型，0：身份证正面，1：身份证背面
/// @param token 初始化拿到的token字符串
/// @param from 0: 从相机拍摄，1：从相册获取
/// @param ocrCallBack 执行结果回调
- (void) processOcr:(int) ocrType token: (NSString*) token from:(int)from ocrCallBack: (OCRCallback) ocrCallBack;

/**
 * 获取 SDK 版本
 * @return  SDK版本号
 */
+ (NSString*) getSDKVersion;
@end

NS_ASSUME_NONNULL_END
