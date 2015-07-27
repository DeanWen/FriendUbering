//
//  LoginFBViewController.h
//  WeRide
//
//  Created by liuchang on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginFBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButton:(id)sender;

@end
