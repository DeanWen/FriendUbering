//
//  ViewController.h
//  GetOff
//
//  Created by Arthur on 7/28/15.
//  Copyright (c) 2015 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPSMTPMessage.h"
#import "UberKit.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UberKitDelegate>
@property (weak, nonatomic) IBOutlet UIButton *complete;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (nonatomic, retain) UberKit *uberkit;
@property (nonatomic, retain) NSString *receipt;

- (IBAction)send:(id)sender;
- (IBAction)finishTrip:(id)sender;
@end

