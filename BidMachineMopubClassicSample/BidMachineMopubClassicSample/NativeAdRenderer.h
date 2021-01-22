//
//  NativeAdRenderer.h
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mopub-ios-sdk/MoPub.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeAdRenderer : NSObject

+ (void)renderAd:(MPNativeAd *)ad onView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
