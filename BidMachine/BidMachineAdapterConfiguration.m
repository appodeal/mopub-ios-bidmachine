//
//  BidMachineAdapterConfiguration.m
//  BidMachineAdapterConfiguration
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachineAdapterConfiguration. All rights reserved.
//

#import "BidMachineAdapterConfiguration.h"
#import "BidMachineConstants.h"
#import "BidMachineFactory.h"
#import "BidMachineFactory+HeaderBidding.h"
#import <BidMachine/BDMAdNetworkConfiguration.h>


@implementation BidMachineAdapterConfiguration

#pragma mark - MPAdapterConfiguration

- (NSString *)adapterVersion {
    return @"1.3.0.0";
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
                                  complete:(void (^)(NSError *))complete {
    NSString *sellerId = [[BidMachineFactory sharedFactory] transfromSellerID:configuration[kBidMachineSellerId]];
    NSURL *endpointURL = [[BidMachineFactory sharedFactory] transformEndpointURL:configuration[@"endpoint"]];
    BOOL testModeEnabled = [configuration[kBidMachineTestMode] boolValue];
    BOOL loggingEnabled = [configuration[kBidMachineLoggingEnabled] boolValue];
    if (sellerId) {
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        config.networkConfigurations = [[BidMachineFactory sharedFactory] adNetworkConfigFromDict:configuration];
        [config setTestMode:testModeEnabled];
        [config setBaseURL:endpointURL];
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:sellerId configuration:config completion:^{
            MPLogInfo(@"BidMachine SDK was successfully initialized!");
            if (complete) {
                complete(nil);
            }
        }];
    } else {
        NSError * error = [NSError errorWithDomain:kAdapterErrorDomain
                                              code:BidMachineAdapterErrorCodeMissingSellerId
                                          userInfo:@{ NSLocalizedDescriptionKey: @"BidMachine's initialization skipped. The sellerId is empty. Ensure it is properly configured on the MoPub dashboard."} ];
        MPLogEvent([MPLogEvent error:error message:nil]);
        if (complete) {
            complete(error);
        }
    }
}

+ (void)updateInitializationParameters:(NSDictionary *)parameters {
    NSString * sellerId = parameters[kBidMachineSellerId];
    if (sellerId) {
        NSDictionary * configuration = @{ kBidMachineSellerId: sellerId };
        [BidMachineAdapterConfiguration setCachedInitializationParameters:configuration];
    }
}

@end
