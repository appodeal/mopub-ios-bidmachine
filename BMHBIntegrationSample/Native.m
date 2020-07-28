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
#import "BMMKeywordsTransformer.h"

#import <mopub-ios-sdk/MoPub.h>
#import <BidMachine/BidMachine.h>

#define UNIT_ID         "7c3f8de23b9d4b7ab45a53ed2c3cb0c8"

@interface Native ()<BDMRequestDelegate, MPNativeAdDelegate>

@property (nonatomic, strong) MPNativeAdRequest *nativeAdRequest;
@property (nonatomic, strong) MPNativeAd *nativeAd;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, strong) BDMNativeAdRequest *request;

@end

@implementation Native

- (void)loadAd:(id)sender {
    self.request = [BDMNativeAdRequest new];
    [self.request performWithDelegate:self];
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

#pragma mark - MoPub

///  Create and configure instance of MPNativeAd
/// pass keywords for matching with MoPub line items ad units
/// and starts MoPub mediation
/// @param keywords keywords BidMachine adapter defined keywords
/// for matching line item
/// @param extras extras BidMachine adapter defined extrass
/// for matching pending request with recieved line item
- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    self.nativeAdRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:@UNIT_ID rendererConfigurations:@[self.rendererConfiguration]];
    MPNativeAdRequestTargeting *targeting = MPNativeAdRequestTargeting.targeting;
    targeting.localExtras = extras;
    
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

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BDMFetcher.shared fetchParamsFromRequest:request];
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
