//
//  MHFilterLabel.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 5/14/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHFilterLabel.h"

@implementation MHFilterLabel

@synthesize name;
@synthesize checked;

+ (id)constructLabel:(NSString*)name checked:(BOOL)checked
{
    MHFilterLabel *newLabel = [[self alloc] init];
    newLabel.name = name;
    newLabel.checked = checked;
    return newLabel;
}
@end
