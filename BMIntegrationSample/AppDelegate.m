//
//  AppDelegate.m
//  BMIntegrationSample
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"
#import "BidMachineInstanceMediationSettings.h"
#import <mopub-ios-sdk/MoPub.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // You can use test ad unit id - 1832ce06de91424f8f81f9f5c77f7efd - for application initialization.
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization: @"YOUR_AD_UNIT_ID"];
    [sdkConfig setNetworkConfiguration:self.bidMachineConfiguration forMediationAdapter:@"BidMachineAdapterConfiguration"];
    sdkConfig.additionalNetworks = @[ NSClassFromString(@"BidMachineAdapterConfiguration") ];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    
    [[MoPub sharedInstance] grantConsent];
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
    }];
    
    return YES;
}

- (NSDictionary <NSString *, id> *)bidMachineConfiguration {
    return @{@"seller_id" : @"1",
             @"test_mode" : @"true",
             @"logging_enabled" : @"true",
             @"mediation_config": @[@{
                                    @"ad_units": @[
                         @{
                @"placement_id": @"95298PL39048",
                @"format": @"interstitial_static"
            }
                         ],
            @"app_id": @"5a35a75845eaab51250070a5",
            @"network": @"vungle",
            @"network_class": @"BDMVungleAdNetwork"
             }]};
}

@end
