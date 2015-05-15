//
//  Label.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "Label.h"

@implementation Label

@synthesize name;
@synthesize checked;

+ (id)constructLabel:(NSString*)name checked:(BOOL)checked
{
    Label *newLabel = [[self alloc] init];
    newLabel.name = name;
    newLabel.checked = checked;
    return newLabel;
}
@end
