//
//  Label.h
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Label : NSObject {
    NSString *name;
    BOOL checked;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) BOOL checked;

+ (id)constructLabel:(NSString*)name checked:(BOOL)checked;

@end
