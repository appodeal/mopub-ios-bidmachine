//
//  BidMachineAdapterConfiguration.m
//  BidMachineAdapterConfiguration
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachineAdapterConfiguration. All rights reserved.
//

#import "BidMachineAdapterConfiguration.h"

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
    [BDMExternalAdapterRequestController startBidMachineSDKWithConfiguration:config completion:^(NSError *error) {
        error ?
            MPLogEvent([MPLogEvent error:error message:nil]) :
            MPLogInfo(@"BidMachine SDK was successfully initialized!");
        
        complete ? complete(error) : nil;
    }];
}

@end
