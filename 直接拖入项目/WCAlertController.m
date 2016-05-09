//
//  WCAlertController.m
//  WCAlert
//
//  Created by lw on 16/4/27.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "WCAlertController.h"
#import "WCAlertAction.h"
#import <objc/runtime.h>


static WCAlertController *vc;

// ===========================================================================================================================
@interface WCAlertController ()
{
    UIAlertView   * _wcAlertView;
    UIActionSheet * _wcActionSheet;
    NSMutableArray *_alertActionArray;
    NSMutableArray *_alertTextFieldArray;
    NSMutableArray *_actionSheetNOenableArray;
    WCAlertControllerStyle _style;
}
@end

// ===========================================================================================================================
@interface WCAlertController (UIAlertViewDelegateSheetDelegate)<UIAlertViewDelegate,UIActionSheetDelegate>

@end
// ===========================================================================================================================
#pragma mark - WCAlertController控制器方法实现
@implementation WCAlertController

#pragma mark 属性的setter或者是getter方法
- (NSArray<WCAlertAction *> *)actions
{
    return vc->_alertActionArray;
}

- (void)setPreferredAction:(WCAlertAction *)preferredAction
{
  // 只有在iOS9之后才有的属性，这里不做处理
}
- (WCAlertAction *)preferredAction
{
    // 只有在iOS9之后才有的属性，这里不做处理
    return nil;
}

- (WCAlertControllerStyle)preferredStyle
{
    return vc->_style;
}

- (void)setTitle:(NSString *)title
{
    if (WCAlertControllerStyleAlert == vc->_style)
        vc->_wcAlertView.title = title;
    else if (WCAlertControllerStyleActionSheet == vc->_style)
        vc->_wcActionSheet.title = title;
}

- (NSString *)title
{
    if (WCAlertControllerStyleAlert == vc->_style)
       return  vc->_wcAlertView.title;
    else if (WCAlertControllerStyleActionSheet == vc->_style)
       return  vc->_wcActionSheet.title;
    else
       return nil;
}

- (void)setMessage:(NSString *)message
{
    if (WCAlertControllerStyleAlert == vc->_style)
        vc->_wcAlertView.message = message;
    else if (WCAlertControllerStyleActionSheet == vc->_style)
    {
       // UIActionSheet 没有message属性
    }
}

- (NSString *)message
{
    if (WCAlertControllerStyleAlert == vc->_style)
        return  vc->_wcAlertView.message;
    else if (WCAlertControllerStyleActionSheet == vc->_style)
    {
        // UIActionSheet 没有message属性
        return nil;
    }
    else
        return nil;
}

- (NSArray<UITextField *> *)textFields
{
    if (WCAlertControllerStyleActionSheet == vc->_style) {
        // UIActionSheet没有textField处理，这里直接返回空
        return nil;
    }
    // 只有一个textfield
    if (UIAlertViewStylePlainTextInput == vc->_wcAlertView.alertViewStyle || UIAlertViewStyleSecureTextInput == vc->_wcAlertView.alertViewStyle)
        return [NSArray arrayWithObject:[vc->_wcAlertView textFieldAtIndex:0]];
    
    else if (UIAlertViewStyleLoginAndPasswordInput == vc->_wcAlertView.alertViewStyle)
        return [NSArray arrayWithObjects:[vc->_wcAlertView textFieldAtIndex:0],[vc->_wcAlertView textFieldAtIndex:1], nil];
   
    else
         return nil;

}

#pragma mark 创建单例对象
+ (void)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[WCAlertController alloc] init];
        vc->_alertActionArray = [NSMutableArray array];
    });
    if (vc->_alertActionArray.count > 0)
        [vc->_alertActionArray removeAllObjects];
}

#pragma mark 初始化控制器对象
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WCAlertControllerStyle)preferredStyle
{
    [self shareInstance];
    vc->_style = preferredStyle;
    if (WCAlertControllerStyleAlert == preferredStyle)
    {
        vc->_wcAlertView = [[UIAlertView alloc] init];
        vc->_wcAlertView.delegate = vc;
        vc->_wcAlertView.title    = title;
        vc->_wcAlertView.message  = message;
    }
    else if (WCAlertControllerStyleActionSheet == preferredStyle)
    {
        vc->_wcActionSheet          = [[UIActionSheet alloc] init];
        vc->_wcActionSheet.delegate = vc;
        vc->_wcActionSheet.title    = title;
    }
    return vc;
}

