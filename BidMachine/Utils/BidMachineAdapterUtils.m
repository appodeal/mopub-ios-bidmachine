//
//  BidMachineAdapterUtils.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineAdapterUtils.h"
#import "BidMachineConstants.h"
#import "BidMachineAdapterTransformers.h"

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif


@interface BidMachineAdapterUtils ()

@end


@implementation BidMachineAdapterUtils

+ (instancetype)sharedUtils {
    static BidMachineAdapterUtils * _sharedFactory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFactory = BidMachineAdapterUtils.new;
    });
    return _sharedFactory;
}

- (void)initializeBidMachineSDKWithCustomEventInfo:(NSDictionary *)info
                                        completion:(void(^)(NSError *))completion {
    NSString *sellerID = [BidMachineAdapterTransformers sellerIdFromValue:info[kBidMachineSellerId]];
    if (![sellerID isKindOfClass:NSString.class]) {
        NSDictionary *userInfo =
        @{
          NSLocalizedFailureReasonErrorKey: @"BidMachine's initialization skipped",
          NSLocalizedDescriptionKey: @"The sellerId is nil or not valid string",
          NSLocalizedRecoverySuggestionErrorKey: @"Ensure it is properly configured on the MoPub dashboard."
          };
        NSError *error =  [NSError errorWithDomain:kAdapterErrorDomain
                                              code:BidMachineAdapterErrorCodeMissingSellerId
                                          userInfo:userInfo];
        completion ? completion(error) : nil;
        return;
    }
    
    BDMSdk *sdk = [BDMSdk sharedSdk];
    
    BOOL loggingEnabled = [info[@"logging_enabled"] boolValue];
    BOOL testModeEnabled = [info[kBidMachineTestMode] boolValue];
    NSURL *endpointURL = [BidMachineAdapterTransformers endpointUrlFromValue:info[@"endpoint"]];
    BDMUserRestrictions *restrictions = [BidMachineAdapterTransformers userRestrictionsFromExtraInfo:info];
    NSArray <BDMAdNetworkConfiguration *> *headerBiddingConfig = [BidMachineAdapterTransformers adNetworkConfigFromDict:info];
    
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    [config setTestMode:testModeEnabled];
    endpointURL ? [config setBaseURL:endpointURL] : nil;
    headerBiddingConfig.count ? [config setNetworkConfigurations:headerBiddingConfig] : nil;
    
    [sdk setEnableLogging:loggingEnabled];
    [sdk setRestrictions:restrictions];
    [sdk startSessionWithSellerID:sellerID
                    configuration:config
                       completion:^{ completion ? completion(nil) : nil; }];
}

@end
