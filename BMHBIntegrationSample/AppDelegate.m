//
//  AppDelegate.m
//  BMIntegrationSample
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"
#import "BidMachineFetcher.h"
#import "BidMachineAdapterConfiguration.h"
#import "BidMachineInstanceMediationSettings.h"

#import <mopub-ios-sdk/MoPub.h>
#import <BidMachine/BidMachine.h>

#define NATIVE_APP_ID         "7c3f8de23b9d4b7ab45a53ed2c3cb0c8"
#define FULLSCREEN_APP_ID     "1832ce06de91424f8f81f9f5c77f7efd"
#define BANNER_APP_ID         "1832ce06de91424f8f81f9f5c77f7efd"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [self configureBidMachinePricefloorRounding];
     __weak typeof(self) weakSelf = self;
     [self startBidMachine:^{
         [weakSelf startMoPub];
     }];
    
    return YES;
}

/// Setup bm_pf format and roundin mode
- (void)configureBidMachinePricefloorRounding {
    BidMachineFetcher.sharedFetcher.roundingMode = NSNumberFormatterRoundDown;
    // Formats described in https://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns
    BidMachineFetcher.sharedFetcher.format = @"0.00";
}

/// Start BidMachine session, should be called before MoPub initialisation
- (void)startBidMachine:(void(^)(void))completion {
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:completion];
}

///  Start MoPub SDK
- (void)startMoPub {
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:@FULLSCREEN_APP_ID];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    // Note that BidMachineAdapter should be added as additional network as BidMachineAdapterConfiguration
    sdkConfig.additionalNetworks = @[ BidMachineAdapterConfiguration.class ];

    [MoPub.sharedInstance initializeSdkWithConfiguration:sdkConfig
                                              completion:^{
                                                  NSLog(@"SDK initialization complete");
                                              }];
}

@end
