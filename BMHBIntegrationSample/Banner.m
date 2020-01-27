//
//  Banner.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"
#import "BidMachineFetcher.h"
#import "BidMachineKeywordsTransformer.h"

#import <mopub-ios-sdk/MoPub.h>
#import <BidMachine/BidMachine.h>

#define UNIT_ID         "1832ce06de91424f8f81f9f5c77f7efd"

@interface Banner ()<BDMRequestDelegate, MPAdViewDelegate>

@property (nonatomic, strong) MPAdView *bannerView;
@property (nonatomic, strong) BDMBannerRequest *request;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    self.request = [BDMBannerRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self addBannerInContainer];
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

#pragma mark - MoPub

///  Create and configure instance of MPAdView
/// pass keywords for matching with MoPub line items ad units
/// and starts MoPub mediation
/// @param keywords keywords BidMachine adapter defined keywords
/// for matching line item
/// @param extras extras BidMachine adapter defined extrass
/// for matching pending request with recieved line item
- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    CGSize adViewSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kMPPresetMaxAdSize90Height : kMPPresetMaxAdSize50Height;
    // Remove previous banner from superview if needed
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
    self.bannerView = [[MPAdView alloc] initWithAdUnitId:@UNIT_ID];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.delegate = self;
    [self.bannerView setLocalExtras:extras];
    [self.bannerView setKeywords:keywords];
    [self.bannerView loadAdWithMaxAdSize:adViewSize];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Get extras from fetcher
    // After whith call fetcher will has strong ref on request
    NSDictionary *extras = [BidMachineFetcher.sharedFetcher fetchParamsFromRequest:request];
    // Extras can be transformer into keywords for line item matching
    // by use BidMachineKeywordsTransformer
    BidMachineKeywordsTransformer *transformer = [BidMachineKeywordsTransformer new];
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
