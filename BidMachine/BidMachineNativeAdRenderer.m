//
//  BidMachineNativeAdRenderer.m
//  BidMachine
//
//  Created by Ilia Lozhkin on 11/20/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineNativeAdRenderer.h"
#import "BidMachineNativeAdAdapter.h"

#if __has_include("MoPub.h")
#import "MPNativeAdError.h"
#import "MPNativeAdRendererConfiguration.h"
#import "MPNativeAdRendering.h"
#import "MPStaticNativeAdRendererSettings.h"
#endif

@interface BidMachineNativeAdRendering : NSObject <BDMNativeAdRendering>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *callToActionLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIView *mediaContainerView;
@property (nonatomic, weak) UIView *adChoiceView;
@property (nonatomic, weak) UIView<MPNativeAdRendering> *adRendering;

+ (instancetype)nativeAdRenderingWith:(UIView<MPNativeAdRendering> *)rendering;

@end

@interface BidMachineNativeAdRenderer ()

@property (nonatomic, strong) BidMachineNativeAdRendering *adRendering;
@property (nonatomic, strong) Class renderingViewClass;

@end

@implementation BidMachineNativeAdRenderer

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings {
    MPNativeAdRendererConfiguration *config = [[MPNativeAdRendererConfiguration alloc] init];
    config.rendererClass = [self class];
    config.rendererSettings = rendererSettings;
    config.supportedCustomEvents = @[@"BidMachineNativeAdCustomEvent"];
    return config;
}

- (instancetype)initWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings {
    if (self = [super init]) {
        MPStaticNativeAdRendererSettings *settings = (MPStaticNativeAdRendererSettings *)rendererSettings;
        _renderingViewClass = settings.renderingViewClass;
        _viewSizeHandler = [settings.viewSizeHandler copy];
    }
    return self;
}

- (UIView *)retrieveViewWithAdapter:(id<MPNativeAdAdapter>)adapter error:(NSError *__autoreleasing *)error {
    if (!adapter || ![adapter isKindOfClass:[BidMachineNativeAdAdapter class]] || !self.renderingViewClass) {
        if (error) {
            *error = MPNativeAdNSErrorForRenderValueTypeError();
        }
        
        return nil;
    }
    
    UIView<MPNativeAdRendering> * adView;
    if ([self.renderingViewClass respondsToSelector:@selector(nibForAd)]) {
        adView = (UIView<MPNativeAdRendering> *)[[[self.renderingViewClass nibForAd] instantiateWithOwner:nil options:nil] firstObject];
    } else {
        adView = [[self.renderingViewClass alloc] init];
    }
    
    self.adRendering = [BidMachineNativeAdRendering nativeAdRenderingWith:adView];
    adView.translatesAutoresizingMaskIntoConstraints = YES;
    adView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [[(BidMachineNativeAdAdapter *)adapter ad] unregisterViews];
    [[(BidMachineNativeAdAdapter *)adapter ad] presentOn:adView
                                          clickableViews:@[]
                                             adRendering:self.adRendering
                                              controller:[adapter.delegate viewControllerForPresentingModalView]
                                                   error:error];
    
    
    return adView;
    
}

@end

@implementation BidMachineNativeAdRendering

+ (instancetype)nativeAdRenderingWith:(UIView<MPNativeAdRendering> *)rendering;
{
    return [[self alloc] initWithRendering:rendering];
}

- (instancetype)initWithRendering:(UIView<MPNativeAdRendering> *)rendering {
    if (self = [super init]) {
        if ([rendering respondsToSelector:@selector(nativeTitleTextLabel)]) {
            _titleLabel = rendering.nativeTitleTextLabel;
        }
        if ([rendering respondsToSelector:@selector(nativeMainTextLabel)]) {
            _descriptionLabel = rendering.nativeMainTextLabel;
        }
        if ([rendering respondsToSelector:@selector(nativeCallToActionTextLabel)]) {
            _callToActionLabel = rendering.nativeCallToActionTextLabel;
        }
        if ([rendering respondsToSelector:@selector(nativeIconImageView)]) {
            _iconView = rendering.nativeIconImageView;
        }
        if ([rendering respondsToSelector:@selector(nativeMainImageView)]) {
            _mediaContainerView = rendering.nativeMainImageView;
        } else if ([rendering respondsToSelector:@selector(nativeVideoView)]) {
             _mediaContainerView = rendering.nativeVideoView;
        }
        
        if ([rendering respondsToSelector:@selector(nativePrivacyInformationIconImageView)]) {
            _adChoiceView = rendering.nativePrivacyInformationIconImageView;
        }
        _adRendering = rendering;
    }
    return self;
}

- (void)setStarRating:(NSNumber *)rating {
    if ([self.adRendering respondsToSelector:@selector(layoutStarRating:)]) {
        [self.adRendering layoutStarRating:rating];
    }
}

@end
