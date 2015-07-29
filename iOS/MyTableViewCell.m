//
//  MyTableViewCell.m
//  GetOff
//
//  Created by Arthur on 7/28/15.
//  Copyright (c) 2015 Arthur. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
@synthesize name = _name;
@synthesize email = _email;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)getOff:(id)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *cur_time = [df stringFromDate:now];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
    }
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *innerDict = [plistDict objectForKey:_email.text];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    [newDict setObject:[innerDict objectForKey:@"name"] forKey:@"name"];
    [newDict setObject:[innerDict objectForKey:@"start_time"] forKey:@"start_time"];
    [newDict setObject:cur_time forKey:@"end_time"];
    [plistDict removeObjectForKey:_email.text];
    [plistDict setObject:newDict forKey:_email.text];
    // This writes the array to a plist file. If this file does not already exist, it creates a new one.
    [plistDict writeToFile:plistPath atomically: TRUE];
    
    NSMutableDictionary *oldDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *rs = [[NSMutableDictionary alloc]init];
    for(id key in oldDict) {
        NSDictionary *innerDict = [oldDict objectForKey:key];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict setObject:[innerDict objectForKey:@"name"] forKey:@"name"];
        if([[innerDict objectForKey:@"end_time"] isEqualToString: @"dummy"]) {
            [newDict setObject:cur_time forKey:@"start_time"];
        } else {
            [newDict setObject:[innerDict objectForKey:@"start_time"] forKey:@"start_time"];
        }
        [newDict setObject:[innerDict objectForKey:@"end_time"] forKey:@"end_time"];
        [rs setObject:newDict forKey:key];
    }
    [rs writeToFile:plistPath atomically: TRUE];
    
    _getOffButton.enabled = NO;
}
@end
