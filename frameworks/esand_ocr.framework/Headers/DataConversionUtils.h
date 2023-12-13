//
//  DataConversionUtils.h
//  esand_ios_demo
//
//  Created by eSandInfo on 2019/3/10.
//  Copyright © 2019年 esandinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataConversionUtils:NSObject

/**
 字符串base64转码
 */
+ (NSString *)b64Encode:(NSString *)content;

/**
 base64字符串解码
 */
+ (NSString *)b64Dencode:(NSString *)base64String;

/**
 NSDictionary对象转换成Json字符串
 
 @param dict NSDictionary对象
 @return Json字符串
 */
+ (NSString *)dict2Json:(NSDictionary *)dict;

/**
 Json字符串转换成NSDictionary对象
 
 @param json Json字符串
 @return dict NSDictionary对象
 */
+ (NSDictionary *)json2Dict:(NSString *)json;

/**
 字符串判空
 
 @param str 字符串
 @return BOOL
 */
+ (BOOL) isBlank:(NSString *) str;

/**
 图片大小转换
 
 @param img 原图片
 @param size 要改成的图片规格
 @return 大小转换后的图片
 */
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 对图片的方向信息进行矫正
 
 @param aImage 原图片
 @return 方向信息矫正后的图片
 */
+(UIImage*)fixOrientation:(UIImage*)aImage;

@end
