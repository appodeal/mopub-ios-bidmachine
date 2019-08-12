//
//  BidMachineInterstitialCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/4/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineInterstitialCustomEvent.h"
#import "BidMachineFactory+Request.h"


@interface BidMachineInterstitialCustomEvent() <BDMInterstitialDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) NSString *networkId;

@end

@implementation BidMachineInterstitialCustomEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.interstitial.delegate = self;
        [self getAdNetworkId];
    }
    return self;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [[BidMachineFactory sharedFactory] initializeBidMachineSDKWithCustomEventInfo:info completion:^{
        NSMutableDictionary *extraInfo = weakSelf.localExtras.mutableCopy ?: [NSMutableDictionary new];
        [extraInfo addEntriesFromDictionary:info];
        
        NSArray *priceFloors = extraInfo[@"priceFloors"];
        BDMInterstitialRequest *request = [[BidMachineFactory sharedFactory] interstitialRequestWithExtraInfo:extraInfo
                                                                                                     location:weakSelf.delegate.location
                                                                                                  priceFloors:priceFloors];
        [weakSelf.interstitial populateWithRequest:request];
    }];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self.interstitial presentFromRootViewController:rootViewController];
}

- (NSString *)getAdNetworkId {
    if (!self.networkId) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self.networkId;
}

#pragma mark - Lazy

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
    }
    return _interstitial;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self networkId]);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    MPLogAdEvent(MPLogEvent.adShowSuccess, [self networkId]);
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], [self networkId]);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], [self networkId]);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], [self networkId]);
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], [self networkId]);
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    [self.delegate interstitialCustomEventDidDisappear:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], [self networkId]);
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self networkId]);
}

@end
