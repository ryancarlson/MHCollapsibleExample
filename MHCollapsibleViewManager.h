//
//  MHCollapsibleViewManager.h
//  Represents a view piece that is collapsible
//  It manages the following:
//      The header record style/accessory for clicked record
//      Showing/Hiding rows under header
//      Clicked child cell style/accessory
//      Keeps track if cell was clicked using MHFilterLabel class
//
//  Created by Lizzy Randall on 5/6/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHFilterLabel.h"
#import "MHTableViewCell.h"

@interface MHCollapsibleViewManager : NSObject

//INIT METHODS

-(instancetype)init;

//Initialize Manager with animation type, title for header and tableView
//tableView is for creating cells to store styles, it is not kept in memory on manager
- (instancetype)initManagerWithAnimation:(UITableViewRowAnimation)animation
                       topHierarchyTitle:(NSString*) title tableView:(UITableView*)tableView;

//SET METHODS

//Set the data for the manager
//This should be a mutable array of strings that the Manager then creates MHFilterLabel objects for
//Can be used to override a manager's array of data
- (void) setDataWithFilterNames:(NSArray*)filterNames headerTitles:(NSArray*)headerTitles;

//RETURN METHODS

- (UITableViewCell*)returnCellWithIndex:(NSIndexPath*)indexPath tableView:(UITableView*)tableView;

//Returns all selected rows
//- (NSMutableArray*)returnSelectedRows;

- (void) selectedRowAtIndexPath: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

- (NSUInteger)numOfRows;

- (NSUInteger)numOfSections;

- (NSString*)title;



@end
