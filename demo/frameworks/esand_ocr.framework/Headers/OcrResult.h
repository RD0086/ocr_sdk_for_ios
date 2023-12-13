//
//  OcrResult.h
//  esand-ocr
//
//  Created by ReidLee on 2020/8/18.
//  Copyright © 2020 ReidLee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OcrResult : NSObject

/**
 * 状态码
 * 详情参考OCRErrorCode
 */
@property (nonatomic, copy) NSString* code;
/**
 * 执行结果描述
 */
@property (nonatomic, copy) NSString* msg;
/**
 * 请求ID
 */
@property (nonatomic, copy) NSString* requestId;
/**
 * 执行结果数据
 */
@property (nonatomic, copy) NSString* data;
/**
 * 照片的base64字符串
 */
@property (nonatomic, copy) NSString* image;

- (instancetype)initWithCode:(NSString*) code andMsg:(NSString*) msg;

/**
 * 设置code和msg
 * @param code 状态码
 * @param msg 错误描述信息
 */
- (void) setCode: (NSString*) code andMsg:(NSString*) msg;

@end

NS_ASSUME_NONNULL_END
