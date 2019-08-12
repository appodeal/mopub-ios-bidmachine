//
//  BidMachineBannerCustomEvent.m
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineBannerCustomEvent.h"
#import "BidMachineAdapterConfiguration.h"
#import "BidMachineFactory+Request.h"


@interface BidMachineBannerCustomEvent() <BDMBannerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, strong) NSString *networkId;

@end

@implementation BidMachineBannerCustomEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bannerView.delegate = self;
        [self getAdNetworkId];
    }
    return self;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    [[BidMachineFactory sharedFactory] initializeBidMachineSDKWithCustomEventInfo:info completion:^{
        NSMutableDictionary *extraInfo = weakSelf.localExtras.mutableCopy ?: [NSMutableDictionary new];
        [extraInfo addEntriesFromDictionary:info];
        
        NSArray *priceFloors = extraInfo[@"priceFloors"] ?: extraInfo[@"price_floors"];
        BDMBannerRequest *request = [[BidMachineFactory sharedFactory] setupBannerRequestWithSize:size
                                                                                        extraInfo:extraInfo
                                                                                         location:weakSelf.delegate.location
                                                                                      priceFloors:priceFloors];
        [weakSelf.bannerView setFrame:CGRectMake(0, 0, size.width, size.height)];
        [weakSelf.bannerView populateWithRequest:request];
    }];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
    }
    return _bannerView;
}

- (NSString *)getAdNetworkId {
    if (!self.networkId) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self.networkId;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self networkId]);
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], [self networkId]);
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate bannerCustomEvent:self didLoadAd:bannerView];
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self networkId]);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self networkId]);
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    MPLogAdEvent([MPLogEvent adWillLeaveApplication], [self networkId]);
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
    MPLogInfo(@"Banner with id:%@ - Will present internal view.", [self networkId]);
    MPLogAdEvent([MPLogEvent adWillPresentModalForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
    MPLogInfo(@"Banner with id:%@ - Will dismiss internal view.", [self networkId]);
    MPLogAdEvent([MPLogEvent adDidDismissModalForAdapter:NSStringFromClass(self.class)], [self networkId]);
    [self.delegate bannerCustomEventDidFinishAction:self];
}

@end
