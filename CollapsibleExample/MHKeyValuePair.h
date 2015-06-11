//
//  MHKeyValuePair.h
//  CollapsibleExample
//
//  Created by Lizzy Randall on 6/10/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHKeyValuePair : NSObject


- (instancetype)initWithKey:(NSString*)givenKey value:(NSString*)givenValue;

- (void)setKeyWithString:(NSString *)key;

- (void)setValueWithString:(NSString*)value;

- (NSString*)returnKey;

- (NSString*)returnValue;


@end