#pragma mark 添加wcAlertAction
- (void)addAction:(WCAlertAction *)action
{
    if (WCAlertControllerStyleAlert == vc->_style)
        [vc->_wcAlertView addButtonWithTitle:action.title];
    else if (WCAlertControllerStyleActionSheet == vc->_style)
    {
        [vc->_wcActionSheet addButtonWithTitle:action.title];
    }
    // 存储到数组
    [vc->_alertActionArray addObject:action];
}

#pragma mark 展示View
- (void)wc_showInView:(UIView *)view
{
    if (WCAlertControllerStyleAlert == vc->_style)
        [vc->_wcAlertView show];
    else if (WCAlertControllerStyleActionSheet == vc->_style)
    {
        if (view)
        {
            // 初始化不可点击按钮数组
            if (!vc->_actionSheetNOenableArray)
                vc->_actionSheetNOenableArray = [[NSMutableArray alloc] initWithCapacity:vc->_alertActionArray.count];
            [vc->_actionSheetNOenableArray removeAllObjects];
            // 遍历数组中每个元素
            for (NSInteger i = 0;i < vc->_alertActionArray.count; ++i)
            {
                // 设置取消按钮和WCAlertActionStyleDestructive类型按钮位置
                WCAlertAction *action = vc->_alertActionArray[i];
                if (action.style == WCAlertActionStyleDestructive)
                    vc->_wcActionSheet.destructiveButtonIndex = i;
                else if (action.style == WCAlertActionStyleCancel)
                    vc->_wcActionSheet.cancelButtonIndex = i;
                // 设置是否不可用
                if (action.enabled == NO) {
                    if (![vc->_actionSheetNOenableArray containsObject:action])
                       [vc->_actionSheetNOenableArray addObject:action];
                }

            }
            [vc->_wcActionSheet showInView:view];
        }
    }
}

#pragma mark 添加textField
- (void)addTextFieldWithConfigurationHandler:(void(^)(UITextField *textField))configurationHandler
{
    if (WCAlertControllerStyleActionSheet == vc->_style)
    {
        // actionSheet无textfield，不需要处理
        return;
    }
    // 使用UIAlertView最多只可以显示操作2个输入框
    if (!vc->_alertTextFieldArray)
        vc->_alertTextFieldArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    if (UIAlertViewStyleDefault == vc->_wcAlertView.alertViewStyle) {
        UITextField *tempTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        tempTextField.backgroundColor = [UIColor clearColor];
        configurationHandler(tempTextField);
        // 在闭包初始化后，添加到数组中
        [vc->_alertTextFieldArray addObject:tempTextField];
        if (tempTextField.secureTextEntry == YES)
            vc->_wcAlertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        else
            vc->_wcAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        // 赋值系统UIAlertView第一个textField
        [self setValueFromTextField:tempTextField toTextField:[vc->_wcAlertView textFieldAtIndex:0]];
    }
    else if (vc->_wcAlertView.alertViewStyle == UIAlertViewStylePlainTextInput || vc->_wcAlertView.alertViewStyle == UIAlertViewStyleSecureTextInput)
    {
        UITextField *tempTextField = [[UITextField alloc]initWithFrame:CGRectZero];
        tempTextField.backgroundColor = [UIColor clearColor];
        configurationHandler(tempTextField);
        [vc->_alertTextFieldArray addObject:tempTextField];
        vc->_wcAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [self setValueFromTextField:tempTextField toTextField:[vc->_wcAlertView textFieldAtIndex:1]];
        [self setValueFromTextField:vc->_alertTextFieldArray[0] toTextField:[vc->_wcAlertView textFieldAtIndex:0]];
    }
    
}

