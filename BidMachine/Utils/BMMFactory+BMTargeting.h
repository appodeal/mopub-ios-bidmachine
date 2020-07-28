//
//  BMMFactory+BMTargeting.h
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMFactory.h"
#import <BidMachine/BidMachine.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMMFactory (BMTargeting)

- (BDMTargeting *)targetingFromExtraInfo:(NSDictionary *)extraInfo;

- (BDMUserRestrictions *)userRestrictionsFromExtraInfo:(NSDictionary *)extras;

- (BOOL)subjectToGDPR;

@end

NS_ASSUME_NONNULL_END
