//
//  Native.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Native.h"
#import "NativeAdView.h"
#import "NativeAdRenderer.h"
#import "BidMachineNativeAdRenderer.h"
#import <mopub-ios-sdk/MoPub.h>

#define UNIT_ID         "7c3f8de23b9d4b7ab45a53ed2c3cb0c8"

@interface Native ()<MPNativeAdDelegate>

@property (nonatomic, strong) MPNativeAdRequest *nativeAdRequest;
@property (nonatomic, strong) MPNativeAd *nativeAd;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Native

- (void)loadAd:(id)sender {
    self.nativeAdRequest = [self request];
    __weak typeof(self) weakSelf = self;
    [self.nativeAdRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (!error) {
            weakSelf.nativeAd = response;
            NSLog(@"Native ad did load");
        } else {
            NSLog(@"Native ad fail to load with error: %@", error.localizedDescription);
        }
    }];
}

- (void)showAd:(id)sender {
    self.nativeAd.delegate = self;
    [NativeAdRenderer renderAd:self.nativeAd onView:self.container];
}

- (MPStaticNativeAdRendererSettings *)rendererSettings {
    MPStaticNativeAdRendererSettings *rendererSettings = MPStaticNativeAdRendererSettings.new;
    rendererSettings.renderingViewClass = NativeAdView.class;
    return rendererSettings;
}

- (MPNativeAdRendererConfiguration *)rendererConfiguration {
    return [BidMachineNativeAdRenderer rendererConfigurationWithRendererSettings:self.rendererSettings];
}

- (MPNativeAdRequest *)request {
    MPNativeAdRequest *request = [MPNativeAdRequest requestWithAdUnitIdentifier:@UNIT_ID rendererConfigurations:@[self.rendererConfiguration]];
    MPNativeAdRequestTargeting *targeting = MPNativeAdRequestTargeting.targeting;
    targeting.localExtras = self.extras;
    return request;
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

#pragma mark - MPNativeAdDelegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"Native ad will present modal view");
}

- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"Native ad did dismiss modal view");
}

- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd {
    NSLog(@"Native ad will leave application");
}

- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData {
    NSLog(@"Native ad did track impression");
}

@end
