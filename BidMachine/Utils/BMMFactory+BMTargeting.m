//
//  BMMFactory+BMTargeting.m
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMFactory+BMTargeting.h"
#import "BMMTransformer.h"

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#elif __has_include(<mopub-ios-sdk/MoPub.h>)
#import <mopub-ios-sdk/MoPub.h>
#else
#import <MoPubSDKFramework/MoPub.h>
#endif

@implementation BMMFactory (BMTargeting)

- (BDMTargeting *)targetingFromExtraInfo:(NSDictionary *)extraInfo {
    BDMTargeting * targeting = [BDMTargeting new];
    if (extraInfo) {
        NSString *userId = extraInfo[@"userId"] ?: extraInfo[@"user_id"];
        (!userId) ?: [targeting setUserId:userId];
        (!extraInfo[@"gender"]) ?: [targeting setGender:[BMMTransformer userGenderFromValue:extraInfo[@"gender"]]];
        (!extraInfo[@"yob"]) ?: [targeting setYearOfBirth:extraInfo[@"yob"]];
        (!extraInfo[@"keywords"]) ?: [targeting setKeywords:extraInfo[@"keywords"]];
        (!extraInfo[@"bcat"]) ?: [targeting setBlockedCategories:[extraInfo[@"bcat"] componentsSeparatedByString:@","]];
        (!extraInfo[@"badv"]) ?: [targeting setBlockedAdvertisers:[extraInfo[@"badv"] componentsSeparatedByString:@","]];
        (!extraInfo[@"bapps"]) ?: [targeting setBlockedApps:[extraInfo[@"bapps"] componentsSeparatedByString:@","]];
        (!extraInfo[@"country"]) ?: [targeting setCountry:extraInfo[@"country"]];
        (!extraInfo[@"city"]) ?: [targeting setCity:extraInfo[@"city"]];
        (!extraInfo[@"zip"]) ?: [targeting setZip:extraInfo[@"zip"]];
        (!extraInfo[@"sturl"]) ?: [targeting setStoreURL:[NSURL URLWithString:extraInfo[@"sturl"]]];
        (!extraInfo[@"stid"]) ?: [targeting setStoreId:extraInfo[@"stid"]];
        (!extraInfo[@"paid"]) ?: [targeting setPaid:[extraInfo[@"paid"] boolValue]];
    }
    return targeting;
}

- (BDMUserRestrictions *)userRestrictionsFromExtraInfo:(NSDictionary *)extras {
    BDMUserRestrictions *restrictions = [BDMUserRestrictions new];
    [restrictions setHasConsent:MoPub.sharedInstance.canCollectPersonalInfo];
    [restrictions setSubjectToGDPR:self.subjectToGDPR];
    [restrictions setConsentString: extras[@"consent_string"]];
    [restrictions setCoppa:[extras[@"coppa"] boolValue]];
    return restrictions;
}

- (BOOL)subjectToGDPR {
    MPBool isGDPRApplicable = MoPub.sharedInstance.isGDPRApplicable;
    switch (isGDPRApplicable) {
        case MPBoolYes: return YES; break;
        default:        return NO;  break;
    }
}



@end
