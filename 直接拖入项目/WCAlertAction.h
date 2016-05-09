//
//  WCAlertAction.h
//  WCAlert
//
//  Created by lw on 16/4/27.
//  Copyright © 2016年 lw. All rights reserved.
//  该类模仿与UIAlertAction几乎一样的属性和方法
//  在运行时的时候动态检测是否有UIAlertAction类，若无，使其继承WCAlertAction类,使其在iOS8之前也可以使用

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WCAlertAction;

typedef  void (^WCAlertBlock)(WCAlertAction *alertAction);
// ===========================================================================================================================
#pragma mark 类型枚举
typedef NS_ENUM(NSUInteger, WCAlertActionStyle) {
    WCAlertActionStyleDefault = 0,
    WCAlertActionStyleCancel,
    WCAlertActionStyleDestructive
};
// ===========================================================================================================================
#pragma mark alertAction的公开方法和属性
@interface WCAlertAction : NSObject


@property (nonatomic, copy)   NSString            * title;
@property (nonatomic, assign) WCAlertActionStyle    style;
@property (nonatomic, copy)   WCAlertBlock          handler;
@property (nonatomic, assign) BOOL                  enabled;

+ (instancetype)actionWithTitle:(NSString *)title style:(WCAlertActionStyle)style handler:(WCAlertBlock)handler;

@end
// ===========================================================================================================================
