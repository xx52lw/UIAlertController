//
//  WCAlertAction.m
//  WCAlert
//
//  Created by lw on 16/4/27.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "WCAlertAction.h"
#import <objc/runtime.h>
// ===========================================================================================================================

@implementation WCAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(WCAlertActionStyle)style handler:(WCAlertBlock)handler
{
    WCAlertAction *alertAction = [[WCAlertAction alloc]init];
    alertAction.title = title;
    alertAction.style = style;
    alertAction.handler = handler;
    alertAction.enabled = YES;
    return alertAction;
}

@end
// ===========================================================================================================================
#pragma mark - 在运行时的时候动态检测是否有UIAlertAction类，若无，使其继承WCAlertAction类

__asm(
      ".section        __DATA,__objc_classrefs,regular,no_dead_strip\n"
#if	TARGET_RT_64_BIT
      ".align          3\n"
      "L_OBJC_CLASS_UIAlertAction:\n"
      ".quad           _OBJC_CLASS_$_UIAlertAction\n"
#else
      ".align          2\n"
      "_OBJC_CLASS_UIAlertAction:\n"
      ".long           _OBJC_CLASS_$_UIAlertAction\n"
#endif
      ".weak_reference _OBJC_CLASS_$_UIAlertAction\n"
      );

// Constructors are called after all classes have been loaded.
__attribute__((constructor)) static void WCAlertActionPatchEntry(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            // >= iOS8.
            if (objc_getClass("UIAlertAction")) {
                return;
            }
            
            Class *alertAction = NULL;
            
#if TARGET_CPU_ARM
            __asm("movw %0, :lower16:(_OBJC_CLASS_UIAlertAction-(LPC0+4))\n"
                  "movt %0, :upper16:(_OBJC_CLASS_UIAlertAction-(LPC0+4))\n"
                  "LPC0: add %0, pc" : "=r"(alertAction));
#elif TARGET_CPU_ARM64
            __asm("adrp %0, L_OBJC_CLASS_UIAlertAction@PAGE\n"
                  "add  %0, %0, L_OBJC_CLASS_UIAlertAction@PAGEOFF" : "=r"(alertAction));
#elif TARGET_CPU_X86_64
            __asm("leaq L_OBJC_CLASS_UIAlertAction(%%rip), %0" : "=r"(alertAction));
#elif TARGET_CPU_X86
            void *pc = NULL;
            __asm("calll L0\n"
                  "L0: popl %0\n"
                  "leal _OBJC_CLASS_UIAlertAction-L0(%0), %1" : "=r"(pc), "=r"(alertAction));
#else
#error Unsupported CPU
#endif
            
            if (alertAction && !*alertAction) {
                Class class = objc_allocateClassPair([WCAlertAction class], "UIAlertAction", 0);
                if (class) {
                    objc_registerClassPair(class);
                    *alertAction = class;
                }
            }
        }
    });
}
// ===========================================================================================================================