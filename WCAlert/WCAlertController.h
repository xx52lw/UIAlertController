//
//  WCAlertController.h
//  WCAlert
//
//  Created by lw on 16/4/27.
//  Copyright © 2016年 lw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WCAlertAction;

// ===========================================================================================================================
#pragma mark 类型枚举
typedef NS_ENUM(NSUInteger, WCAlertControllerStyle) {
    WCAlertControllerStyleActionSheet = 0,
    WCAlertControllerStyleAlert
};

// ===========================================================================================================================

#pragma mark WCAlertController公开方法和属性
@interface WCAlertController : NSObject
/** 初始化 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WCAlertControllerStyle)preferredStyle;
/** 添加WCAlertAction */
- (void)addAction:(WCAlertAction *)action;
// 下面两个方法是iOS9之后才有，这里仅仅提供方法调用，不实现setter和getter方法内部逻辑
@property (nonatomic, strong) WCAlertAction * preferredAction;
@property (nonatomic, assign, readonly) WCAlertControllerStyle  preferredStyle;
/** 添加textField */
- (void)addTextFieldWithConfigurationHandler:(void(^)(UITextField *textField))configurationHandler;
/** textField数组 */
@property (nonatomic, strong, readonly) NSArray<UITextField *> * textFields;
/** 标题 */
@property (nonatomic, copy) NSString * title;
/** 内容（actionSheet类型没有） */
@property (nonatomic, copy) NSString * message;
/** 是否可用 */
@property (nonatomic, assign) BOOL  enabled;
/** 展示方法 */
- (void)wc_showInView:(UIView *)view;

@end

// ===========================================================================================================================