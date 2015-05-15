//
//  FilterViewController.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "FilterViewController.h"
#import "MHCollapsibleViewManager.h"
#import "Label.h"
#import "AssignedTo.h"

@interface FilterViewController()

@end

@implementation FilterViewController

@synthesize managerArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MHCollapsibleViewManager *labels = [[MHCollapsibleViewManager alloc] initalizeManager:UITableViewRowAnimationMiddle title:@"Labels" tableView:self.tableView];
    //Index 0 is title
    [labels initializeData:[NSMutableArray arrayWithObjects:@"Freshman", @"Sophomore", @"Junior", @"Senior", nil]];
    
    MHCollapsibleViewManager *assignTo = [[MHCollapsibleViewManager alloc] initalizeManager:UITableViewRowAnimationMiddle title:@"Assigned To" tableView:self.tableView];
    //Index 0 is title
    [assignTo  initializeData:[NSMutableArray arrayWithObjects:@"Jan", @"Andy", @"Peggy", @"Maggie", nil]];
    
    //ManagerArray stores each controller or manager
    managerArray = [NSMutableArray arrayWithObjects:labels, assignTo, nil];
    assignTo = nil;
    labels = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section.
    MHCollapsibleViewManager *manager = [managerArray objectAtIndex:section];
    //There will at least be one because of the header
    NSInteger numOfRows = 1;
    //numOfRows does not include header, so add the initial (1) to the total
    //of the "children" or normal rows
    if(manager.expanded)
        numOfRows += manager.numOfRows;
    manager = nil;
    
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //managerArray per section
   return [managerArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temp manager to get create and return cell
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
    
    return [manager returnCell:indexPath tableView:tableView];
    
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCollapsibleViewManager *manager = [managerArray objectAtIndex:indexPath.section];
   
    //manager handles look and keeping track if whatever cell has been selected
    [manager selectedRowAtIndexPath:tableView indexPath:indexPath];
}


@end
