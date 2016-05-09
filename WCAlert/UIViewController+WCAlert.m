//
//  UIViewController+WCAlert.m
//  WCAlert
//
//  Created by lw on 16/4/27.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "UIViewController+WCAlert.h"
#import <objc/runtime.h>
#import "WCAlertController.h"

// ===========================================================================================================================
@implementation UIViewController (WCAlert)

#pragma mark 运行时时执行方法交换
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(wc_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),  (char *)(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark 交换后的方法
// 如果是WCAlertController类型使用其wc_showInView:方法
- (void)wc_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[WCAlertController class]]) {
        [(WCAlertController *)viewControllerToPresent wc_showInView:self.view];
    } else {
        [self wc_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}
@end
// ===========================================================================================================================
