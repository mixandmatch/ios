//
//  NSString+Commons.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 04.03.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "NSString+StringUtils.h"

@implementation NSString (StringUtils)

+ (BOOL)isEmpty:(id)object
{
    return object == nil
    || [object isKindOfClass:[NSNull class]]
    || ([object respondsToSelector:@selector(length)]
        && [(NSData *)object length] == 0)
    || ([object respondsToSelector:@selector(count)]
        && [(NSArray *)object count] == 0);
}

+ (BOOL)isBlank:(NSString *) stringToTest
{
    return [NSString isEmpty:stringToTest]
    || [NSString isEmpty:[NSString trim:stringToTest]];
            
}

+ (NSString *)trim: (NSString *)input
{
 return [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];   
}

@end
