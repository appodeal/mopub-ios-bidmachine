//
//  Banner.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"
#import <mopub-ios-sdk/MoPub.h>

#define UNIT_ID         "1832ce06de91424f8f81f9f5c77f7efd"

@interface Banner ()<MPAdViewDelegate>

@property (nonatomic, strong) MPAdView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    CGSize adViewSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
    kMPPresetMaxAdSize90Height :
    kMPPresetMaxAdSize50Height;
    
    [self.bannerView setLocalExtras:self.extras];
    [self.bannerView loadAdWithMaxAdSize:adViewSize];
}

- (void)showAd:(id)sender {
    [self addBannerInContainer];
}

- (MPAdView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[MPAdView alloc] initWithAdUnitId:@UNIT_ID];
        _bannerView.delegate = self;
        _bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bannerView;
}

- (void)addBannerInContainer {
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.container addSubview:self.bannerView];
    [NSLayoutConstraint activateConstraints:
    @[
      [self.bannerView.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor],
      [self.bannerView.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor],
      [self.bannerView.widthAnchor constraintEqualToAnchor:self.container.widthAnchor],
      [self.bannerView.heightAnchor constraintEqualToConstant:50]
      ]];
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

#pragma mark - MPAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    NSLog(@"adViewDidReceiveAd");
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    NSLog(@"adViewWillPresentScreen");
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    NSLog(@"adViewDidDismissScreen");
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    NSLog(@"adViewWillLeaveApplication");
}

@end
