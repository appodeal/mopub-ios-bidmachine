//
//  Rewarded.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

#define UNIT_ID         "b94009cbb6b7441eb097142f1cb5e642"

@interface Rewarded ()<MPRewardedVideoDelegate>

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [MPRewardedVideo setDelegate:self forAdUnitId:@UNIT_ID];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@UNIT_ID
                                            keywords:nil
                                    userDataKeywords:nil
                                          customerId:nil
                                   mediationSettings:nil
                                         localExtras:AppDelegate.localExtras];
}

- (void)showAd:(id)sender {
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:@UNIT_ID fromViewController:self withReward:nil];
}

#pragma mark - MPRewardedVideoDelegate

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"interstitialDidReceiveAd");
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
    NSLog(@"rewardedWillPresentScreen");
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedDidPresentScreen");
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedWillDismissScreen");
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedDidDismissScreen");
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedDidTrackUserInteraction");
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedWillWillLeaveApplication");
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"Reward received with currency %@ , amount %lf", reward.currencyType, [reward.amount doubleValue]);
}

@end
