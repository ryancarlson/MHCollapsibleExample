//
//  MHFilterLabel.h
//  Extremely Simple class that keeps track if cell was checked for given filter
//
//  Created by Lizzy Randall on 5/14/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MHFilterLabel : NSObject {
    NSString *name;
    BOOL checked;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) BOOL checked;

+ (id)constructLabel:(NSString*)name checked:(BOOL)checked;

@end
