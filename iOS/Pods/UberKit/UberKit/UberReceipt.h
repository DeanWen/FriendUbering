//
//  UberReceipt.h
//  Pods
//
//  Created by Dian Wen on 7/25/15.
//
//

#import <Foundation/Foundation.h>

@interface UberReceipt : NSObject


@property (nonatomic) NSString* request_id;
@property (nonatomic) NSString* normal_fare;
@property (nonatomic) NSString* subtotal;
@property (nonatomic) NSString* total_charged;
@property (nonatomic) NSString* total_owed;
@property (nonatomic) NSString *currency_code;
@property (nonatomic) NSString *duration;
@property (nonatomic) NSString *distance;
@property (nonatomic) NSString *distance_label;


- (instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
