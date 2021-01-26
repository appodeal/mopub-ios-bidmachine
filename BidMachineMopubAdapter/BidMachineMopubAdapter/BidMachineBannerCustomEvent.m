//
//  BidMachineBannerCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineBannerCustomEvent.h"
#import "BidMachineAdapterConfiguration.h"


@interface BidMachineBannerCustomEvent() <BDMBannerDelegate, BDMAdEventProducerDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, strong) NSString *networkId;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

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
    
    [self.requestController prepareRequestWithConfiguration:({
        BDMExternalAdapterConfiguration *config = [BDMExternalAdapterConfiguration configurationWithJSON:extraInfo];
        config.bannerSize = size;
        config;
    })];
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

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeBanner
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMBannerRequest *adRequest = (BDMBannerRequest *)request;
    [self.bannerView setFrame:(CGRect){.size = CGSizeFromBDMSize(adRequest.adSize)}];
    [self.bannerView populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
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

