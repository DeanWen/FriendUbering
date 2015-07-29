//
//  MyTableViewCell.h
//  GetOff
//
//  Created by Arthur on 7/28/15.
//  Copyright (c) 2015 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIButton *getOffButton;
- (IBAction)getOff:(id)sender;
@end
