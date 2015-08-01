//
//  myCell.h
//  WeRide
//
//  Created by Dian Wen on 7/31/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumnail;
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIImageView *seperator;

@end
