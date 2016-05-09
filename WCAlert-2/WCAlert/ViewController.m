//
//  ViewController.m
//  WCAlert
//
//  Created by lw on 16/4/27.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)alertAction:(id)sender;
- (IBAction)sheetAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}


- (IBAction)alertAction:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"alertView" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }]];
    // 在创建textfield的时候，iOS8之前最多创建
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"huhu";
        textField.secureTextEntry = YES;
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"tttt";
        
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"wwww";
    }];
    [self presentViewController:alertVC animated:YES completion:nil];

}

- (IBAction)sheetAction:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"actionSheet" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"UIAlertActionStyleCancel");
    }];
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"UIAlertActionStyleDestructive");
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"UIAlertActionStyleDefault");
    }];
    UIAlertAction *userAction = [UIAlertAction actionWithTitle:@"userAction" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"userAction");
    }];
    userAction.enabled = NO;
    [actionSheet addAction:defaultAction];
    [actionSheet addAction:destructiveAction];
    [actionSheet addAction:userAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];

}
@end
