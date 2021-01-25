//
//  AppDelegate.m
//  BMIntegrationSample
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"

#import <mopub-ios-sdk/MoPub.h>
#import <BidMachine/BidMachine.h>
#import <BidMachine/BDMExternalAdapterConfiguration.h>

#define NATIVE_APP_ID         "7c3f8de23b9d4b7ab45a53ed2c3cb0c8"
#define FULLSCREEN_APP_ID     "1832ce06de91424f8f81f9f5c77f7efd"
#define BANNER_APP_ID         "1832ce06de91424f8f81f9f5c77f7efd"


@interface AppDelegate ()

@end

@implementation AppDelegate

+ (NSDictionary *)localExtras {
    NSDictionary *localExtras = @{};
    
//    For Example
//    <--------------------------------------------------->
//    BDMExternalAdapterConfiguration *config = BDMExternalAdapterConfiguration.new;
//    config.restriction = BDMUserRestrictions.new;
//    config.sdkConfiguration = BDMSdkConfiguration.new;
//    config.sdkConfiguration.targeting = BDMTargeting.new;
//
//    config.sellerId = @"1";
//    config.restriction.coppa = YES;
//    config.restriction.consentString = @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA";
//    config.sdkConfiguration.testMode = YES;
//    config.priceFloor = @[({
//        BDMPriceFloor *price = [BDMPriceFloor new];
//        price.ID = NSUUID.UUID.UUIDString.lowercaseString;
//        price.value = [NSDecimalNumber decimalNumberWithDecimal:[@0.01f decimalValue]];
//        price;
//    })];
//    NSDictionary *localExtras = config.jsonConfiguration;
//    <--------------------------------------------------->
//    Or You can use dictionary with supported keys
//    NSDictionary *localExtras = @{
//        kBDMExtSellerKey: @"1",
//        kBDMExtCoppaKey: @"true",
//        kBDMExtConsentStringKey: @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
//        kBDMExtBaseURLKey : @"some_url_endpoint",
//        kBDMExtLoggingKey: @"true",
//        kBDMExtTestModeKey: @"true",
//        kBDMExtWidthKey: @"320",
//        kBDMExtUserIdKey: @"user123",
//        kBDMExtGenderKey: @"F",
//        kBDMExtYearOfBirthKey: @2000,
//        kBDMExtKeywordsKey: @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
//        kBDMExtCountryKey: @"USA",
//        kBDMExtCityKey: @"Los Angeles",
//        kBDMExtZipKey: @"90001–90084",
//        kBDMExtStoreUrlKey: @"https://store_url.com",
//        kBDMExtStoreIdKey: @"342342",
//        kBDMExtPaidKey: @"true",
//        kBDMExtBCatKey: @"IAB-1,IAB-3,IAB-5",
//        kBDMExtBAdvKey: @"https://domain_1.com,https://domain_2.org",
//        kBDMExtBAppKey: @"com.test.application_1,com.test.application_2,com.test.application_3",
//        kBDMExtFrameworkNameKey: @"native",
//        kBDMExtPriceFloorKey: @[
//                @{ @"id_1": @300.06 },
//                @{ @"id_2": @1000 },
//                @302.006,
//                @1002
//        ]
//    };

    return localExtras;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:@FULLSCREEN_APP_ID];
    [sdkConfig setNetworkConfiguration:self.bidMachineConfiguration forMediationAdapter:@"BidMachineAdapterConfiguration"];
    sdkConfig.additionalNetworks = @[ NSClassFromString(@"BidMachineAdapterConfiguration") ];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
    
    return YES;
}

- (NSDictionary <NSString *, id> *)bidMachineConfiguration {
    return @{
             kBDMExtTestModeKey : @"true",
             kBDMExtLoggingKey : @"true"
             };
}

@end
