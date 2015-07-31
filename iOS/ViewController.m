//
//  ViewController.m
//  Bill
//
//  Created by Arthur on 7/28/15.
//  Copyright (c) 2015 Arthur. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray *names;
    NSMutableArray *emails;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [[UberKit sharedInstance] setClientID:@"TRoQcMg6E3QrqVzNTt6-tjoGcIIJq7FU"];
    [[UberKit sharedInstance] setClientSecret:@"5gz7mKnnU9XxeuH-3yVYHGpestBWzhhdnhkaieOU"];
    [[UberKit sharedInstance] setRedirectURL:@"weride://response"];
    [[UberKit sharedInstance] setApplicationName:@"WERIDE"];
    _uberkit = [UberKit sharedInstance];
    _uberkit.delegate = self;
    
    [_amount setText:@"$0.00"];
    [_amount setEnabled:NO];
    _holder = nil;
    _holder_email = nil;
    
    [super viewDidLoad];
    

//    names = [[NSMutableArray alloc] init];
//    emails = [[NSMutableArray alloc] init];
//    
//    
//    
//    // Do any additional setup after loading the view, typically from a nib.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    // get documents path
//    NSString *documentsPath = [paths objectAtIndex:0];
//    NSLog(@"%@", documentsPath);
//    // get the path to our Data/plist file
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
//        plistPath = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
//    }
//    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    for(id key in plistDict) {
//        id value = [plistDict objectForKey:key];
//        [emails addObject:key];
//        [names addObject:[value objectForKey:@"name"]];
//    }
//    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}
- (void)viewWillAppear:(BOOL)animated{
    names = [[NSMutableArray alloc] init];
    emails = [[NSMutableArray alloc] init];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    NSLog(@"%@", documentsPath);
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
    }
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    for(id key in plistDict) {
        id value = [plistDict objectForKey:key];
        [emails addObject:key];
        [names addObject:[value objectForKey:@"name"]];
    }
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma Uber
- (void) callCientAuthenticationMethods {
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"vTvzxqyFRw-NTGxgIeQjHcVCm27TVlAJrH96rcvp"]; //Add your server token
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:37.9 longitude:-122.43];
    
    [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             NSLog(@"Product name of first %@", product.product_description);
             NSLog(@"Product id %@", product.product_id);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getTimeForProductArrivalWithLocation:location withCompletionHandler:^(NSArray *times, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberTime *time = [times objectAtIndex:0];
             NSLog(@"Time for first %f", time.estimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPriceForTripWithStartLocation:location endLocation:endLocation  withCompletionHandler:^(NSArray *prices, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberPrice *price = [prices objectAtIndex:0];
             NSLog(@"Price for first %i", price.lowEstimate);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
    
    [uberKit getPromotionForLocation:location endLocation:endLocation withCompletionHandler:^(UberPromotion *promotion, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             NSLog(@"Promotion - %@", promotion.localized_value);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}

- (IBAction)finishTrip:(id)sender {
    [_uberkit startLogin];
}

- (void) uberKit:(UberKit *)uberKit didReceiveAccessToken:(NSString *)accessToken {
    NSLog(@"Received access token %@", accessToken);
    if(accessToken) {
        [uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
         {
             if(!error) {
                 NSLog(@"User activity %@", activities);
                 
                 if (activities.count != 0) {
                     UberActivity *activity = [activities objectAtIndex:0];
                     NSLog(@"Last trip distance %f", activity.distance);
                     NSLog(@"receipt id is %@", activity.uiud);
                     _receipt = activity.uiud;
                     
                     [uberKit getuserLastReceipt:activity.uiud withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
                         if (!error) {
                             NSString *bill = [resultsArray objectAtIndex:0];
                             NSLog(@"Last Trip totally costs : %@", bill);
                             //[_amount setText: bill];
                             [_amount performSelectorOnMainThread:@selector(setText:) withObject:bill waitUntilDone:NO];
                         }else {
                             NSLog(@"Error %@", error);
                         }
                     }];
                 }else {
                     NSLog(@"empty activities");
                 }
                 
             }
             else {
                 NSLog(@"Error %@", error);
             }
         }];
        [uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
         {
             if(!error) {
                 //NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
                 _holder = [NSString stringWithFormat:@"%@ %@", profile.first_name, profile.last_name];
                 _holder_email = profile.email;
                 NSLog(@"%@, %@", _holder, _holder_email);
             }else{
                 NSLog(@"Error %@", error);
             }
         }];
    }else {
        NSLog(@"No auth token, try again");
    }
}


- (void) uberKit:(UberKit *)uberKit loginFailedWithError:(NSError *)error {
    NSLog(@"Error in login %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma send Email
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"table_cell";
    
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"table_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [names objectAtIndex:indexPath.row];
    cell.email.text = [emails objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)start:(id)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *cur_time = [df stringFromDate:now];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
    }
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *rs = [[NSMutableDictionary alloc]init];
    for(id key in plistDict) {
        NSLog(@"%@", key);
        NSDictionary *innerDict = [plistDict objectForKey:key];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        [newDict setObject:[innerDict objectForKey:@"name"] forKey:@"name"];
        [newDict setObject:cur_time forKey:@"start_time"];
        [newDict setObject:[innerDict objectForKey:@"end_time"] forKey:@"end_time"];
        [rs setObject:newDict forKey:key];
    }
    [rs writeToFile:plistPath atomically: TRUE];
    _startButton.enabled = NO;
}

- (IBAction)send:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
    }
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm:ss"];
    double total_seconds = 0;
    for(id key in plistDict) {
        NSDictionary *innerDict = [plistDict objectForKey:key];
        NSString *cur_starttime = [innerDict objectForKey:@"start_time"];
        NSString *cur_endtime = [innerDict objectForKey:@"end_time"];
        NSDate *new_starttime = [df dateFromString:cur_starttime];
        NSDate *new_endtime = [df dateFromString:cur_endtime];
        NSTimeInterval interval = [new_endtime timeIntervalSinceDate:new_starttime];
        total_seconds += interval;
    }
    NSLog(@"total seconds: %f", total_seconds);
    
    for(id key in plistDict) {
        if([key isEqualToString: _holder_email]) {
            continue;
        }
        
        NSDictionary *innerDict = [plistDict objectForKey:key];
        NSString *cur_starttime = [innerDict objectForKey:@"start_time"];
        NSString *cur_endtime = [innerDict objectForKey:@"end_time"];
        NSDate *new_starttime = [df dateFromString:cur_starttime];
        NSDate *new_endtime = [df dateFromString:cur_endtime];
        NSTimeInterval interval = [new_endtime timeIntervalSinceDate:new_starttime];
        NSLog(@"here is interval : %f", interval);
        
        NSString *substring = [_amount.text substringFromIndex:1];
        double price = (double)(interval / total_seconds) *  [substring doubleValue];
        NSLog(@"%@", substring);
        NSLog(@"%f", [substring doubleValue]);
        NSLog(@"%f", price);
        NSLog(@"Start Sending");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"sample.pdf"];
        
        
        
        NSData *dataObj = [NSData dataWithContentsOfFile:writableDBPath];
        
        SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
        
        testMsg.fromEmail = @"chanliu524@gmail.com";//nimit51parekh@gmail.com
        
        testMsg.toEmail = key;//sender mail id
        
        testMsg.relayHost = @"smtp.gmail.com";
        
        testMsg.requiresAuth = YES;
        
        testMsg.login = @"chanliu524@gmail.com";
        
        testMsg.pass = @"a1234567!";
        
        testMsg.subject = @"Please pay bill - From WeRide Application";
        
        testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
        
        // Only do this for self-signed certs!
        
        // testMsg.validateSSLChain = NO;
        
        testMsg.delegate = self;
        
        NSString *content = [NSString stringWithFormat:@"Please pay your bill($%.2f) to %@(%@).", price, _holder, _holder_email];
        
        NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                                   
                                   content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
        //Logic for attach file.
        
        //	NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"sample.pdf\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"sample.pdf\"",kSKPSMTPPartContentDispositionKey,[dataObj encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        //    NSLog(@"%@",vcfPart);
        //	testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
        
        
        //    testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
        
        testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
        
        [testMsg send];
    }
}

-(void)messageSent:(SKPSMTPMessage *)message{
//    [message release];
    NSLog(@"delegate - message sent");
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
//    [message release];
    // open an alert with just an OK button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
//    [alert release];
    NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
}

@end
