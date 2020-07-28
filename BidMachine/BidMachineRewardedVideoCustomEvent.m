//
//  BidMachineRewardedVideoCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineRewardedVideoCustomEvent.h"
#import "BMMFactory+BMRequest.h"
#import "BMMTransformer.h"
#import "BMMConstants.h"
#import "BMMError.h"
#import "BMMUtils.h"

#if __has_include("MoPub.h")
    #import "MPLogging.h"
    #import "MoPub.h"
    #import "MPReward.h"
#endif


@interface BidMachineRewardedVideoCustomEvent() <BDMRewardedDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic, strong) NSString *networkId;

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
    return false;
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
    
    NSString *price = ANY(extraInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BDMRequestStorage.shared isPrebidRequestsForType:BDMInternalPlacementTypeRewardedVideo];
    
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BDMRequestStorage.shared requestForPrice:price type:BDMInternalPlacementTypeRewardedVideo];
        if ([auctionRequest isKindOfClass:BDMRewardedRequest.self]) {
            [self.rewarded populateWithRequest:(BDMRewardedRequest *)auctionRequest];
        } else {
            NSError *error = [BMMError errorWithCode:BidMachineAdapterErrorCodeMissingSellerId description:@"Bidmachine can't fint prebid request"];
            MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
            [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        }
    } else {
       __weak typeof(self) weakSelf = self;
        [BMMUtils.shared initializeBidMachineSDKWithCustomEventInfo:info completion:^(NSError *error) {
            NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
            BDMRewardedRequest *request = [BMMFactory.sharedFactory rewardedRequestWithExtraInfo:extraInfo
                                                                                     priceFloors:priceFloors];
            [weakSelf.rewarded populateWithRequest:request];
        }];
    }
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
