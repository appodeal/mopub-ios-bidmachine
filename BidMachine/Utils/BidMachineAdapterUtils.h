//
//  BidMachineAdapterUtils.h
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#if __has_include(<BidMachine/BidMachine.h>)
#import <BidMachine/BidMachine.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BidMachineAdapterUtils : NSObject

+ (instancetype)sharedUtils;

- (void)initializeBidMachineSDKWithCustomEventInfo:(NSDictionary *)info
                                        completion:(void(^)(NSError *))completion;

@end

NS_ASSUME_NONNULL_END
