//
//  BidMachineFactory+HeaderBidding.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 7/30/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineFactory+HeaderBidding.h"

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif

#if __has_include(<BidMachine/BidMachine.h>)
#import <BidMachine/BidMachine.h>
#endif


BDMAdUnitFormat BDMAdUnitFormatFromString(NSString *fmt) {
    if ([fmt isEqualToString:@"banner"]) {
        return BDMAdUnitFormatInLineBanner;
    } else if ([fmt isEqualToString:@"interstitial_video"]) {
        return BDMAdUnitFormatInterstitialVideo;
    } else if ([fmt isEqualToString:@"interstitial_static"]) {
        return BDMAdUnitFormatInterstitialStatic;
    } else if ([fmt isEqualToString:@"interstitial"]) {
        return BDMAdUnitFormatInterstitialUnknown;
    } else if ([fmt isEqualToString:@"rewarded_video"]) {
        return BDMAdUnitFormatRewardedVideo;
    } else if ([fmt isEqualToString:@"rewarded_static"]) {
        return BDMAdUnitFormatRewardedPlayable;
    } else if ([fmt isEqualToString:@"rewarded"]) {
        return BDMAdUnitFormatRewardedUnknown;
    }
    return BDMAdUnitFormatUnknown;
}

@implementation BidMachineFactory (HeaderBidding)

- (NSArray<BDMAdNetworkConfiguration *> *)adNetworkConfigFromDict:(NSDictionary<NSString *, id> *)dict {
    NSArray<NSDictionary *> *mediationConfig = dict[@"mediation_config"];
    NSMutableArray<BDMAdNetworkConfiguration *> *networkConfigurations = [NSMutableArray new];
    
    [mediationConfig enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [networkConfigurations addObject:[self adNetworkConfig:obj]];
    }];
    
    return networkConfigurations;
}

- (BDMAdNetworkConfiguration *)adNetworkConfig:(NSDictionary *)dict {
    NSString *networkName = dict[@"network"];
    Class<BDMNetwork> adNetworkClass = NSClassFromString(dict[@"network_class"]);
    NSArray<NSDictionary *> *adUnits = dict[@"ad_units"];
    NSMutableDictionary<NSString *, id> *units = [NSMutableDictionary new];
    
    [adUnits enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *format = obj[@"format"];
        if (format) {
            units[format] = obj;
        }
    }];
    
    return [BDMAdNetworkConfigurationBuilder buildWithBuilder:^(BDMAdNetworkConfigurationBuilder * _Nonnull builder) {
        builder
        .appendName(networkName)
        .appendNetworkClass(adNetworkClass)
        .appendInitializationParams(dict);
        [units enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            builder.appendAdUnit(BDMAdUnitFormatFromString(key), obj);
        }];
    }];
}

@end
