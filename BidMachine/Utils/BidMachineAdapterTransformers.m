//
//  BidMachineAdapterTransformers.m
//  BidMachine
//
//  Created by Stas Kochkin on 12/08/2019.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineAdapterTransformers.h"

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif


@implementation BidMachineAdapterTransformers

#pragma mark - Public

+ (BDMTargeting *)targetingFromExtraInfo:(NSDictionary *)extraInfo
                                location:(CLLocation *)location {
    BDMTargeting * targeting = [BDMTargeting new];
    if (location) {
        [targeting setDeviceLocation:location];
    }
    if (extraInfo) {
        NSString *userId = extraInfo[@"userId"] ?: extraInfo[@"user_id"];
        (!userId) ?: [targeting setUserId:userId];
        (!extraInfo[@"gender"]) ?: [targeting setGender:[self userGenderFromValue:extraInfo[@"gender"]]];
        (!extraInfo[@"yob"]) ?: [targeting setYearOfBirth:extraInfo[@"yob"]];
        (!extraInfo[@"keywords"]) ?: [targeting setKeywords:extraInfo[@"keywords"]];
        (!extraInfo[@"bcat"]) ?: [targeting setBlockedCategories:[extraInfo[@"bcat"] componentsSeparatedByString:@","]];
        (!extraInfo[@"badv"]) ?: [targeting setBlockedAdvertisers:[extraInfo[@"badv"] componentsSeparatedByString:@","]];
        (!extraInfo[@"bapps"]) ?: [targeting setBlockedApps:[extraInfo[@"bapps"] componentsSeparatedByString:@","]];
        (!extraInfo[@"country"]) ?: [targeting setCountry:extraInfo[@"country"]];
        (!extraInfo[@"city"]) ?: [targeting setCity:extraInfo[@"city"]];
        (!extraInfo[@"zip"]) ?: [targeting setZip:extraInfo[@"zip"]];
        (!extraInfo[@"sturl"]) ?: [targeting setStoreURL:[NSURL URLWithString:extraInfo[@"sturl"]]];
        (!extraInfo[@"stid"]) ?: [targeting setStoreId:extraInfo[@"stid"]];
        (!extraInfo[@"paid"]) ?: [targeting setPaid:[extraInfo[@"paid"] boolValue]];
    }
    return targeting;
}

+ (BDMUserRestrictions *)userRestrictionsFromExtraInfo:(NSDictionary *)extras {
    BDMUserRestrictions *restrictions = [BDMUserRestrictions new];
    [restrictions setHasConsent:MoPub.sharedInstance.canCollectPersonalInfo];
    [restrictions setSubjectToGDPR:self.subjectToGDPR];
    [restrictions setConsentString: extras[@"consent_string"]];
    [restrictions setCoppa:[extras[@"coppa"] boolValue]];
    return restrictions;
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

#pragma mark - Private

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

+ (BOOL)subjectToGDPR {
    MPBool isGDPRApplicable = MoPub.sharedInstance.isGDPRApplicable;
    switch (isGDPRApplicable) {
        case MPBoolYes: return YES; break;
        default:        return NO;  break;
    }
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
                    builder.appendAdUnit(fmt, params);
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
