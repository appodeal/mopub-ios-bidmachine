//
//  Banner.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"

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
    
    [self.bannerView setLocalExtras:AppDelegate.localExtras];
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
