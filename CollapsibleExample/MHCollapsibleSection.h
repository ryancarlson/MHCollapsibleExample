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

- (void)setSubtitleItemTextForSectionWithString:(NSString*)subTitleItemText;

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

- (void)setManagerIndexWithIndex:(NSUInteger)index;

- (NSUInteger)returnManagerIndex;

- (NSString*)title;

- (NSString*)getIdentifier;

- (NSString*)detailedHeaderSectionText;

- (NSUInteger)selectedCountForSubTitleText;

- (NSArray*)returnCopyOfFilterData;

//This is not number of selected rows total since a checklist can have multiple selected
//For each filter, if at least one selected is found for this section
//count will be 1. If not this will return 0.
- (NSUInteger)countOneSelectedRowForSubtitleText;

- (NSUInteger)itemCount;

- (NSUInteger)getCurrentFocusForPicker;

- (NSString*)returnDescriptionWithRow:(NSUInteger)row;

- (NSString*)getTextForTextArea;

- (NSString*)getLabelDescription;

//Changers

//reverses expanded boolean and returns result
- (BOOL)toggleCheckAndReturnWithIndex:(NSUInteger)row;

//toggles expanded bool
- (void)toggleExpanded;

//inserts or deletes data from rows depending on expanded
- (void)toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

//resets range with new location, the sections in a hierarchy
//affect each others locations due to accordian
- (void)resetRangeWithNum:(NSUInteger)newLocation;

//Sets the current modal index to keep track of what the modal belongs to
- (void) setCurrentModalIndexWithRow:(NSUInteger)row;

- (void)clearSectionAndLabelData;  


//Modal Changes

//saves changes from modal
- (void)saveChanges;

//cancels changes
- (void)cancelChanges;

//clears data (for tableview/checklist type)
- (void)clearSelections;


@end
