//
//  MHCollapsibleViewHierarchy.h
//  CollapsibleExample
//
//  Created by Lizzy Randall on 5/15/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHCollapsibleViewManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHCollapsibleViewHierarchy : MHCollapsibleViewManager

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *managers;


@end
