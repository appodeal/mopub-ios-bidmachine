//
//  BidMachineFactory+HeaderBidding.h
//  BidMachine
//
//  Created by Yaroslav Skachkov on 7/30/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineFactory.h"
#import <BidMachine/BDMAdNetworkConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface BidMachineFactory (HeaderBidding)

- (NSArray<BDMAdNetworkConfiguration *> *)adNetworkConfigFromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
