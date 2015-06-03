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

//Getters for label information

- (BOOL)selectedCell;

- (void)toggleChecked;

- (NSString*)labelName;

- (CRUCellViewInteractionType)labelType;

- (NSString*)getDescription;

- (NSUInteger)numOfRows;

//Getters for results on label (data for modals)

- (NSString*)returnResultKeyAtRow:(NSUInteger)row;

- (BOOL)resultHasCheck:(NSUInteger)row;

//Toggle changes for modal data

- (void)toggleCheckedValueForRow:(NSUInteger)row;

//Setter for results dictionary, must be called for label types with modals
- (void)setResultsWithDictionary:(NSDictionary *)results;

//Call if the modal has a description
//For a tableview, this is the section title
- (void)setLabelDescriptionWithString:(NSString *)labelDescription;

//Changers from modal changes

- (void)saveResultsFromChanges;

- (void)cancelChanges;

- (void)clearSelectedResults;

@end
