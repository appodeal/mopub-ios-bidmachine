//
//  NativeAdRenderer.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "NativeAdRenderer.h"
#import "NativeAdView.h"

@implementation NativeAdRenderer

+ (void)renderAd:(MPNativeAd *)ad onView:(UIView *)view {
    NSError *error = nil;
    UIView *nativeAdView = [ad retrieveAdViewWithError:&error];
    if (error) {
        NSLog(@"Native ad fail to present with error: %@", error.localizedDescription);
    } else {
        [self replaceNativeAdView:nativeAdView inPlaceholder:view];
    }
}

+ (void)replaceNativeAdView:(UIView *)nativeAdView
              inPlaceholder:(UIView *)placeholder {
    // Remove anything currently in the placeholder.
    [placeholder.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!nativeAdView) {
        return;
    }
    
    // Add new ad view and set constraints to fill its container.
    [placeholder addSubview:nativeAdView];
    nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(nativeAdView);
    [placeholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nativeAdView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewDictionary]];
    [placeholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nativeAdView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewDictionary]];
}

@end
