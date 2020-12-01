//
//  BidMachineNativeAdCustomEvent.m
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineNativeAdCustomEvent.h"
#import "BidMachineNativeAdAdapter.h"
#import "BMMFactory+BMRequest.h"
#import "BMMTransformer.h"
#import "BMMConstants.h"
#import "BMMError.h"
#import "BMMUtils.h"


@interface BidMachineNativeAdCustomEvent ()<BDMNativeAdDelegate>

@property (nonatomic, strong) BDMNativeAd *nativeAd;
@property (nonatomic, strong) NSString *networkId;

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
    
    NSString *price = ANY(extraInfo).from(kBidMachinePrice).string;
    BOOL isPrebid = [BDMRequestStorage.shared isPrebidRequestsForType:BDMInternalPlacementTypeNative];
    
    if (isPrebid && price) {
        BDMRequest *auctionRequest = [BDMRequestStorage.shared requestForPrice:price type:BDMInternalPlacementTypeNative];
        if ([auctionRequest isKindOfClass:BDMNativeAdRequest.self]) {
            [self.nativeAd makeRequest:(BDMNativeAdRequest *)auctionRequest];
        } else {
            NSError *error = [BMMError errorWithCode:BidMachineAdapterErrorCodeMissingSellerId description:@"Bidmachine can't fint prebid request"];
            MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [BMMUtils.shared initializeBidMachineSDKWithCustomEventInfo:extraInfo completion:^(NSError *error) {
            NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
            BDMNativeAdRequest *request = [BMMFactory.sharedFactory nativeAdRequestWithExtraInfo:extraInfo
                                                                                     priceFloors:priceFloors];
            [weakSelf.nativeAd makeRequest:request];
        }];
    }
}

- (BDMNativeAd *)nativeAd {
    if (!_nativeAd) {
        _nativeAd = BDMNativeAd.new;
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}

#pragma mark - BDMNativeAdDelegate

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd readyToPresentAd:(nonnull BDMAuctionInfo *)auctionInfo {
    BidMachineNativeAdAdapter *nativeAdAdapter = [BidMachineNativeAdAdapter nativeAdAdapterWithAd:nativeAd];
    [self.delegate nativeCustomEvent:self didLoadAd:[[MPNativeAd alloc] initWithAdAdapter:nativeAdAdapter]];
}

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd failedWithError:(nonnull NSError *)error {
    [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
}

@end
