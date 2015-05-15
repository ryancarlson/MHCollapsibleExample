//
//  Survey.h
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Survey : NSObject {
    NSArray *questions;
    NSString *name;
    BOOL checked;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *questions;
@property (nonatomic) BOOL checked;

@end
