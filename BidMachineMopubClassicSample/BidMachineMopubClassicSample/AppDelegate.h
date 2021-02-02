//
//  AppDelegate.h
//  BMIntegrationSample
//
//  Created by Yaroslav Skachkov on 3/1/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mopub-ios-sdk/MoPub.h>

@import BidMachine;
@import BidMachine.ExternalAdapterUtils;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSDictionary *)localExtras;

@end

