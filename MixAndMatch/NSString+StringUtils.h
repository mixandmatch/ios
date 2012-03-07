//
//  NSString+Commons.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringUtils)
/**
    Removes all surrounding spaces from a string.
 **/
+ (NSString *)trim: (NSString *)input;
/**
 Checks if a String is empty ("") or null.
 
 StringUtils.isEmpty(null)      = true
 StringUtils.isEmpty("")        = true
 StringUtils.isEmpty(" ")       = false
 StringUtils.isEmpty("bob")     = false
 StringUtils.isEmpty("  bob  ") = false
 **/
+ (BOOL)isEmpty:(id)object;
/**
 Checks if a String is whitespace, empty ("") or null.
 
 StringUtils.isBlank(null)      = true
 StringUtils.isBlank("")        = true
 StringUtils.isBlank(" ")       = true
 StringUtils.isBlank("bob")     = false
 StringUtils.isBlank("  bob  ") = false
 **/
+ (BOOL)isBlank:(NSString *) stringToTest;
@end
