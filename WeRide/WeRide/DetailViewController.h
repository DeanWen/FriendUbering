//
//  DetailViewController.h
//  WeRide
//
//  Created by Dian Wen on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

