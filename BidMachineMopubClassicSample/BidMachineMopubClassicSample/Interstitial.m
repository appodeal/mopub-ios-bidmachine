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
    [self.interstitial setLocalExtras:AppDelegate.localExtras];
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
