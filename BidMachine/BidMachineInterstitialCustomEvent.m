//
//  BidMachineInterstitialCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/4/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineInterstitialCustomEvent.h"
#import "BMMFactory+BMRequest.h"
#import "BMMTransformer.h"
#import "BMMConstants.h"
#import "BMMError.h"
#import "BMMUtils.h"


@interface BidMachineInterstitialCustomEvent() <BDMInterstitialDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) NSString *networkId;

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
    return false;
}

- (BOOL)hasAdAvailable {
    return [self.interstitial canShow];
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    
    NSString *price = ANY(extraInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BDMRequestStorage.shared isPrebidRequestsForType:BDMInternalPlacementTypeInterstitial];
    
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BDMRequestStorage.shared requestForPrice:price type:BDMInternalPlacementTypeInterstitial];
        if ([auctionRequest isKindOfClass:BDMInterstitialRequest.self]) {
            [self.interstitial populateWithRequest:(BDMInterstitialRequest *)auctionRequest];
        } else {
            NSError *error = [BMMError errorWithCode:BidMachineAdapterErrorCodeMissingSellerId description:@"Bidmachine can't fint prebid request"];
            MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
            [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        }
    } else {
       __weak typeof(self) weakSelf = self;
        [BMMUtils.shared initializeBidMachineSDKWithCustomEventInfo:info completion:^(NSError *error) {
            NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
            BDMInterstitialRequest *request = [BMMFactory.sharedFactory interstitialRequestWithExtraInfo:extraInfo
                                                                                             priceFloors:priceFloors];
            [weakSelf.interstitial populateWithRequest:request];
        }];
    }
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
