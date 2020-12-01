//
//  BMMUtils.m
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMUtils.h"
#import "BMMConstants.h"
#import "BMMTransformer.h"
#import "BMMFactory+BMTargeting.h"

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif

@implementation BMMUtils

+ (instancetype)shared {
    static BMMUtils * _sharedFactory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFactory = BMMUtils.new;
    });
    return _sharedFactory;
}

- (void)initializeBidMachineSDKWithCustomEventInfo:(NSDictionary *)info
                                        completion:(void(^)(NSError *))completion {
    NSString *sellerID = [BMMTransformer sellerIdFromValue:info[kBidMachineSellerId]];
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
    
    BOOL loggingEnabled = [info[kBidMachineLoggingEnabled] boolValue];
    BOOL testModeEnabled = [info[kBidMachineTestMode] boolValue];
    NSURL *endpointURL = [BMMTransformer endpointUrlFromValue:info[@"endpoint"]];
    BDMTargeting *targeting = [BMMFactory.sharedFactory targetingFromExtraInfo:info];
    BDMUserRestrictions *restrictions = [BMMFactory.sharedFactory userRestrictionsFromExtraInfo:info];
    NSArray <BDMAdNetworkConfiguration *> *headerBiddingConfig = [BMMTransformer adNetworkConfigFromDict:info];
    
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    [config setTestMode:testModeEnabled];
    [config setTargeting:targeting];
    endpointURL ? [config setBaseURL:endpointURL] : nil;
    headerBiddingConfig.count ? [config setNetworkConfigurations:headerBiddingConfig] : nil;
    
    sdk.restrictions.hasConsent = restrictions.hasConsent;
    sdk.restrictions.subjectToGDPR = restrictions.subjectToGDPR;
    sdk.restrictions.consentString = restrictions.consentString;
    sdk.restrictions.coppa = restrictions.coppa;
    
    [sdk setEnableLogging:loggingEnabled];
    [sdk startSessionWithSellerID:sellerID
                    configuration:config
                       completion:^{ completion ? completion(nil) : nil; }];
}

@end
