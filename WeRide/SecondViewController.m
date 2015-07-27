//
//  SecondViewController.m
//  WeRide
//
//  Created by Dian Wen on 7/24/15.
//  Copyright (c) 2015 Dian Wen. All rights reserved.
//

#import "SecondViewController.h"
#import "UberKit.h"


@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    _receiptID = nil;
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
    _textField.text = nil;
    [super viewDidLoad];
    [self callCientAuthenticationMethods];
}

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

-(IBAction)start:(id)sender {
    [_uberkit openUberApp];
}
- (IBAction)login:(id)sender {
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
                     _receiptID = activity.uiud;
                     NSLog(@"receipt id is %@", _receiptID);
                     
                     [uberKit getuserLastReceipt:_receiptID withCompletionHandler:^(NSArray *resultsArray, NSURLResponse *response, NSError *error) {
                         if (!error) {
                             NSLog(@"Last Trip totally costs : %@", [resultsArray objectAtIndex:0]);
                             [_textField setText:[resultsArray objectAtIndex:0]];
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
                 NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
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

@end