//
//  BMMFetcher.h
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachine/BidMachine.h>
NS_ASSUME_NONNULL_BEGIN

@interface BMMFetcher : NSObject <BDMFetcherPresetProtocol>

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) NSNumberFormatterRoundingMode roundingMode;
@property (nonatomic, assign) BDMInternalPlacementType type;
@property (nonatomic, assign) BDMFetcherRange range;

@end

NS_ASSUME_NONNULL_END
