//
//  BidMachineFactory+Request.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineFactory+Request.h"

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


@implementation BidMachineFactory (Request)

- (BDMBannerRequest *)setupBannerRequestWithSize:(CGSize)size
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
    [request setAdSize:bannerAdSize];
    [request setTargeting:[[BidMachineFactory sharedFactory] setupTargetingWithExtraInfo:extraInfo andLocation:location]];
    [request setPriceFloors:[self makePriceFloorsWithPriceFloors:priceFloors]];
    return request;
}

- (BDMInterstitialRequest *)interstitialRequestWithExtraInfo:(NSDictionary *)extraInfo
                                                    location:(CLLocation *)location
                                                 priceFloors:(NSArray *)priceFloors {
    BDMInterstitialRequest *request = [BDMInterstitialRequest new];
    [request setType:[self setupInterstitialAdType:extraInfo[@"ad_content_type"]]];
    [request setTargeting:[[BidMachineFactory sharedFactory] setupTargetingWithExtraInfo:extraInfo andLocation:location]];
    [request setPriceFloors:[self makePriceFloorsWithPriceFloors:priceFloors]];
    return request;
}

- (BDMRewardedRequest *)rewardedRequestWithExtraInfo:(NSDictionary *)extraInfo
                                            location:(CLLocation *)location
                                         priceFloors:(NSArray *)priceFloors {
    BDMRewardedRequest *request = [BDMRewardedRequest new];
    [request setTargeting:[[BidMachineFactory sharedFactory] setupTargetingWithExtraInfo:extraInfo andLocation:location]];
    [request setPriceFloors:[self makePriceFloorsWithPriceFloors:priceFloors]];
    return request;
}

- (BDMFullscreenAdType)setupInterstitialAdType:(NSString *)string {
    BDMFullscreenAdType type;
    NSString *lowercasedString = [string lowercaseString];
    if ([lowercasedString isEqualToString:@"all"]) {
        type = BDMFullscreenAdTypeAll;
    } else if ([lowercasedString isEqualToString:@"video"]) {
        type = BDMFullscreenAdTypeVideo;
    } else if ([lowercasedString isEqualToString:@"static"]) {
        type = BDMFullsreenAdTypeBanner;
    } else {
        type = BDMFullscreenAdTypeAll;
    }
    return type;
}

@end
