//
//  BMMTransformer.h
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachine/BidMachine.h>
#import <BidMachine/BDMSdkConfiguration+HeaderBidding.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMMTransformer : NSObject

+ (BDMBannerAdSize)bannerSizeFromCGSize:(CGSize)size;

+ (BDMUserGender *)userGenderFromValue:(NSString *)gender;

+ (NSArray<BDMPriceFloor *> *)priceFloorsFromArray:(NSArray *)priceFloors;

+ (NSString *)sellerIdFromValue:(id)value;

+ (NSURL *)endpointUrlFromValue:(id)value;

+ (BDMFullscreenAdType)interstitialAdTypeFromString:(NSString *)string;

+ (NSArray <BDMAdNetworkConfiguration *> *)adNetworkConfigFromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
