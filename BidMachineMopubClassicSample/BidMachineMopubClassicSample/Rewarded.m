//
//  Rewarded.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"
#import <mopub-ios-sdk/MoPub.h>

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
                                         localExtras:self.extras];
}

- (void)showAd:(id)sender {
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:@UNIT_ID fromViewController:self withReward:nil];
}

#pragma mark - Extras

- (NSDictionary *)extras {
    NSDictionary *localExtras = @{};
//    NSDictionary *localExtras = @{
//        @"seller_id": @"1",
//        @"coppa": @"true",
//        @"consent_string": @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
//        @"endpoint" : @"some_url_endpoint",
//        @"logging_enabled": @"true",
//        @"test_mode": @"true",
//        @"banner_width": @"320",
//        @"userId": @"user123",
//        @"gender": @"F",
//        @"yob": @2000,
//        @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
//        @"country": @"USA",
//        @"city": @"Los Angeles",
//        @"zip": @"90001–90084",
//        @"sturl": @"https://store_url.com",
//        @"paid": @"true",
//        @"bcat": @"IAB-1,IAB-3,IAB-5",
//        @"badv": @"https://domain_1.com,https://domain_2.org",
//        @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
//        @"priceFloors": @[
//                @{ @"id_1": @300.06 },
//                @{ @"id_2": @1000 },
//                @302.006,
//                @1002
//        ]
//    };
    return localExtras;
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
