//
//  BidMachineFactory.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineFactory.h"
#import "BidMachineConstants.h"
#import "BidMachineFactory+HeaderBidding.h"


#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif


@interface BidMachineFactory()

@property (nonatomic, copy) NSString *currentSellerId;

@end

@implementation BidMachineFactory

+ (instancetype)sharedFactory {
    static BidMachineFactory * _sharedFactory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFactory = BidMachineFactory.new;
    });
    return _sharedFactory;
}

- (void)initializeBidMachineSDKWithCustomEventInfo:(NSDictionary *)info
                                        completion:(void(^)(void))completion {
    NSString *sellerID = [self transfromSellerID:info[kBidMachineSellerId]];
    if ([sellerID isKindOfClass:NSString.class] &&
        ![self.currentSellerId isEqualToString:sellerID]) {
        self.currentSellerId = sellerID;
        
        BOOL testModeEnabled = [info[kBidMachineTestMode] boolValue];
        BOOL loggingEnabled = [info[kBidMachineLoggingEnabled] boolValue];
        
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        config.networkConfigurations = [[BidMachineFactory sharedFactory] adNetworkConfigFromDict:info];
        [config setTestMode:testModeEnabled];
        
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:self.currentSellerId
                                       configuration:config
                                          completion:completion];
    } else {
        completion ? completion() : nil;
    }
}

- (BDMTargeting *)setupTargetingWithExtraInfo:(NSDictionary *)extraInfo andLocation:(CLLocation *)location{
    BDMTargeting * targeting = [BDMTargeting new];
    if (location) {
        [targeting setDeviceLocation:location];
    }
    if (extraInfo) {
        NSString *userId = extraInfo[@"userId"] ?: extraInfo[@"user_id"];
        (!userId) ?: [targeting setUserId:(NSString *)extraInfo[@"userId"]];
        (!extraInfo[@"gender"]) ?: [targeting setGender:[self userGenderSetting:extraInfo[@"gender"]]];
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

- (NSArray<BDMPriceFloor *> *)makePriceFloorsWithPriceFloors:(NSArray *)priceFloors {
    NSMutableArray<BDMPriceFloor *> *priceFloorsArr = [NSMutableArray new];
    [priceFloors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSDictionary.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSDictionary *object = (NSDictionary *)obj;
            [priceFloor setID: object.allKeys[0]];
            [priceFloor setValue: object.allValues[0]];
            [priceFloorsArr addObject:priceFloor];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSNumber *object = (NSNumber *)obj;
            [priceFloor setID:NSUUID.UUID.UUIDString.lowercaseString];
            [priceFloor setValue:[NSDecimalNumber decimalNumberWithDecimal:object.decimalValue]];
            [priceFloorsArr addObject:priceFloor];
        }
        if (idx == [priceFloors count] - 1) {
            *stop = YES;
        }
    }];
    return priceFloorsArr;
}

- (BDMUserGender *)userGenderSetting:(NSString *)gender {
    BDMUserGender *userGender;
    if ([gender isEqualToString:@"F"]) {
        userGender = kBDMUserGenderFemale;
    } else if ([gender isEqualToString:@"M"]) {
        userGender = kBDMUserGenderMale;
    } else if ([gender isEqualToString:@"O"]) {
        userGender = kBDMUserGenderUnknown;
    }
    return userGender;
}

- (NSString *)transfromSellerID:(id)sellerId {
    NSString *stringSellerId;
    if ([sellerId isKindOfClass:NSString.class] && [sellerId integerValue]) {
        stringSellerId = sellerId;
    } else if ([sellerId isKindOfClass:NSNumber.class]) {
        stringSellerId = [sellerId stringValue];
    }
    return stringSellerId;
}

@end
