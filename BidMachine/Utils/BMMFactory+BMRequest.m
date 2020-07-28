//
//  BMMFactory+BMRequest.m
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMFactory+BMRequest.h"
#import "BMMFactory+BMTargeting.h"
#import "BMMTransformer.h"

@implementation BMMFactory (BMRequest)

- (BDMBannerRequest *)bannerRequestWithSize:(BDMBannerAdSize)size
                                  extraInfo:(NSDictionary *)extraInfo
                                priceFloors:(NSArray *)priceFloors {
    BDMBannerRequest *request = [BDMBannerRequest new];
    
    BDMTargeting *targeting = [BMMFactory.sharedFactory targetingFromExtraInfo:extraInfo];
    NSArray <BDMPriceFloor *> *_priceFloors = [BMMTransformer priceFloorsFromArray:priceFloors];
    
    [request setAdSize:size];
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];
    
    return request;
}

- (BDMInterstitialRequest *)interstitialRequestWithExtraInfo:(NSDictionary *)extraInfo
                                                 priceFloors:(NSArray *)priceFloors {
    BDMInterstitialRequest *request = [BDMInterstitialRequest new];
    BDMFullscreenAdType adType = [BMMTransformer interstitialAdTypeFromString:extraInfo[@"ad_content_type"]];
    BDMTargeting *targeting = [BMMFactory.sharedFactory targetingFromExtraInfo:extraInfo];
    NSArray <BDMPriceFloor *> *_priceFloors = [BMMTransformer priceFloorsFromArray:priceFloors];
    
    [request setType:adType];
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];
    
    return request;
}

- (BDMRewardedRequest *)rewardedRequestWithExtraInfo:(NSDictionary *)extraInfo
                                         priceFloors:(NSArray *)priceFloors {
    BDMRewardedRequest *request = [BDMRewardedRequest new];
    BDMTargeting *targeting = [BMMFactory.sharedFactory targetingFromExtraInfo:extraInfo];
    NSArray <BDMPriceFloor *> *_priceFloors = [BMMTransformer priceFloorsFromArray:priceFloors];
    
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];

    return request;
}

- (BDMNativeAdRequest *)nativeAdRequestWithExtraInfo:(NSDictionary *)extraInfo
                                         priceFloors:(NSArray *)priceFloors {
    BDMNativeAdRequest *request = [BDMNativeAdRequest new];
    BDMTargeting *targeting = [BMMFactory.sharedFactory targetingFromExtraInfo:extraInfo];
    NSArray <BDMPriceFloor *> *_priceFloors = [BMMTransformer priceFloorsFromArray:priceFloors];
    
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];
    
    return request;
}

@end
