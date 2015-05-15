//
//  Contact.h
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject {
    NSString *label;
    NSString *name;
    NSString *assignedTo;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *assignedTo;

+ (id)constructContact:(NSString*)label name:(NSString*)name assignedTo:(NSString*)assignedTo;

@end
