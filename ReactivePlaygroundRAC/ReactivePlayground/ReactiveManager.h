//
//  RectiveManager.h
//  ReactivePlayground
//
//  Created by QC.L on 16/1/9.
//  Copyright © 2016年 QC.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


// 实际项目可根据请求结果决定
typedef void(^SignInResponse)(BOOL);
@interface ReactiveManager : NSObject

/**
 *  登陆的方法
 *
 *  @param username      用户名
 *  @param password      密码
 *  @param completeBlock 登陆成功后的回调
 */
+ (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(SignInResponse)completeBlock;

@end
