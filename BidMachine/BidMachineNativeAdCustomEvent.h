//
//  BidMachineNativeAdCustomEvent.h
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
#import <MoPubSDKFramework/MoPub.h>
#else
#import "MPNativeCustomEvent.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BidMachineNativeAdCustomEvent : MPNativeCustomEvent

@end

NS_ASSUME_NONNULL_END
