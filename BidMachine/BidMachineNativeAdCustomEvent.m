//
//  BidMachineNativeAdCustomEvent.m
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineNativeAdCustomEvent.h"
#import "BidMachineAdapterUtils+Request.h"
#import "BidMachineNativeAdAdapter.h"
#import "BidMachineFetcher.h"
#import "BidMachineConstants.h"

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

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info {
    NSMutableDictionary *extraInfo = self.localExtras.mutableCopy ?: [NSMutableDictionary new];
    [extraInfo addEntriesFromDictionary:info];
    
    if ([extraInfo.allKeys containsObject:kBidMachineBidId]) {
          id request = [BidMachineFetcher.sharedFetcher requestForBidId:extraInfo[kBidMachineBidId]];
          if ([request isKindOfClass:BDMRewardedRequest.self]) {
              [self.nativeAd makeRequest:request];
          } else {
              NSDictionary *userInfo =
              @{
                NSLocalizedFailureReasonErrorKey: @"BidMachine request type not satisfying",
                NSLocalizedDescriptionKey: @"BidMachineRewardedVideoCustomEvent requires to use BDMRewardedRequest",
                NSLocalizedRecoverySuggestionErrorKey: @"Check that you pass keywords and extras to MPInterstitialAdController from BDMRewardedRequest"
                };
              NSError *error =  [NSError errorWithDomain:kAdapterErrorDomain
                                                    code:BidMachineAdapterErrorCodeMissingSellerId
                                                userInfo:userInfo];
              MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.networkId);
              [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
          }
      } else {
          __weak typeof(self) weakSelf = self;
          [BidMachineAdapterUtils.sharedUtils initializeBidMachineSDKWithCustomEventInfo:info completion:^(NSError *error) {
              NSMutableDictionary *extraInfo = weakSelf.localExtras.mutableCopy ?: [NSMutableDictionary new];
              [extraInfo addEntriesFromDictionary:info];
              
              NSArray *priceFloors = extraInfo[@"priceFloors"] ?: @[];
              BDMNativeAdRequest *request = [[BidMachineAdapterUtils sharedUtils] nativeAdRequestWithExtraInfo:extraInfo
                                                                                                      location:nil
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
