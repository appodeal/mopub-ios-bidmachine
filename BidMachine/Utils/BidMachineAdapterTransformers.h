//
//  BidMachineAdapterTransformers.h
//  BidMachine
//
//  Created by Stas Kochkin on 12/08/2019.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<BidMachine/BidMachine.h>)
#import <BidMachine/BidMachine.h>
#import <BidMachine/BDMSdkConfiguration+HeaderBidding.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BidMachineAdapterTransformers : NSObject

+ (BDMTargeting *)targetingFromExtraInfo:(NSDictionary *)extraInfo
                                location:(CLLocation * _Nullable)location;
+ (BDMUserRestrictions *)userRestrictionsFromExtraInfo:(NSDictionary *)extras;
+ (NSArray<BDMPriceFloor *> *)priceFloorsFromArray:(NSArray *)priceFloors;
+ (NSString *)sellerIdFromValue:(id)value;
+ (NSURL *)endpointUrlFromValue:(id)value;
+ (BDMFullscreenAdType)interstitialAdTypeFromString:(NSString *)string;
+ (NSArray <BDMAdNetworkConfiguration *> *)adNetworkConfigFromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
