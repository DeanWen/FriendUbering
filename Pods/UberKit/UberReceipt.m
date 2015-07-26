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
        _normal_fare = [[dictionary objectForKey:@"normal_fare"] floatValue];
        _subtotal = [[dictionary objectForKey:@"subtotal"] floatValue];
        _total_charged = [[dictionary objectForKey:@"_total_charged"] floatValue];
        _total_owed = [[dictionary objectForKey:@"_total_owed"] floatValue];
        _currency_code = [dictionary objectForKey:@"_currency_code"];
        _duration = [dictionary objectForKey:@"_duration"];
        _distance = [dictionary objectForKey:@"_distance"];
        _distance_label =[dictionary objectForKey:@"_distance_label"];
    }
    return self;
}

@end