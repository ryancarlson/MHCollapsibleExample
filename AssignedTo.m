//
//  AssignedTo.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "AssignedTo.h"

@implementation AssignedTo

@synthesize name;
@synthesize checked;

+ (id)constructAssignedTo:(NSString*)name checked:(BOOL)checked
{
    AssignedTo *newAssignedTo = [[self alloc] init];
    newAssignedTo.name = name;
    newAssignedTo.checked = checked;
    return newAssignedTo;
}

@end
