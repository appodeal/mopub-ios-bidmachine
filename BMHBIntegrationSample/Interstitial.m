//
//  Interstitial.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"
#import "BMMKeywordsTransformer.h"

#import <mopub-ios-sdk/MoPub.h>
#import <BidMachine/BidMachine.h>


#define UNIT_ID         "ec95ba59890d4fda90a4acf0071ed8b5"

@interface Interstitial ()<BDMRequestDelegate, MPInterstitialAdControllerDelegate>

@property (nonatomic, strong) MPInterstitialAdController *interstitial;
@property (nonatomic, strong) BDMInterstitialRequest *request;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    self.request = [BDMInterstitialRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self.interstitial showFromViewController:self];
}

#pragma mark - MoPub

/// Create instance of MPInterstitialAdController
/// pass keywords for matching with MoPub line items ad units
/// and starts MoPub mediation
/// @param keywords keywords BidMachine adapter defined keywords
/// for matching line item
/// @param extras extras BidMachine adapter defined extrass
/// for matching pending request with recieved line item
- (void)loadMoPubAdWithKeywords:(NSString *)keywords
                         extras:(NSDictionary *)extras {
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@UNIT_ID];
    [self.interstitial setDelegate:self];
    [self.interstitial setLocalExtras:extras];
    [self.interstitial setKeywords:keywords];
    
    [self.interstitial loadAd];
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
