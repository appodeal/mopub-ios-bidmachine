//
//  BidMachineRewardedVideoCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineRewardedVideoCustomEvent.h"
#import "BidMachineFactory+Request.h"


@interface BidMachineRewardedVideoCustomEvent() <BDMRewardedDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic, strong) NSString *networkId;

@end

@implementation BidMachineRewardedVideoCustomEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rewarded.delegate = self;
        [self getAdNetworkId];
    }
    return self;
}

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [[BidMachineFactory sharedFactory] initializeBidMachineSDKWithCustomEventInfo:info completion:^{
        NSMutableDictionary *extraInfo = weakSelf.localExtras.mutableCopy ?: [NSMutableDictionary new];
        [extraInfo addEntriesFromDictionary:info];
        
        NSArray *priceFloors = extraInfo[@"priceFloors"] ?: extraInfo[@"price_floors"];
        CLLocation *location = extraInfo[@"location"];
        BDMRewardedRequest *request = [[BidMachineFactory sharedFactory] rewardedRequestWithExtraInfo:extraInfo
                                                                                             location:location
                                                                                          priceFloors:priceFloors];
        [weakSelf.rewarded populateWithRequest:request];
    }];
}

- (BOOL)hasAdAvailable {
    return [self.rewarded canShow];
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [self.rewarded presentFromRootViewController:viewController];
}

#pragma mark - Lazy

- (BDMRewarded *)rewarded {
    if (!_rewarded) {
        _rewarded = [BDMRewarded new];
    }
    return _rewarded;
}

- (NSString *)getAdNetworkId {
    if (!self.networkId) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self.networkId;
}

#pragma mark - BDMRewardedDelegatge

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self networkId]);
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:error];
    [self setNetworkId:nil];
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self networkId]);
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], [self networkId]);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], [self networkId]);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], [self networkId]);
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], [self networkId]);
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(kMPRewardedVideoRewardCurrencyAmountUnspecified)];
    MPLogAdEvent([MPLogEvent adShouldRewardUserWithReward:reward], [self networkId]);
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

@end