- (void)setValueFromTextField:(UITextField *)tempTextField toTextField:(UITextField *)alertTextField {
    //给一些常用属性赋值
    alertTextField.text = tempTextField.text;
    alertTextField.secureTextEntry = tempTextField.secureTextEntry;
    alertTextField.attributedText = tempTextField.attributedText;
    alertTextField.textColor = tempTextField.textColor;
    alertTextField.font = tempTextField.font;
    alertTextField.textAlignment = tempTextField.textAlignment;
    alertTextField.placeholder = tempTextField.placeholder;
    alertTextField.attributedPlaceholder = tempTextField.attributedPlaceholder;
    alertTextField.clearsOnBeginEditing = tempTextField.clearsOnBeginEditing;
    alertTextField.delegate = tempTextField.delegate;
    alertTextField.background = tempTextField.background;
    alertTextField.backgroundColor = tempTextField.backgroundColor;
    alertTextField.disabledBackground = tempTextField.disabledBackground;
    alertTextField.clearButtonMode = tempTextField.clearButtonMode;
    alertTextField.leftView = tempTextField.leftView;
    alertTextField.leftViewMode = tempTextField.leftViewMode;
    alertTextField.rightView = tempTextField.rightView;
    alertTextField.rightViewMode = tempTextField.rightViewMode;
    alertTextField.inputView = tempTextField.inputView;
    alertTextField.inputAccessoryView = tempTextField.inputAccessoryView;
    alertTextField.tag = tempTextField.tag;
}

@end

// ===========================================================================================================================
@implementation WCAlertController (UIAlertViewDelegateSheetDelegate)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WCAlertAction *alertAction = vc->_alertActionArray[buttonIndex];
    WCAlertBlock alertBlock = alertAction.handler;
    if (alertBlock)
        alertBlock(alertAction);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WCAlertAction *alertAction = vc->_alertActionArray[buttonIndex];
    WCAlertBlock alertBlock = alertAction.handler;
    if (alertBlock)
        alertBlock(alertAction);
}

#pragma mark - 在actionsheet展示之前设置其是否可用点击
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for(UIView* actionView in actionSheet.subviews)
    {
        if([actionView isKindOfClass: [UIButton class]])
        {
            UIButton* currentBtn = (UIButton*)actionView;
            if (!vc->_actionSheetNOenableArray)
                return;
            for (WCAlertAction *action in vc->_actionSheetNOenableArray) {
                if (currentBtn.currentTitle == action.title)
                    [currentBtn setEnabled:NO];
            }
        }
    }
}


@end

// ===========================================================================================================================

#pragma mark - Runtime Injection

__asm(
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
#if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIAlertController:\n"
      ".quad           _OBJC_CLASS_$_UIAlertController\n"
#else
      ".align          2\n"
      "_OBJC_CLASS_UIAlertController:\n"
      ".long           _OBJC_CLASS_$_UIAlertController\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIAlertController\n"
      );

// Constructors are called after all classes have been loaded.
__attribute__((constructor)) static void WCAlertControllerPatchEntry(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            // >= iOS8.
            if (objc_getClass("UIAlertController")) {
                return;
            }
            
            Class *alertController = NULL;
            
#if TARGET_CPU_ARM
            __asm("movw %0, :lower16:(_OBJC_CLASS_UIAlertController-(LPC0+4))\n"
                  "movt %0, :upper16:(_OBJC_CLASS_UIAlertController-(LPC0+4))\n"
                  "LPC0: add %0, pc" : "=r"(alertController));
#elif TARGET_CPU_ARM64
            __asm("adrp %0, L_OBJC_CLASS_UIAlertController@PAGE\n"
                  "add  %0, %0, L_OBJC_CLASS_UIAlertController@PAGEOFF" : "=r"(alertController));
#elif TARGET_CPU_X86_64
            __asm("leaq L_OBJC_CLASS_UIAlertController(%%rip), %0" : "=r"(alertController));
#elif TARGET_CPU_X86
            void *pc = NULL;
            __asm("calll L0\n"
                  "L0: popl %0\n"
                  "leal _OBJC_CLASS_UIAlertController-L0(%0), %1" : "=r"(pc), "=r"(alertController));
#else
#error Unsupported CPU
#endif
            
            if (alertController && !*alertController) {
                Class class = objc_allocateClassPair([WCAlertController class], "UIAlertController", 0);
                if (class) {
                    objc_registerClassPair(class);
                    *alertController = class;
                }
            }
        }
    });
}



// ===========================================================================================================================