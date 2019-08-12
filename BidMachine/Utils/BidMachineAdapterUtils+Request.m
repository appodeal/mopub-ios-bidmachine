//
//  BidMachineAdapterUtils+Request.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineAdapterUtils+Request.h"
#import "BidMachineAdapterTransformers.h"


#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif

#if __has_include(<BidMachine/BidMachine.h>)
#import <BidMachine/BidMachine.h>
#endif


@implementation BidMachineAdapterUtils (Request)


- (BDMBannerRequest *)bannerRequestWithSize:(CGSize)size
                                  extraInfo:(NSDictionary *)extraInfo
                                   location:(CLLocation *)location
                                priceFloors:(NSArray *)priceFloors {
    BDMBannerRequest *request = [BDMBannerRequest new];
    BDMBannerAdSize bannerAdSize;
    switch ((int)size.width) {
        case 300: bannerAdSize = BDMBannerAdSize300x250;  break;
        case 320: bannerAdSize = BDMBannerAdSize320x50;   break;
        case 728: bannerAdSize = BDMBannerAdSize728x90;   break;
        default: bannerAdSize = BDMBannerAdSizeUnknown;   break;
    }
    BDMTargeting *targeting = [BidMachineAdapterTransformers targetingFromExtraInfo:extraInfo location:location];
    NSArray <BDMPriceFloor *> *_priceFloors = [BidMachineAdapterTransformers priceFloorsFromArray:priceFloors];
    
    [request setAdSize:bannerAdSize];
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];
    
    return request;
}

- (BDMInterstitialRequest *)interstitialRequestWithExtraInfo:(NSDictionary *)extraInfo
                                                    location:(CLLocation *)location
                                                 priceFloors:(NSArray *)priceFloors {
    BDMInterstitialRequest *request = [BDMInterstitialRequest new];
    BDMFullscreenAdType adType = [BidMachineAdapterTransformers interstitialAdTypeFromString:extraInfo[@"ad_content_type"]];
    BDMTargeting *targeting = [BidMachineAdapterTransformers targetingFromExtraInfo:extraInfo location:location];
    NSArray <BDMPriceFloor *> *_priceFloors = [BidMachineAdapterTransformers priceFloorsFromArray:priceFloors];
    
    [request setType:adType];
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];
    
    return request;
}

- (BDMRewardedRequest *)rewardedRequestWithExtraInfo:(NSDictionary *)extraInfo
                                            location:(CLLocation *)location
                                         priceFloors:(NSArray *)priceFloors {
    BDMRewardedRequest *request = [BDMRewardedRequest new];
    BDMTargeting *targeting = [BidMachineAdapterTransformers targetingFromExtraInfo:extraInfo location:location];
    NSArray <BDMPriceFloor *> *_priceFloors = [BidMachineAdapterTransformers priceFloorsFromArray:priceFloors];
    
    [request setTargeting:targeting];
    [request setPriceFloors:_priceFloors];

    return request;
}

@end
