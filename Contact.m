//
//  Contact.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize label;
@synthesize name;
@synthesize assignedTo;

+ (id)constructContact:(NSString *)label name:(NSString *)name assignedTo:(NSString*)assignedTo
{
    Contact *newContact = [[self alloc] init];
    newContact.label = label;
    newContact.name = name;
    newContact.assignedTo = assignedTo;
    return newContact;
}

@end
