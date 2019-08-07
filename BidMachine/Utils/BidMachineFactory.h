//
//  BidMachineFactory.h
//  BidMachine
//
//  Created by Yaroslav Skachkov on 3/6/19.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#if __has_include(<BidMachine/BidMachine.h>)
#import <BidMachine/BidMachine.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BidMachineFactory : NSObject

+ (instancetype)sharedFactory;

- (void)initializeBidMachineSDKWithCustomEventInfo:(NSDictionary *)info
                                        completion:(void(^)(void))completion;
- (BDMTargeting *)setupTargetingWithExtraInfo:(NSDictionary *)extraInfo andLocation:(CLLocation * _Nullable)location;
- (BDMUserRestrictions *)setupUserRestrictionsWithExtraInfo:(NSDictionary *)extras;
- (NSArray<BDMPriceFloor *> *)makePriceFloorsWithPriceFloors:(NSArray *)priceFloors;
- (NSString *)transfromSellerID:(id)sellerId;

@end

NS_ASSUME_NONNULL_END
