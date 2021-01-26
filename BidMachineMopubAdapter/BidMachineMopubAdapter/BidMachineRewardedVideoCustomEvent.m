//
//  BidMachineRewardedVideoCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineRewardedVideoCustomEvent.h"
#import "BidMachineAdapterConfiguration.h"


@interface BidMachineRewardedVideoCustomEvent() <BDMRewardedDelegate, BDMAdEventProducerDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic, strong) NSString *networkId;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end

@implementation BidMachineRewardedVideoCustomEvent

@dynamic delegate, localExtras, hasAdAvailable;

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

- (BOOL)isRewardExpected {
    return YES;
}

- (BOOL)hasAdAvailable {
    return [self.rewarded canShow];
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    
    [self.requestController prepareRequestWithConfiguration:({
        BDMExternalAdapterConfiguration *config = [BDMExternalAdapterConfiguration configurationWithJSON:extraInfo];
        config;
    })];
}

- (void)presentAdFromViewController:(UIViewController *)viewController  {
    [self.rewarded presentFromRootViewController:viewController];
}

#pragma mark - Lazy

- (BDMRewarded *)rewarded {
    if (!_rewarded) {
        _rewarded = [BDMRewarded new];
        _rewarded.delegate = self;
        _rewarded.producerDelegate = self;
    }
    return _rewarded;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeRewardedVideo
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMRewardedRequest *adRequest = (BDMRewardedRequest *)request;
    [self.rewarded populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

#pragma mark - BDMRewardedDelegatge

- (void)rewardedReadyToPresent:(BDMRewarded *)rewarded {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)rewarded:(BDMRewarded *)rewarded failedWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)rewardedRecieveUserInteraction:(BDMRewarded *)rewarded {
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)rewardedWillPresent:(BDMRewarded *)rewarded {
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)rewarded:(BDMRewarded *)rewarded failedToPresentWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:error];
}

- (void)rewardedDidDismiss:(BDMRewarded *)rewarded {
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
}

- (void)rewardedFinishRewardAction:(BDMRewarded *)rewarded {
    MPReward *reward = [[MPReward alloc] initWithCurrencyType:kMPRewardCurrencyTypeUnspecified
                                                       amount:@(kMPRewardCurrencyAmountUnspecified)];
    MPLogAdEvent([MPLogEvent adShouldRewardUserWithReward:reward], self.networkId);
    [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
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
