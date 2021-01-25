//
//  BidMachineAdapterConfiguration.m
//  BidMachineAdapterConfiguration
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachineAdapterConfiguration. All rights reserved.
//

#import "BidMachineAdapterConfiguration.h"

@implementation BidMachineMopubFetcher

- (void)registerPresset {
    [BDMFetcher.shared registerPresset:self];
}

@end

@implementation BidMachineAdapterConfiguration

#pragma mark - MPAdapterConfiguration

- (NSString *)adapterVersion {
    return @"1.7.0.0";
}

- (NSString *)biddingToken {
    return nil;
}

- (NSString *)moPubNetworkName {
    return @"bidmachine";
}

- (NSString *)networkSdkVersion {
    return kBDMVersion;
}

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *,id> *)configuration
                                  complete:(void (^)(NSError * _Nullable))complete
{
    BDMExternalAdapterConfiguration *config = [BDMExternalAdapterConfiguration configurationWithJSON:configuration];
    [self.class initializeBidMachineSDKWithConfig:config completion:^(NSError *error) {
        error ?
            MPLogEvent([MPLogEvent error:error message:nil]) :
            MPLogInfo(@"BidMachine SDK was successfully initialized!");
        
        complete ? complete(error) : nil;
    }];
}

+ (void)initializeBidMachineSDKWithConfig:(BDMExternalAdapterConfiguration *)config
                               completion:(void (^)(NSError *))completion
{
    BDMSdk *sdk = [BDMSdk sharedSdk];
    [self sdk:sdk updateConfiguration:config];
    
    if ([sdk isInitialized]) {
        STK_RUN_BLOCK(completion, nil);
        return;
    }
    
    if (!NSString.stk_isValid(config.sellerId)) {
        NSError *error = [STKError errorWithDescription:@"The sellerId is nil or not valid string"];
        STK_RUN_BLOCK(completion, error);
        return;
    }
    
    [sdk startSessionWithSellerID:config.sellerId
                    configuration:config.sdkConfiguration
                       completion:^{ STK_RUN_BLOCK(completion, nil); }];
}

+ (void)sdk:(BDMSdk *)sdk updateConfiguration:(BDMExternalAdapterConfiguration *)config {
    sdk.enableLogging = config.logging;
    sdk.publisherInfo = config.publisherInfo;
    
    sdk.restrictions.hasConsent = config.restriction.hasConsent;
    sdk.restrictions.subjectToGDPR = config.restriction.subjectToGDPR;
    sdk.restrictions.consentString = config.restriction.consentString;
    sdk.restrictions.coppa = config.restriction.coppa;
    
    sdk.configuration.targeting = config.sdkConfiguration.targeting;
}

@end
