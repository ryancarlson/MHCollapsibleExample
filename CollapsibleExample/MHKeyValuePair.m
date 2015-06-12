//
//  MHKeyValuePair.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 6/10/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHKeyValuePair.h"

@interface MHKeyValuePair()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@end

@implementation MHKeyValuePair

- (instancetype)initWithKey:(NSString*)givenKey value:(NSString*)givenValue{
    
    self = [self init];
    self.key = givenKey;
    self.value = givenValue;
    return self;
}

- (NSString*)returnValue{
    return self.value;
}

- (NSString*)returnKey{
    return self.key;
}

- (void)setKeyWithString:(NSString *)key{
    
    self.key = key;
}

- (void)setValueWithString:(NSString*)value{
    
    self.value = value;
}

@end
