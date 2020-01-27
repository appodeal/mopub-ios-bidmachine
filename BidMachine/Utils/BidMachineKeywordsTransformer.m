//
//  BidMachineKeywordsTransformer.m
//  BidMachine
//
//  Created by Stas Kochkin on 29/08/2019.
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "BidMachineKeywordsTransformer.h"
#import <StackFoundation/StackFoundation.h>


@implementation BidMachineKeywordsTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (![value isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    NSMutableArray *keywords = [NSMutableArray arrayWithCapacity:[(NSDictionary *)value count]];
    [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *keyword = [NSString stringWithFormat:@"%@:%@", key, obj];
        [keywords addObject:keyword];
    }];
    
    return [keywords componentsJoinedByString:@","];
}

@end
