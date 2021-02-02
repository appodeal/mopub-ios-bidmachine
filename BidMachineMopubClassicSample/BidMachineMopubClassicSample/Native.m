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
    Class<MPNativeAdRenderer> cls = NSClassFromString(@"BidMachineNativeAdRenderer");
    return [cls rendererConfigurationWithRendererSettings:self.rendererSettings];
}

- (MPNativeAdRequest *)request {
    MPNativeAdRequest *request = [MPNativeAdRequest requestWithAdUnitIdentifier:@UNIT_ID rendererConfigurations:@[self.rendererConfiguration]];
    MPNativeAdRequestTargeting *targeting = MPNativeAdRequestTargeting.targeting;
    targeting.localExtras = AppDelegate.localExtras;
    return request;
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
