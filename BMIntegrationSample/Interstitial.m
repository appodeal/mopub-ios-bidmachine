//
//  Interstitial.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"
#import <mopub-ios-sdk/MoPub.h>


#define UNIT_ID         "ec95ba59890d4fda90a4acf0071ed8b5"

@interface Interstitial ()<MPInterstitialAdControllerDelegate>

@property (nonatomic, strong) MPInterstitialAdController *interstitial;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    [self.interstitial setLocalExtras:self.extras];
    [self.interstitial loadAd];
}

- (void)showAd:(id)sender {
    [self.interstitial showFromViewController:self];
}

- (MPInterstitialAdController *)interstitial {
    if (!_interstitial) {
        _interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@UNIT_ID];
        _interstitial.delegate = self;
        
    }
    return _interstitial;
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

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidReceiveAd");
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error {
    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialWillPresentScreen");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidPresentScreen");
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialWillDismissScreen");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidExpired");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidTrackUserInteraction");
}

@end
