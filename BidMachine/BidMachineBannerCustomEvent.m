//
//  BidMachineBannerCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineBannerCustomEvent.h"
#import "BMMFactory+BMRequest.h"
#import "BMMTransformer.h"
#import "BMMConstants.h"
#import "BMMError.h"
#import "BMMUtils.h"


@interface BidMachineBannerCustomEvent() <BDMBannerDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, strong) NSString *networkId;

@end

@implementation BidMachineBannerCustomEvent

@dynamic delegate, localExtras;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self;
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (void)requestAdWithSize:(CGSize)size adapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    BDMBannerAdSize adSize = [BMMTransformer bannerSizeFromCGSize:size];
    
    NSString *price = ANY(extraInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BDMRequestStorage.shared isPrebidRequestsForType:BDMInternalPlacementTypeBanner];
    
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BDMRequestStorage.shared requestForPrice:price type:BDMInternalPlacementTypeBanner];
        if ([auctionRequest isKindOfClass:BDMBannerRequest.self]) {
            [self populate:(BDMBannerRequest *)auctionRequest adSize:adSize];
        } else {
            NSError *error = [BMMError errorWithCode:BidMachineAdapterErrorCodeMissingSellerId description:@"Bidmachine can't fint prebid request"];
            MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
            [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMMUtils.shared initializeBidMachineSDKWithCustomEventInfo:info completion:^(NSError *error) {
            NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
            BDMBannerRequest *request = [BMMFactory.sharedFactory bannerRequestWithSize:adSize
                                                                              extraInfo:extraInfo
                                                                            priceFloors:priceFloors];
            [weakSelf populate:request adSize:adSize];
        }];
    }
}

- (void)populate:(BDMBannerRequest *)request
          adSize:(BDMBannerAdSize)adSize {
    // Transform size 2 times to avoid fluid sizes with 0 width
    [self.bannerView setFrame:(CGRect){.size = CGSizeFromBDMSize(adSize)}];
    [self.bannerView populateWithRequest:request];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
        _bannerView.delegate = self;
        _bannerView.producerDelegate = self;
    }
    return _bannerView;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate inlineAdAdapter:self didLoadAdWithAdView:bannerView];
}

- (void)bannerView:(BDMBannerView *)bannerView failedWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)bannerViewRecieveUserInteraction:(BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate inlineAdAdapterWillBeginUserAction:self];
    [self.delegate inlineAdAdapterDidEndUserAction:self];
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adWillLeaveApplication], self.networkId);
    [self.delegate inlineAdAdapterWillLeaveApplication:self];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
    MPLogInfo(@"Banner with id:%@ - Will present internal view.", self.networkId);
    MPLogAdEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
    MPLogInfo(@"Banner with id:%@ - Will dismiss internal view.", self.networkId);
    MPLogAdEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)], self.networkId);
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceImpression:(id<BDMAdEventProducer>)producer {
    MPLogInfo(@"BidMachine banner ad did log impression");
    [self.delegate inlineAdAdapterDidTrackImpression:self];
}

- (void)didProduceUserAction:(id<BDMAdEventProducer>)producer {
    MPLogInfo(@"BidMachine banner ad did log click");
    [self.delegate inlineAdAdapterDidTrackClick:self];
}

@end

