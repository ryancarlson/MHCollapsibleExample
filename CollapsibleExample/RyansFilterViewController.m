//
//  RyansFilterViewController.m
//  CollapsibleExample
//
//  Created by Ryan Carlson on 6/19/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "RyansFilterViewController.h"

@interface RyansFilterViewController ()

@end

@implementation RyansFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addFilters:self.simpleFilterArray
        headerTitles:@[@"Baz"]
   topHierarchyTitle:@"Title"];
}

- (NSArray *)simpleFilterArray {
    MHFilterLabel *foo = [[MHFilterLabel alloc] initLabelWithName:@"Foo"
                                                          checked:NO
                                                  interactionType:CRUCellViewInteractionTextBox];
    
    MHFilterLabel *bar = [[MHFilterLabel alloc] initLabelWithName:@"Bar"
                                                          checked:NO
                                                  interactionType:CRUCellViewInteractionTextBox];
    
    return @[foo,bar];
}

@end
