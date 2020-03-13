//
//  BidMachineInterstitialCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/4/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineInterstitialCustomEvent.h"
#import "BidMachineAdapterUtils+Request.h"
#import "BidMachineFetcher.h"
#import "BidMachineConstants.h"


@interface BidMachineInterstitialCustomEvent() <BDMInterstitialDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) NSString *networkId;

@end

@implementation BidMachineInterstitialCustomEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self;
}

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    
    if ([extraInfo.allKeys containsObject:kBidMachineBidId]) {
        id request = [BidMachineFetcher.sharedFetcher requestForBidId:extraInfo[kBidMachineBidId]];
        if ([request isKindOfClass:BDMInterstitialRequest.self]) {
            [self.interstitial populateWithRequest:request];
        } else {
            NSDictionary *userInfo =
            @{
                NSLocalizedFailureReasonErrorKey: @"BidMachine request type not satisfying",
                NSLocalizedDescriptionKey: @"BidMachineInterstitialCustomEvent requires to use BDMInterstitialRequest",
                NSLocalizedRecoverySuggestionErrorKey: @"Check that you pass keywords and extras to MPInterstitialAdController from BDMInterstitialRequest"
            };
            NSError *error =  [NSError errorWithDomain:kAdapterErrorDomain
                                                  code:BidMachineAdapterErrorCodeMissingSellerId
                                              userInfo:userInfo];
            MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BidMachineAdapterUtils.sharedUtils initializeBidMachineSDKWithCustomEventInfo:info completion:^(NSError *error) {
            NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
            BDMInterstitialRequest *request = [BidMachineAdapterUtils.sharedUtils interstitialRequestWithExtraInfo:extraInfo
                                                                                                          location:weakSelf.delegate.location
                                                                                                       priceFloors:priceFloors];
            [weakSelf.interstitial populateWithRequest:request];
        }];
    }
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self.interstitial presentFromRootViewController:rootViewController];
}

#pragma mark - Lazy

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(BDMInterstitial *)interstitial {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void)interstitial:(BDMInterstitial *)interstitial failedWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)interstitialWillPresent:(BDMInterstitial *)interstitial {
    MPLogAdEvent(MPLogEvent.adShowSuccess, self.networkId);
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], self.networkId);
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)interstitial:(BDMInterstitial *)interstitial failedToPresentWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
}

- (void)interstitialDidDismiss:(BDMInterstitial *)interstitial {
    [self.delegate interstitialCustomEventDidDisappear:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)interstitialRecieveUserInteraction:(BDMInterstitial *)interstitial {
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.networkId);
}

@end
