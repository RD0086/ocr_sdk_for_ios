//
//  OCRErrorCode.h
//  ios-ocr
//
//  Created by ReidLee on 2020/8/18.
//  Copyright © 2020 ReidLee. All rights reserved.
//

#ifndef OCRErrorCode_h
#define OCRErrorCode_h

/**
 * 一切正常
 */
#define SUCCESS @"0000"
/**
 * 本地执行异常
 */
#define EXCEPTION @"0001"
/**
 * 服务端异常
 */
#define SERVER_ERROR @"0002"
/**
 * 用户取消操作
 */
#define CANCEL @"0003"
/**
 * 摄像机权限未授予
 */
#define CAMERA_PERMISSION_EXCEPTION @"0004"

#endif /* OCRErrorCode_h */
