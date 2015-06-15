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

@interface MHCollapsibleSection : NSObject <UIPickerViewDelegate,
                                            UIPickerViewDataSource,
                                            UITextFieldDelegate,
                                            UITableViewDelegate,
                                            UITableViewDataSource>

//Setters
- (instancetype)initWithArray:(NSArray*)filters headerTitle:(NSString*)headerTitle
                     animation:(UITableViewRowAnimation)animation rowRange:(NSRange)rowRange;

//A singleton idenfitier for example labels, surveys, etc.
//What entities are actually selected
- (void)setIdentifierWithString:(NSString *)singleIdentifier pluralIdentifier:(NSString*)pluralIdentifier;

//Manager index identifies which manager this section belongs too
//it makes it easier for the filterviewcontroller to interact
//with the section directly than looping through its managers to find it
- (void)setManagerIndexWithIndex:(NSUInteger)index;

//Sets the current modal index to keep track of what the modal belongs to
- (void)setCurrentModalIndexWithRow:(NSUInteger)row;

#pragma Section Specifics

- (NSUInteger)returnManagerIndex;

- (NSUInteger)headerRowNum;

- (NSUInteger)numOfRows;

- (NSUInteger)itemCount;

- (BOOL)returnExpanded;

- (NSString*)title;

- (NSString*)getIdentifier;

//This is not number of selected rows total since a checklist can have multiple selected
//For each filter, if at least one selected is found for this section
//count will be 1. If not this will return 0.
- (NSUInteger)countOneSelectedRowForSubtitleText;

- (NSUInteger)selectedCountForSubTitleText;

- (NSUInteger)getCurrentFocusForPicker;

- (NSString*)getTextForTextArea;

- (NSString*)getPlaceHolderText;

- (NSString*)detailedHeaderSectionText;

#pragma Check methods

- (BOOL)checkStateOfRowWithIndexRow:(NSUInteger)row;

//returns result of if row number is in range for section
- (BOOL)rowNumInRange:(NSUInteger)num;

#pragma Return Label Information

- (CRUCellViewInteractionType)returnTypeWithRow:(NSUInteger)row;

//returns label at a specified row, note: this is offset since the labels themselves
//are at different spots in their array than the row numbers
- (NSString*)returnLabelNameAtRow:(NSUInteger)row;

- (NSArray*)returnCopyOfFilterData;

- (NSString*)returnDescriptionWithRow:(NSUInteger)row;

#pragma Collapsing/Expanding pieces

//reverses expanded boolean and returns result
- (BOOL)toggleCheckAndReturnWithIndex:(NSUInteger)row;

//toggles expanded bool
- (void)toggleExpanded;

//inserts or deletes data from rows depending on expanded
- (void)toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

#pragma Reset

//resets range with new location, the sections in a hierarchy
//affect each others locations due to accordian
- (void)resetRangeWithNum:(NSUInteger)newLocation;

- (void)clearSectionAndLabelData;  

#pragma Modal Pieces

//saves changes from modal
- (void)saveChanges;

//cancels changes
- (void)cancelChanges;

//clears data (for tableview/checklist type)
- (void)clearSelections;


@end
