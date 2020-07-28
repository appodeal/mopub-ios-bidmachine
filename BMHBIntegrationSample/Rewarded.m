//
//  Rewarded.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"
#import "BMMFetcher.h"
#import "BMMKeywordsTransformer.h"

#import <mopub-ios-sdk/MoPub.h>
#import <BidMachine/BidMachine.h>

#define UNIT_ID         "b94009cbb6b7441eb097142f1cb5e642"

@interface Rewarded ()<BDMRequestDelegate, MPRewardedVideoDelegate>

@property (nonatomic, strong) BDMRewardedRequest *request;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    self.request = [BDMRewardedRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:@UNIT_ID fromViewController:self withReward:nil];
}

#pragma mark - MoPub

/// Invoke MPRewardedVideo load ad method
/// pass keywords for matching with MoPub line items ad units
/// and starts MoPub mediation
/// @param keywords keywords BidMachine adapter defined keywords
/// for matching line item
/// @param extras extras BidMachine adapter defined extrass
/// for matching pending request with recieved line item
- (void)loadMoPubAdWithKeywords:(NSString *)keywords extras:(NSDictionary *)extras {
    [MPRewardedVideo setDelegate:self forAdUnitId:@UNIT_ID];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@UNIT_ID
                                            keywords:keywords
                                    userDataKeywords:nil
                                          customerId:nil
                                   mediationSettings:nil
                                         localExtras:extras];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Get extras from fetcher
    // You can fetch request with fetcher (wo presets)
    // After whith call fetcher will has strong ref on request
    BMMFetcher *rewarded= ({
        BMMFetcher *fetcher = BMMFetcher.new;
        fetcher.format = @"0.04";
        fetcher.roundingMode = kCFNumberFormatterRoundUp;
        fetcher;
    });
    NSDictionary *extras = [BDMFetcher.shared fetchParamsFromRequest:request fetcher:rewarded];
    // Extras can be transformer into keywords for line item matching
    // by use BidMachineKeywordsTransformer
    BMMKeywordsTransformer *transformer = [BMMKeywordsTransformer new];
    NSString *keywords = [transformer transformedValue:extras];
    // Here we define which MoPub ad should be loaded
    [self loadMoPubAdWithKeywords:keywords extras:extras];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
}

- (void)requestDidExpire:(BDMRequest *)request {}

#pragma mark - MPRewardedVideoDelegate

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:didReceiveAd");
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"rewarded:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedDidExpired");
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"rewarded:didFailToPlayAdAdWithError: %@", [error localizedDescription]);
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:WillPresentScreen");
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:DidPresentScreen");
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:WillDismissScreen");
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:DidDismissScreen");
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:DidTrackUserInteraction");
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewarded:WillWillLeaveApplication");
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"rewarded: received with currency %@ , amount %lf", reward.currencyType, [reward.amount doubleValue]);
}

@end
