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
#import <BidMachine/BidMachine.h>

#define NATIVE_APP_ID         "7c3f8de23b9d4b7ab45a53ed2c3cb0c8"
#define FULLSCREEN_APP_ID     "1832ce06de91424f8f81f9f5c77f7efd"
#define BANNER_APP_ID         "1832ce06de91424f8f81f9f5c77f7efd"


@interface AppDelegate ()

@end

@implementation AppDelegate


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
             @"seller_id" : @"5",
             @"test_mode" : @"true",
             @"logging_enabled" : @"true",
             @"endpoint" : @"https://api.appodealx.com"
             };
}

@end
