//
//  BidMachineFetcher.h
//  BidMachine
//
//  Created by Stas Kochkin on 29/08/2019.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BidMachine.h>


NS_ASSUME_NONNULL_BEGIN

/**
 Cache for BidMachine request
 */
@interface BidMachineFetcher : NSObject

@property (nonatomic, assign) NSNumberFormatterRoundingMode roundingMode;
@property (nonatomic, copy) NSString *format;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 @return Singletone
 */
+ (instancetype)sharedFetcher;

- (nullable NSDictionary <NSString *, id> *)fetchParamsFromRequest:(BDMRequest *)request;

- (nullable id)requestForBidId:(NSString *)bidId;

@end

NS_ASSUME_NONNULL_END
