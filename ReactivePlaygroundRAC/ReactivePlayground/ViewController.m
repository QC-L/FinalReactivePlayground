//
//  ViewController.m
//  ReactivePlayground
//
//  Created by QC.L on 16/1/8.
//  Copyright © 2016年 QC.L. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveManager.h"
#import "ReactiveCocoa.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIButton *signIn;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    // 看一遍Demo和自己手敲一遍的感觉是不一样的!
    RACSignal *validUsernameSignal =
    [self.userNameText.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    
    self.signInFailureLabel.hidden = YES;
    RACSignal *validPasswordSignal =
    [self.passWordText.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    

    RAC(self.userNameText, backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    RAC(self.passWordText, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signIn.enabled = [signupActive boolValue];
    }];
    
    
    [[[[self.signIn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
         self.signIn.enabled = NO;
         self.signInFailureLabel.hidden = YES;
    }] flattenMap:^id(id x) {
          return [self signInSignal];
    }] subscribeNext:^(NSNumber *signedIn) {
         self.signIn.enabled = YES;
         BOOL success = [signedIn boolValue];
         self.signInFailureLabel.hidden = success;
         if (success) {
             [self performSegueWithIdentifier:@"signInSuccess" sender:self];
         }
    }];

    
}





- (BOOL)isValidUsername:(NSString *)userName
{
    return userName.length > 6;
}

- (BOOL)isValidPassword:(NSString *)password
{
    return password.length > 6;
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ReactiveManager signInWithUsername:self.userNameText.text password:self.passWordText.text complete:^(BOOL success) {
             [subscriber sendNext:@(success)];
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
