//
//  BMMFactory.m
//  BMHBIntegrationSample
//
//  Created by Ilia Lozhkin on 27.07.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMMFactory.h"

@implementation BMMFactory

+ (instancetype)sharedFactory {
    static dispatch_once_t onceToken;
    static id _sharedFactory;
    dispatch_once(&onceToken, ^{
        _sharedFactory = BMMFactory.new;
    });
    
    return _sharedFactory;
}

@end
