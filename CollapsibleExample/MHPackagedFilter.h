//
//  MHPackagedFilter.h
//  CollapsibleExample
//
//  Created by Lizzy Randall on 6/10/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHKeyValuePair.h"

//MHKeyValuePair is a simple class that has a key and value
//MHPackagedFilter is a subclass that has its own key/value
//but also has an array of key/value pairs
@interface MHPackagedFilter : MHKeyValuePair

- (instancetype)initWithRootKey:(NSString*)rootKey rootValue:(NSString*)rootValue hierarchy:(BOOL)hierarchy;

- (void)addFilterWithKey:(NSString*)key value:(NSString*)value;

- (NSString*)returnValueAtIndex:(NSUInteger)index;

- (NSString*)returnKeyAtIndex:(NSUInteger)index;

- (BOOL)containsFilterKeyValues;

@end
