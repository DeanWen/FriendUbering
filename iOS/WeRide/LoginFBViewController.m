//
//  LoginFBViewController.m
//  WeRide
//
//  Created by liuchang on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import "LoginFBViewController.h"

@interface LoginFBViewController ()

@end

@implementation LoginFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *btnImage = [UIImage imageNamed:@"login_icon"];
    [self.loginButton setImage:nil forState:UIControlStateNormal];
    [self.loginButton setImage:nil forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    [self.loginButton setTitle:@"" forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"] && [result.grantedPermissions containsObject:@"user_friends"]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            //NSLog(@"%@", [[FBSDKAccessToken currentAccessToken] tokenString]);
        }
    }];
}

@end
