//
//  BidMachineBannerCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineBannerCustomEvent.h"
#import "BidMachineAdapterConfiguration.h"
#import "BidMachineAdapterUtils+Request.h"
#import "BidMachineAdapterTransformers.h"
#import "BidMachineFetcher.h"
#import "BidMachineConstants.h"


@interface BidMachineBannerCustomEvent() <BDMBannerDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, strong) NSString *networkId;
@property (nonatomic, assign) BOOL hasTrackedImpression;
@property (nonatomic, assign) BOOL hasTrackedClick;

@end

@implementation BidMachineBannerCustomEvent

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

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    BDMBannerAdSize adSize = [BidMachineAdapterTransformers bannerSizeFromCGSize:size];
    
    if ([extraInfo.allKeys containsObject:kBidMachineBidId]) {
        id request = [BidMachineFetcher.sharedFetcher requestForBidId:extraInfo[kBidMachineBidId]];
        if ([request isKindOfClass:BDMBannerRequest.self]) {
            [self populate:request adSize:adSize];
        } else {
            NSDictionary *userInfo =
            @{
                NSLocalizedFailureReasonErrorKey: @"BidMachine request type not satisfying",
                NSLocalizedDescriptionKey: @"BidMachineBannerCustomEvent requires to use BDMBannerRequest",
                NSLocalizedRecoverySuggestionErrorKey: @"Check that you pass keywords and extras to MPAdView from BDMBannerRequest"
            };
            NSError *error =  [NSError errorWithDomain:kAdapterErrorDomain
                                                  code:BidMachineAdapterErrorCodeMissingSellerId
                                              userInfo:userInfo];
            MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
            [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BidMachineAdapterUtils.sharedUtils initializeBidMachineSDKWithCustomEventInfo:info completion:^(NSError *error) {
            NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
            BDMBannerRequest *request = [BidMachineAdapterUtils.sharedUtils bannerRequestWithSize:adSize
                                                                                        extraInfo:extraInfo
                                                                                         location:weakSelf.delegate.location
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
    [self.delegate bannerCustomEvent:self didLoadAd:bannerView];
}

- (void)bannerView:(BDMBannerView *)bannerView failedWithError:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)bannerViewRecieveUserInteraction:(BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.networkId);
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adWillLeaveApplication], self.networkId);
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
    MPLogInfo(@"Banner with id:%@ - Will present internal view.", self.networkId);
    MPLogAdEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
    MPLogInfo(@"Banner with id:%@ - Will dismiss internal view.", self.networkId);
    MPLogAdEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)], self.networkId);
    [self.delegate bannerCustomEventDidFinishAction:self];
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceImpression:(id<BDMAdEventProducer>)producer {
    if (!self.hasTrackedImpression) {
        MPLogInfo(@"BidMachine banner ad did log impression");
        self.hasTrackedImpression = YES;
        [self.delegate trackImpression];
    }
}

- (void)didProduceUserAction:(id<BDMAdEventProducer>)producer {
    if (!self.hasTrackedClick) {
        MPLogInfo(@"BidMachine banner ad did log click");
        self.hasTrackedClick = YES;
        [self.delegate trackClick];
    }
}

@end
