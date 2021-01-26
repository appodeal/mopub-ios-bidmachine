//
//  BidMachineNativeAdCustomEvent.m
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineNativeAdCustomEvent.h"
#import "BidMachineAdapterConfiguration.h"
#import "BidMachineNativeAdAdapter.h"

@interface BidMachineNativeAdCustomEvent ()<BDMNativeAdDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMNativeAd *nativeAd;
@property (nonatomic, strong) NSString *networkId;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end

@implementation BidMachineNativeAdCustomEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkId = NSUUID.UUID.UUIDString;
    }
    return self;
}

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    
    [self.requestController prepareRequestWithConfiguration:({
        BDMExternalAdapterConfiguration *config = [BDMExternalAdapterConfiguration configurationWithJSON:extraInfo];
        config;
    })];
}

- (BDMNativeAd *)nativeAd {
    if (!_nativeAd) {
        _nativeAd = BDMNativeAd.new;
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeNative
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMNativeAdRequest *adRequest = (BDMNativeAdRequest *)request;
    [self.nativeAd makeRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

#pragma mark - BDMNativeAdDelegate

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd readyToPresentAd:(nonnull BDMAuctionInfo *)auctionInfo {
    BidMachineNativeAdAdapter *nativeAdAdapter = [BidMachineNativeAdAdapter nativeAdAdapterWithAd:nativeAd];
    [self.delegate nativeCustomEvent:self didLoadAd:[[MPNativeAd alloc] initWithAdAdapter:nativeAdAdapter]];
}

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd failedWithError:(nonnull NSError *)error {
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
