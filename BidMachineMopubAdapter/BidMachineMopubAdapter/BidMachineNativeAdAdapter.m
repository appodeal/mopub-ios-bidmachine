//
//  BidMachineNativeAdAdapter.m
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineNativeAdAdapter.h"

#if __has_include("MoPub.h")
    #import "MPNativeAdConstants.h"
    #import "MPNativeAdError.h"
    #import "MPLogging.h"
#endif

@interface BidMachineNativeAdAdapter ()<BDMAdEventProducerDelegate>

@property (nonatomic, readwrite) NSDictionary *properties;
@property (nonatomic, readwrite) BDMNativeAd *ad;

@end

@implementation BidMachineNativeAdAdapter

+ (instancetype)nativeAdAdapterWithAd:(BDMNativeAd *)ad {
    return [[self alloc] initWithAd:ad];
}

- (instancetype)initWithAd:(BDMNativeAd *)ad {
    if (self = [super init]) {
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        properties[kAdTitleKey] = ad.title;
        properties[kAdTextKey] = ad.body;
        properties[kAdCTATextKey] = ad.CTAText;
        properties[kAdIconImageKey] = ad.iconUrl;
        properties[kAdMainImageKey] = ad.mainImageUrl;
        properties[kAdStarRatingKey] = ad.starRating;

        _properties = properties;
        _ad = ad;
        
        self.ad.producerDelegate = self;
    }
    return self;
}

- (NSURL *)defaultActionURL {
    return nil;
}

- (BOOL)enableThirdPartyClickTracking {
    return YES;
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    [self.delegate nativeAdDidClick:self];
}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [self.delegate nativeAdWillLogImpression:self];
}


@end
