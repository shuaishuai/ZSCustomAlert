//
//  CustomAlert.h
//  MoneyManager
//
//  Created by Allen on 16/4/24.
//  Copyright © 2016年 Shuai. All rights reserved.
//

#define SystemVersionFloatValue  [[[UIDevice currentDevice] systemVersion] floatValue]
#define ZSShareCustomAlert [ZSCustomAlert shareInstance]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ZSAlertHandler)(NSInteger selectedIndex, NSString *selectTitle);

@interface ZSCustomAlert : NSObject
@property (nonatomic, assign)UIAlertControllerStyle alertStyle;//def:UIAlertControllerStyleAlert
/**
 单例获取

 @return shareInstance
 */
+ (instancetype)shareInstance;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
/**
 展示弹框

 @param message 弹框信息
 @param showController 父控制器
 */
- (void)showWithMessage:(NSString *)message showController:(UIViewController *)showController;

/**
 弹窗提示

 @param header 头部提示
 @param message 提示信息
 @param showController 控制器容器
 @param handler 回调block
 @param title1 按钮列表
 */
- (void)showWithHeader:(NSString *)header message:(NSString *)message showController:(UIViewController *)showController withHandler:(ZSAlertHandler)handler andTitles:(NSString *)title1, ...NS_REQUIRES_NIL_TERMINATION;

/**
 弹窗提示
 
 @param header 头部提示
 @param message 提示信息
 @param showController 控制器容器
 @param handler 回调block
 @param titleList 按钮列表
 */
- (void)showWithHeader:(NSString *)header message:(NSString *)message withHandler:(ZSAlertHandler)handler showController:(UIViewController *)showController titleList:(NSArray <NSString *>*)titleList;
@end
