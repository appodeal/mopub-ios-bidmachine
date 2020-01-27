//
//  NativeAdView.m
//  BMIntegrationSample
//
//  Created by Ilia Lozhkin on 11/26/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "NativeAdView.h"

@interface NativeAdView()

@property (weak, nonatomic) IBOutlet UILabel *nativeMainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeTitleTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nativeIconImageView;
@property (weak, nonatomic) IBOutlet UIView *nativeVideoView;
@property (weak, nonatomic) IBOutlet UILabel *nativeCallToActionTextLabel;

@end

@implementation NativeAdView

+ (UINib *)nibForAd {
    return [UINib nibWithNibName:@"NativeAdView" bundle:[NSBundle bundleForClass:self]];
}

@end
