//
//  BidMachineFetcher.m
//  BidMachine
//
//  Created by Stas Kochkin on 29/08/2019.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineFetcher.h"
#import "BidMachineConstants.h"


@interface BDMRequest (Adapter)

- (void)registerDelegate:(id<BDMRequestDelegate>)delegate;

@end


@interface BidMachineFetcher () <BDMRequestDelegate>

@property (nonatomic, strong) NSMapTable <NSString *, BDMRequest *> *requestByBidId;
@property (nonatomic, strong) NSMapTable <BDMRequest *, NSString *> *bidIdByRequest;

@property (nonatomic, strong) NSNumberFormatter *formatter;

@end


@implementation BidMachineFetcher

- (instancetype)initPrivately {
    self = [super init];
    return self;
}

+ (instancetype)sharedFetcher {
    static BidMachineFetcher *_sharedFetcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFetcher = [[BidMachineFetcher alloc] initPrivately];
    });
    return _sharedFetcher;
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSNumberFormatter new];
        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
        _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _formatter.roundingMode = NSNumberFormatterRoundCeiling;
        _formatter.positiveFormat = @"0.00";
    }
    return _formatter;
}

- (NSMapTable<NSString *,BDMRequest *> *)requestByBidId {
    if (!_requestByBidId) {
        _requestByBidId = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _requestByBidId;
}

- (NSMapTable<BDMRequest *,NSString *> *)bidIdByRequest {
    if (!_bidIdByRequest) {
        _bidIdByRequest = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _bidIdByRequest;
}

- (void)setRoundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    self.formatter.roundingMode = roundingMode;
}

- (NSNumberFormatterRoundingMode)roundingMode {
    return self.formatter.roundingMode;
}

- (void)setFormat:(NSString *)format {
    self.formatter.positiveFormat = format;
}

- (NSString *)format {
    return self.formatter.positiveFormat;
}

- (NSDictionary<NSString *,id> *)fetchParamsFromRequest:(BDMRequest *)request {
    if (!request.info.bidID) {
        return nil;
    }
    
    [request registerDelegate:self];
    [self associateRequest:request bidId:request.info.bidID];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[kBidMachineBidId] = request.info.bidID;
    params[kBidMachinePrice] = [self.formatter stringFromNumber:request.info.price];
    return params;
}

- (id)requestForBidId:(NSString *)bidId {
    BDMRequest *request = [self.requestByBidId objectForKey:bidId];
    [self removeBidId:bidId];
    return request;
}

#pragma mark - Storage

- (void)associateRequest:(BDMRequest *)request bidId:(NSString *)bidId {
    [self.requestByBidId setObject:request forKey:bidId];
    [self.bidIdByRequest setObject:bidId forKey:request];
}

- (void)removeRequest:(BDMRequest *)request {
    NSString *bidId = [self.bidIdByRequest objectForKey:request];
    [self.bidIdByRequest removeObjectForKey:request];
    [self.requestByBidId removeObjectForKey:bidId];
}

- (void)removeBidId:(NSString *)bidId {
    BDMRequest *request = [self.requestByBidId objectForKey:bidId];
    [self.bidIdByRequest removeObjectForKey:request];
    [self.requestByBidId removeObjectForKey:bidId];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {}
- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {}

- (void)requestDidExpire:(BDMRequest *)request {
    [self removeRequest:request];
}

@end
