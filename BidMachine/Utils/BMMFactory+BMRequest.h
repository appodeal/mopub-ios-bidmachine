//
//  BMMFactory+BMRequest.h
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMFactory.h"
#import <BidMachine/BidMachine.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMMFactory (BMRequest)

- (BDMBannerRequest *)bannerRequestWithSize:(BDMBannerAdSize)size
                                  extraInfo:(NSDictionary *)extraInfo
                                priceFloors:(NSArray *)priceFloors;

- (BDMInterstitialRequest *)interstitialRequestWithExtraInfo:(NSDictionary *)extraInfo
                                                 priceFloors:(NSArray *)priceFloors;

- (BDMRewardedRequest *)rewardedRequestWithExtraInfo:(NSDictionary *)extraInfo
                                         priceFloors:(NSArray *)priceFloors;

- (BDMNativeAdRequest *)nativeAdRequestWithExtraInfo:(NSDictionary *)extraInfo
                                         priceFloors:(NSArray *)priceFloors;

@end

NS_ASSUME_NONNULL_END
