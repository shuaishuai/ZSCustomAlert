//
//  CustomAlert.m
//  MoneyManager
//
//  Created by Allen on 16/4/24.
//  Copyright © 2016年 Shuai. All rights reserved.
//

#import "ZSCustomAlert.h"
#import <objc/runtime.h>

const char *alertViewKey = "alertViewKey";

@protocol UIAlertControllerDelegate <NSObject>
@optional
-(void)alertController:(UIAlertController *)alertController actionHadBeenTriger:(UIAlertAction *)action;
@end

@interface UIAlertController (AddAction)
@property (nonatomic,weak)id<UIAlertControllerDelegate>delegate;
-(void)addActionWithTittle:(NSString *)title;
@end

@interface ZSCustomAlert ()<UIAlertViewDelegate,UIActionSheetDelegate,UIAlertControllerDelegate>
@property (nonatomic, copy)ZSAlertHandler alertHandler;
@property (nonatomic, strong)NSArray *titlesArray;
@end

@implementation ZSCustomAlert

+ (instancetype)shareInstance{
    static ZSCustomAlert *customAlert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customAlert = [[ZSCustomAlert alloc]init_];
    });
    customAlert.alertStyle = UIAlertControllerStyleAlert;
    return customAlert;
}

- (instancetype)init_{
    if (self = [super init]) {
        //custom
    }
    return self;
}

- (void)showWithMessage:(NSString *)message showController:(UIViewController *)showController{
    return [self showWithHeader:nil message:message showController:showController  withHandler:nil andTitles:@"确定", nil];
}

- (void)showWithHeader:(NSString *)header message:(NSString *)message withHandler:(ZSAlertHandler)handler showController:(UIViewController *)showController titleList:(NSArray *)titleList{
    _alertHandler = handler;
    _titlesArray = titleList;
    if (SystemVersionFloatValue < 8.0)
    {
        if (self.alertStyle == UIAlertControllerStyleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc]init];
            alertView.delegate = self;
            alertView.title = header;
            alertView.message = message;
            [titleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [alertView addButtonWithTitle:obj];
            }];
            [alertView show];
        }else if (self.alertStyle == UIAlertControllerStyleActionSheet){
            UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
            actionSheet.delegate = self;
            [titleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [actionSheet addButtonWithTitle:obj];
            }];
            [actionSheet showInView:showController.view];
        }
    }
    else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:self.alertStyle];
        alertController.delegate = self;
        [titleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [alertController addActionWithTittle:obj];
        }];
        [showController presentViewController:alertController animated:YES completion:^{}];
    }
}


- (void)showWithHeader:(NSString *)header message:(NSString *)message showController:(UIViewController *)showController withHandler:(ZSAlertHandler)handler andTitles:(NSString *)title1, ...NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *titleArray = [[NSMutableArray alloc]init];
    va_list args;
    va_start(args, title1);
    for (NSString * title = title1; title!=nil;title = va_arg(args, NSString *)) {
        [titleArray addObject:title];
    }
    va_end(args);
    [self showWithHeader:header message:message withHandler:handler showController:showController titleList:titleArray];
}

- (void)alertController:(UIAlertController *)alertController actionHadBeenTriger:(UIAlertAction *)action{
    int buttonIndex = (int)[alertController.actions indexOfObject:action];
    if (_alertHandler) {
        _alertHandler(buttonIndex,self.titlesArray[buttonIndex]);
        _alertHandler = nil;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_alertHandler) {
        _alertHandler(buttonIndex,self.titlesArray[buttonIndex]);
        _alertHandler = nil;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_alertHandler) {
        _alertHandler(buttonIndex,self.titlesArray[buttonIndex]);
        _alertHandler = nil;
    }
}

@end

const char * delegateKey = "delegateKey";
@implementation UIAlertController (AddAction)
-(void)setDelegate:(id<UIAlertControllerDelegate>)delegate{
    if (delegate) {
        objc_setAssociatedObject(self, delegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
    }
}

-(id<UIAlertControllerDelegate>)delegate{
    id myDelegate = objc_getAssociatedObject(self, delegateKey);
    return myDelegate;
}

-(void)addActionWithTittle:(NSString *)title{
    __weak typeof(self) weakSelf = self;
    UIAlertAction * action  = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.delegate respondsToSelector:@selector(alertController:actionHadBeenTriger:)]) {
            [weakSelf.delegate alertController:weakSelf actionHadBeenTriger:action];
        }
    }];
    [self addAction:action];
}

@end
