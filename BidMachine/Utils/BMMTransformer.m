//
//  BMMTransformer.m
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMTransformer.h"

@implementation BMMTransformer

+ (BDMBannerAdSize)bannerSizeFromCGSize:(CGSize)size {
    BDMBannerAdSize bannerAdSize;
    switch ((int)size.width) {
        case 300: bannerAdSize = BDMBannerAdSize300x250;  break;
        case 728: bannerAdSize = BDMBannerAdSize728x90;   break;
        default: bannerAdSize = BDMBannerAdSize320x50;   break;
    }
    return bannerAdSize;
}

+ (BDMUserGender *)userGenderFromValue:(NSString *)gender {
    BDMUserGender *userGender;
    if ([gender isEqualToString:@"F"]) {
        userGender = kBDMUserGenderFemale;
    } else if ([gender isEqualToString:@"M"]) {
        userGender = kBDMUserGenderMale;
    } else {
        userGender = kBDMUserGenderUnknown;
    }
    return userGender;
}

+ (NSArray<BDMPriceFloor *> *)priceFloorsFromArray:(NSArray *)priceFloors {
    NSMutableArray <BDMPriceFloor *> *priceFloorsArr = [NSMutableArray new];
    [priceFloors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSDictionary.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSDictionary *object = (NSDictionary *)obj;
            [priceFloor setID: object.allKeys[0]];
            [priceFloor setValue: object.allValues[0]];
            [priceFloorsArr addObject:priceFloor];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSNumber *value = (NSNumber *)obj;
            NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithDecimal:value.decimalValue];
            [priceFloor setID:NSUUID.UUID.UUIDString.lowercaseString];
            [priceFloor setValue:decimalValue];
            [priceFloorsArr addObject:priceFloor];
        }
    }];
    return priceFloorsArr;
}

+ (NSURL *)endpointUrlFromValue:(id)value {
    NSURL *endpointURL;
    if ([value isKindOfClass:NSURL.class]) {
        endpointURL = value;
    } else if ([value isKindOfClass:NSString.class]) {
        endpointURL = [NSURL URLWithString:value];
    }
    return endpointURL;
}

+ (NSString *)sellerIdFromValue:(id)value {
    NSString *sellerId;
    if ([value isKindOfClass:NSString.class] && [value integerValue]) {
        sellerId = value;
    } else if ([value isKindOfClass:NSNumber.class]) {
        sellerId = [value stringValue];
    }
    return sellerId;
}

+ (BDMFullscreenAdType)interstitialAdTypeFromString:(NSString *)string {
    BDMFullscreenAdType type;
    NSString *lowercasedString = [string lowercaseString];
    if ([lowercasedString isEqualToString:@"all"]) {
        type = BDMFullscreenAdTypeAll;
    } else if ([lowercasedString isEqualToString:@"video"]) {
        type = BDMFullscreenAdTypeVideo;
    } else if ([lowercasedString isEqualToString:@"static"]) {
        type = BDMFullsreenAdTypeBanner;
    } else {
        type = BDMFullscreenAdTypeAll;
    }
    return type;
}

+ (NSArray<BDMAdNetworkConfiguration *> *)adNetworkConfigFromDict:(NSDictionary *)dict {
    NSArray<NSDictionary *> *mediationConfig = dict[@"mediation_config"];
    NSMutableArray<BDMAdNetworkConfiguration *> *networkConfigurations = [NSMutableArray new];
    
    [mediationConfig enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger idx, BOOL *stop) {
        BDMAdNetworkConfiguration *config = [self adNetworkConfig:data];
        if (config) {
            [networkConfigurations addObject:config];
        }
    }];
    
    return networkConfigurations;
}

+ (BDMAdNetworkConfiguration *)adNetworkConfig:(NSDictionary *)dict {
    return [BDMAdNetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
        // Append network name
        if ([dict[@"network"] isKindOfClass:NSString.class]) {
            builder.appendName(dict[@"network"]);
        }
        // Append network class
        if ([dict[@"network_class"] isKindOfClass:NSString.class]) {
            builder.appendNetworkClass(NSClassFromString(dict[@"network_class"]));
        }
        // Append ad units
        NSArray <NSDictionary *> *adUnits = dict[@"ad_units"];
        if ([adUnits isKindOfClass:NSArray.class]) {
            [adUnits enumerateObjectsUsingBlock:^(NSDictionary *adUnit, NSUInteger idx, BOOL *stop) {
                if ([adUnit isKindOfClass:NSDictionary.class]) {
                    BDMAdUnitFormat fmt = [adUnit[@"format"] isKindOfClass:NSString.class] ?
                    BDMAdUnitFormatFromString(adUnit[@"format"]) :
                    BDMAdUnitFormatUnknown;
                    NSMutableDictionary *params = adUnit.mutableCopy;
                    [params removeObjectForKey:@"format"];
                    builder.appendAdUnit(fmt, params, nil);
                }
            }];
        }
        // Append init params
        NSMutableDictionary <NSString *, id> *customParams = dict.mutableCopy;
        [customParams removeObjectsForKeys:@[
                                             @"network",
                                             @"network_class",
                                             @"ad_units"
                                             ]];
        if (customParams.count) {
            builder.appendInitializationParams(customParams);
        }
    }];
}

@end
