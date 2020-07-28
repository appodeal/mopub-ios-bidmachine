//
//  BMMUtils.h
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMMUtils : NSObject

+ (instancetype)shared;

- (void)initializeBidMachineSDKWithCustomEventInfo:(NSDictionary *)info
                                        completion:(void(^)(NSError *))completion;

@end

NS_ASSUME_NONNULL_END
