//
//  ViewController.m
//  UberKitDemo
//
//  Created by Sachin Kesiraju on 8/21/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UberKit *uberKit = [[UberKit alloc] initWithServerToken:@"VtKADLGcQGK4Fc6ZxEY7YEZ0B7xS26Lq0a4ktL9o"]; //Add your server token
    //[[UberKit sharedInstance] setServerToken:@"YOUR_SERVER_TOKEN"]; //Alternate initialization
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:37.9 longitude:-122.43];
    
    [uberKit getProductsForLocation:location withCompletionHandler:^(NSArray *products, NSURLResponse *response, NSError *error)
     {
         if(!error)
         {
             UberProduct *product = [products objectAtIndex:0];
             NSLog(@"Product name of first %@", product.product_description);
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

- (IBAction)login:(id)sender
{
    UberKit *uberKit = [[UberKit alloc] initWithClientID:@"_oSY_jelMPLdNnuwBuDsXc01ZVR8Vszp" ClientSecret:@"gO2C6XnB5VSn5CVh49DO4ReqDnu-odKzZ55sxHIP" RedirectURL:@"serenjoy://response" ApplicationName:@"SerenJoy"]; // Alternate initialization
    uberKit.delegate = self;
    [uberKit startLoginWithViewController:self];
}

- (void) uberKit:(UberKit *)uberKit didReceiveAccessToken:(NSString *)accessToken
{
    NSLog(@"Received access token %@", accessToken);
    if(accessToken)
    {
        [uberKit getUserActivityWithCompletionHandler:^(NSArray *activities, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User activity %@", activities);
                 UberActivity *activity = [activities objectAtIndex:0];
                 NSLog(@"Last trip distance %f", activity.distance);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
        
        [uberKit getUserProfileWithCompletionHandler:^(UberProfile *profile, NSURLResponse *response, NSError *error)
         {
             if(!error)
             {
                 NSLog(@"User's full name %@ %@", profile.first_name, profile.last_name);
             }
             else
             {
                 NSLog(@"Error %@", error);
             }
         }];
    }
    else
    {
        NSLog(@"No auth token, try again");
    }
}

- (void) uberKit:(UberKit *)uberKit loginFailedWithError:(NSError *)error
{
    NSLog(@"Error in login %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
