//
//  MHCollapsibleSection.h
//  CollapsibleExample
//
//  Class that handles a section of data corresponding to sells
//  Note: section does not mean the same as UITableView section
//  but rather a combo of header + child data
//  Created by Lizzy Randall on 5/19/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHFilterLabel.h"

@interface MHCollapsibleSection : NSObject

//Setters
- (instancetype) initWithArray:(NSArray*)filters headerTitle:(NSString*)headerTitle
                     animation:(UITableViewRowAnimation)animation rowRange:(NSRange)rowRange;

//Check methods

- (BOOL)checkStateOfRowWithIndexRow:(NSUInteger)row;

//returns result of if row number is in range for section
- (BOOL)rowNumInRange:(NSUInteger)num;

//returns label at a specified row, note: this is offset since the labels themselves
//are at different spots in their array than the row numbers
- (NSString*)returnLabelNameAtRow:(NSUInteger)row;


//Getters

- (CRUCellViewInteractionType)returnTypeWithRow:(NSUInteger)row;

- (NSUInteger)headerRowNum;

- (NSUInteger)numOfRows;

- (BOOL)returnExpanded;

- (NSString*)title;

- (NSUInteger)itemCount;

//Changers

//reverses expanded boolean and returns result
- (BOOL)toggleCheckAndReturnWithIndex:(NSUInteger)row;

//toggles expanded bool
- (void) toggleExpanded;

//inserts or deletes data from rows depending on expanded
- (void) toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

//resets range with new location, the sections in a hierarchy
//affect each others locations due to accordian
- (void)resetRangeWithNum:(NSUInteger)newLocation;

@end
