//
//  ViewController.m
//  BMIntegrationSample
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "ViewController.h"
#import <mopub-ios-sdk/MoPub.h>


@interface ViewController () <MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>

@property (nonatomic, strong) MPAdView *adView;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;
@property (nonatomic, strong) MPRewardedVideo *rewarded;

@end

@implementation ViewController

- (IBAction)loadAdButtonTapped:(id)sender {
    CGSize adViewSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
        kMPPresetMaxAdSize90Height :
        kMPPresetMaxAdSize50Height;
    // You can pass local extras to BidMachine through MoPub API
    NSDictionary *localExtras = @{};
//    NSDictionary *localExtras = @{
//                                  @"seller_id": @"1",
//                                  @"coppa": @"true",
//                                  @"consent_string": @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
//                                  @"endpoint" : @"some_url_endpoint",
//                                  @"logging_enabled": @"true",
//                                  @"test_mode": @"true",
//                                  @"banner_width": @"320",
//                                  @"userId": @"user123",
//                                  @"gender": @"F",
//                                  @"yob": @2000,
//                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
//                                  @"country": @"USA",
//                                  @"city": @"Los Angeles",
//                                  @"zip": @"90001–90084",
//                                  @"sturl": @"https://store_url.com",
//                                  @"paid": @"true",
//                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
//                                  @"badv": @"https://domain_1.com,https://domain_2.org",
//                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
//                                  @"priceFloors": @[
//                                          @{ @"id_1": @300.06 },
//                                          @{ @"id_2": @1000 },
//                                          @302.006,
//                                          @1002
//                                          ]
//                                  };
    
    // Remove previous banner from superview if needed
    if (self.adView) {
        [self.adView removeFromSuperview];
    }
    // You can use test ad unit id - 1832ce06de91424f8f81f9f5c77f7efd - to test banner ad.
//    self.adView = [[MPAdView alloc] initWithAdUnitId:@"1832ce06de91424f8f81f9f5c77f7efd"];
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"YOUR_AD_UNIT_ID"];
    self.adView.translatesAutoresizingMaskIntoConstraints = false;
    self.adView.delegate = self;
    [self.adView setLocalExtras:localExtras];
    [self.adView loadAdWithMaxAdSize:adViewSize];
}

- (IBAction)loadInterstitialButtonTapped:(id)sender {
    // You can pass local extras to BidMachine through MoPub API
    NSDictionary *localExtras = @{};
//    NSDictionary *localExtras = @{
//                                  @"seller_id": @"1",
//                                  @"coppa": @"true",
//                                  @"consent_string": @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
//                                  @"endpoint" : @"some_url_endpoint",
//                                  @"logging_enabled": @"true",
//                                  @"test_mode": @"true",
//                                  @"ad_content_type": @"All",
//                                  @"userId": @"user123",
//                                  @"gender": @"F",
//                                  @"yob": @2000,
//                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
//                                  @"country": @"USA",
//                                  @"city": @"Los Angeles",
//                                  @"zip": @"90001–90084",
//                                  @"sturl": @"https://store_url.com",
//                                  @"paid": @"true",
//                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
//                                  @"badv": @"https://domain_1.com,https://domain_2.org",
//                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
//                                  @"priceFloors": @[
//                                          @{ @"id_1": @300.06 },
//                                          @{ @"id_2": @1000 },
//                                          @302.006,
//                                          @1002
//                                          ]
//                                  };
//
    // You can use test ad unit id - ec95ba59890d4fda90a4acf0071ed8b5 - to test interstitial ad.
//    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"ec95ba59890d4fda90a4acf0071ed8b5"];
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"YOUR_AD_UNIT_ID"];
    self.interstitial.delegate = self;
    [self.interstitial setLocalExtras:localExtras];
    [self.interstitial loadAd];
}

- (IBAction)loadRewardedButtonTapped:(id)sender {
    // You can pass local extras to BidMachine through MoPub API
    NSDictionary *localExtras = @{};
//    NSDictionary *localExtras = @{
//                                  @"seller_id": @"1",
//                                  @"coppa": @"true",
//                                  @"consent_string": @"BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA",
//                                  @"endpoint" : @"some_url_endpoint",
//                                  @"logging_enabled": @"true",
//                                  @"test_mode": @"true",
//                                  @"userId": @"user123",
//                                  @"gender": @"F",
//                                  @"yob": @2000,
//                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
//                                  @"country": @"USA",
//                                  @"city": @"Los Angeles",
//                                  @"zip": @"90001–90084",
//                                  @"sturl": @"https://store_url.com",
//                                  @"paid": @"true",
//                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
//                                  @"badv": @"https://domain_1.com,https://domain_2.org",
//                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
//                                  @"priceFloors": @[
//                                          @{ @"id_1": @300.06 },
//                                          @{ @"id_2": @1000 },
//                                          @302.006,
//                                          @1002
//                                          ]
//                                  };
    
    // You can use test ad unit id - b94009cbb6b7441eb097142f1cb5e642 - to test rewarded ad.
//    [MPRewardedVideo setDelegate:self forAdUnitId:@"b94009cbb6b7441eb097142f1cb5e642"];
    [MPRewardedVideo setDelegate:self forAdUnitId:@"YOUR_AD_UNIT_ID"];
//    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@"b94009cbb6b7441eb097142f1cb5e642"
//                                            keywords:nil
//                                    userDataKeywords:nil
//                                            location:nil
//                                          customerId:nil
//                                   mediationSettings:nil
//                                         localExtras:localExtras];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@"YOUR_AD_UNIT_ID"
                                            keywords:nil
                                    userDataKeywords:nil
                                            location:nil
                                          customerId:nil
                                   mediationSettings:nil
                                         localExtras:localExtras];
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize{
    NSLog(@"Banner was loaded! Banner width: %f, height: %f", adSize.width, adSize.height);
    [self.view addSubview:self.adView];
    [NSLayoutConstraint activateConstraints:
     @[
       [self.adView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
       [self.adView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
       [self.adView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
       [self.adView.heightAnchor constraintEqualToConstant:adSize.height]
       ]];
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    NSLog(@"Banner failed to load ad with error: %@", error.localizedDescription);
}

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"Rewarded video did load ad for ad unit id %@", adUnitID);
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:adUnitID fromViewController:self withReward:nil];
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    [self.interstitial showFromViewController:self];
}

@end
