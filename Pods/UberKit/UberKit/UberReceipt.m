//
//  UberReceipt.m
//  Pods
//
//  Created by Dian Wen on 7/25/15.
//
//

#import "UberReceipt.h"

@implementation UberReceipt

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _request_id = [dictionary objectForKey:@"request_id"];
        _normal_fare = [dictionary objectForKey:@"normal_fare"];
        _subtotal = [dictionary objectForKey:@"subtotal"];
        _total_charged = [dictionary objectForKey:@"total_charged"];
        _total_owed = [dictionary objectForKey:@"total_owed"];
        _currency_code = [dictionary objectForKey:@"currency_code"];
        _duration = [dictionary objectForKey:@"duration"];
        _distance = [dictionary objectForKey:@"distance"];
        _distance_label =[dictionary objectForKey:@"distance_label"];
    }
    return self;
}

@end