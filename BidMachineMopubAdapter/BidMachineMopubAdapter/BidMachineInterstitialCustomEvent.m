//
//  BidMachineInterstitialCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/4/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineInterstitialCustomEvent.h"
#import "BidMachineAdapterConfiguration.h"


@interface BidMachineInterstitialCustomEvent() <BDMInterstitialDelegate, BDMAdEventProducerDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) NSString *networkId;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end

@implementation BidMachineInterstitialCustomEvent

@dynamic delegate, localExtras, hasAdAvailable;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self;
}

- (BOOL)isRewardExpected {
    return NO;
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (BOOL)hasAdAvailable {
    return [self.interstitial canShow];
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    
    [self.requestController prepareRequestWithConfiguration:({
        BDMExternalAdapterConfiguration *config = [BDMExternalAdapterConfiguration configurationWithJSON:extraInfo];
        config;
    })];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    [self.interstitial presentFromRootViewController:viewController];
}

#pragma mark - Lazy

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
        _interstitial.delegate = self;
        _interstitial.producerDelegate = self;
    }
    return _interstitial;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeInterstitial
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMInterstitialRequest *adRequest = (BDMInterstitialRequest *)request;
    [self.interstitial populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(BDMInterstitial *)interstitial {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)interstitial:(BDMInterstitial *)interstitial failedWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)interstitialWillPresent:(BDMInterstitial *)interstitial {
    MPLogAdEvent(MPLogEvent.adShowSuccess, self.networkId);
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)interstitial:(BDMInterstitial *)interstitial failedToPresentWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:error];
}

- (void)interstitialDidDismiss:(BDMInterstitial *)interstitial {
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)interstitialRecieveUserInteraction:(BDMInterstitial *)interstitial {
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.networkId);
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceImpression:(id<BDMAdEventProducer>)producer {
    MPLogInfo(@"BidMachine banner ad did log impression");
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
}

- (void)didProduceUserAction:(id<BDMAdEventProducer>)producer {
    MPLogInfo(@"BidMachine banner ad did log click");
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
