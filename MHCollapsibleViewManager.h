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

@interface MHCollapsibleViewManager : NSObject

@property (strong, nonatomic) NSMutableArray *data;
//Stores four uitableview cells with properties to change style, accessory, etc.
@property (strong, nonatomic) NSArray *cellStyles;
//Shown on header and also can be used to determine logic to name the manager
//i.e. headerTitle of Labels means label manager
@property (strong, nonatomic) NSString *headerTitle;

@property (nonatomic) UITableViewRowAnimation rowAnimation;
//num of rows in data array, quick int to keep track of
@property (nonatomic) NSInteger numOfRows;

//Boolean keeps track if header has been clicked
//expanded = true means children rows are shown
//expanded = false means children rows are not shown
@property (nonatomic) BOOL expanded;

//INIT METHODS

//Initialize Manager with animation type, title for header and tableView
//tableView is for creating cells to store styles, it is not kept in memory on manager
- (id)initalizeManager:(UITableViewRowAnimation)animation title:(NSString*) title tableView:(UITableView*)tableView;

//Set the data for the manager
//This should be a mutable array of strings that the Manager then creates MHFilterLabel objects for
//Can be used to override a manager's array of data
- (void) initializeData:(NSMutableArray*)dataFromController;

//SET METHODS

//Sets defaults for a cell, a cell can still be changed if different styles, etc. is needed
- (void)setCellProperties:(UITableViewCell*)clickedHeader header:(UITableViewCell*)header
              clickedCell:(UITableViewCell*)clickedCell normalCell:(UITableViewCell*)cell tableView:(UITableView*)tableView;

//Sets a cell's properties to be the same as the corresponding type in cellStyles array
- (UITableViewCell*)setCellSettings:(UITableViewCell*)cell type:(NSString*)type;

- (UITableViewCell*)returnCell:(NSIndexPath*)indexPath tableView:(UITableView*)tableView;

//Returns all selected rows
- (NSMutableArray*)returnSelectedRows;

- (void) toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

- (void) selectedRowAtIndexPath: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath;


@end
