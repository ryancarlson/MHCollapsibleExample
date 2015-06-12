//
//  MHFilterLabel.h
//  Extremely Simple class that keeps track if cell was checked for given filter
//
//  Created by Lizzy Randall on 5/14/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MHTableViewCell.h"

@interface MHFilterLabel : NSObject

- (instancetype)initLabelWithName:(NSString*)name checked:(BOOL)checked interactionType:(CRUCellViewInteractionType)type;

#pragma Label Information

- (BOOL)selectedCell;

- (BOOL)hasSelectedItems;

- (NSString*)labelName;

- (CRUCellViewInteractionType)labelType;

- (NSUInteger)numOfRows;

- (NSUInteger)numOfRowsSelected;

- (NSUInteger)getCurrentPickedRow;

- (NSString*)getCurrentText;

- (NSString*)getDescription;

- (NSString*)getPlaceHolderText;

- (NSArray*)returnSelectedArray;

- (void)toggleChecked;

#pragma Label result information

- (NSString*)returnResultKeyAtRow:(NSUInteger)row;

- (BOOL)resultHasCheck:(NSUInteger)row;

- (BOOL)resultsKeysExists;

- (NSUInteger)containsAtLeastOneSelected;

#pragma Setters
//Set label data for picker
- (void)setCurrentPickedRowWithRow:(NSInteger)currentPickedRow;

- (void)setCurrentTextWithString:(NSString *)currentText;

//Setter for results array, must be called for label types with modals
- (void)setResultsWithKeyArray:(NSArray *)resultKeys resultValues:(NSArray*)resultValues;

//Call if the modal has a place holder, this is specifically used for text area but could
//be used for other descriptive text if filterviewcontroller is subclassed
- (void)setPlaceHolderTextWithString:(NSString *)placeHolderText;

//Toggle changes for modal data
- (void)toggleCheckedValueForRow:(NSUInteger)row;

#pragma Modal Changes

- (void)saveResultsFromChanges;

- (void)cancelChanges;

- (void)clearAndSaveChanges;

- (void)clearSelectedResults;

- (void)clearMutableResults;

@end
