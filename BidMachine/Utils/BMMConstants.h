//
//  BMMConstants.h
//  BidMachine
//
//  Created by Yaroslav Skachkov on 5/17/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

static NSString * const kBidMachineSellerId             = @"seller_id";
static NSString * const kBidMachineTestMode             = @"test_mode";
static NSString * const kBidMachineLoggingEnabled       = @"logging_enabled";
static NSString * const kBidMachineBidId                = @"bm_id";
static NSString * const kBidMachinePrice                = @"bm_pf";

static NSString * const kAdapterErrorDomain = @"com.mopub.mopub-ios-sdk.mopub-bidmachine-adapters";

typedef NS_ENUM(NSInteger, BidMachineAdapterErrorCode) {
    BidMachineAdapterErrorCodeMissingSellerId,
};
