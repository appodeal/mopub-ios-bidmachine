//
//  BidMachineNativeAdAdapter.h
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
    #import <MoPubSDKFramework/MoPub.h>
#else
    #import "MPNativeAdAdapter.h"
#endif

@import BidMachine;


@interface BidMachineNativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, readonly) BDMNativeAd *ad;

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

+ (instancetype)nativeAdAdapterWithAd:(BDMNativeAd *)ad;

@end
