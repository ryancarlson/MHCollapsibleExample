//
//  MHFilterLabel.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 5/14/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHFilterLabel.h"

@interface MHFilterLabel()

@property NSString *name; //label for object, what is shown in initial cell
@property CRUCellViewInteractionType type;
@property BOOL checked; //keeps track of simple object check whenever selected

//for checks/selections this is the array the user sees and interacts with
@property (strong, nonatomic) NSMutableArray *mutableResultValues;
//static key/value pairs each in different arrays
@property (strong, nonatomic) NSArray *resultValues;
@property (strong, nonatomic) NSArray *resultKeys;

@property (nonatomic) NSUInteger currentPickedRow; //for uipickview
@property (nonatomic) NSUInteger previousPickedRow; //for uipickview

@property (strong, nonatomic) NSString *currentText;
@property (strong, nonatomic) NSString *placeHolderText;
 //specific text for subtitle such as "4 selected questions"
@property (strong, nonatomic) NSString *itemSubTitleText;
//specific text for children entiries ex "3 selected answers"
@property (strong, nonatomic) NSString *childrenItemText;

@end

@implementation MHFilterLabel

//only one row in arrays for the one string
static const NSUInteger textAreaRow = 0;

#pragma Initialize/Setters for Label

- (instancetype)initLabelWithName:(NSString*)name checked:(BOOL)checked interactionType:(CRUCellViewInteractionType)type{
    
    MHFilterLabel *newLabel = [self init];
    newLabel.name = name;
    newLabel.checked = checked;
    newLabel.type = type;
    return newLabel;
}

#pragma Setters for textfield types
- (void)setPlaceHolderTextWithString:(NSString *)placeHolderText{
    
    self.placeHolderText = placeHolderText;
}

- (void)setCurrentTextWithString:(NSString *)currentText{
    
    self.currentText = currentText;
}

#pragma Getters for specific label

- (NSString*)getPlaceHolderText{
    
    return self.placeHolderText;
}

# pragma Get Label Information
//Can be used for more description depending on modal
- (NSString*)getDescription{
    
    NSString *detailText = @"";
    NSMutableArray *selectedKeys = [[NSMutableArray alloc] init];
    
    if(self.type != CRUCellViewInteractionCheckToggle){
        
        [self.resultValues enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop){
            
            if(num.boolValue){
                [selectedKeys addObject:[self.resultKeys objectAtIndex:index]];
            }
        }];
        if(selectedKeys.count > 1){
            detailText = [selectedKeys componentsJoinedByString:@", "];
        }
        else if(selectedKeys.count > 0){
            detailText = selectedKeys[0];
        }
        
    }
    return detailText;
}

//used to check if the resultKeys needs to be initialized
- (BOOL)resultsKeysExists{
    
    BOOL exists = NO;
    
    if(self.resultKeys != nil){
        exists = YES;
    }
    return exists;
}

- (BOOL)selectedCell{
    
    return self.checked;
}

- (void)toggleChecked{
    
    self.checked = !self.checked;
}

- (NSString*)labelName{
    
    return self.name;
}

- (CRUCellViewInteractionType)labelType{
    
    return self.type;
}

//Unused by might be helpful for filterviewcontroller subclasses to check
//since this method returns the entire count of selected results
//This number is not shown in the UI for the label but rather the results themselves
- (NSUInteger)numOfRowsSelected{
    
    __block NSUInteger count = 0;
    
    if(self.selectedCell && self.type == CRUCellViewInteractionCheckToggle){
        //Only count one for toggle type
        //since multiple records could be selected
        count = 1;
    }
    else{
        
        [self.resultValues enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop){
            if(num.boolValue){
                count++;
            }
        }];
    }
    return count;
}

- (BOOL)hasSelectedItems{
    
    __block BOOL hasSelectedItems = NO;
    
    if(self.resultValues != nil){
        [self.resultValues enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop){
            if(num.boolValue){
                hasSelectedItems = YES;
                *stop = YES;
            }
        }];
    }
    return hasSelectedItems;
}

//Returns a number based on if at least one result (or label itself) is selected
//for non toggle types, the first selected run into will do for the count
- (NSUInteger)containsAtLeastOneSelected{
    
    __block NSUInteger selectedCount = 0;
    
    if(self.type != CRUCellViewInteractionCheckToggle){
        
        [self.resultValues enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger index, BOOL *stop){
            if(num.boolValue){
                selectedCount++;
                *stop = YES;
            }
        }];
    }
    else if(self.selectedCell && self.type == CRUCellViewInteractionCheckToggle){
        //Just one per selected row since the label itself
        //is a checklist type/non modal
        selectedCount = 1;
    }
    return selectedCount;
}

- (NSUInteger)getCurrentPickedRow{
    
    return self.currentPickedRow;
}

- (NSString*)getCurrentText{
    
    return self.resultKeys[textAreaRow];
}


#pragma Setter for Label Sub Data

- (void)setCurrentPickedRowWithRow:(NSInteger)currentPickedRow{
    
    self.currentPickedRow = currentPickedRow;
}

- (void)setResultsWithKeyArray:(NSArray *)resultKeys resultValues:(NSArray*)resultValues{
    
    self.resultKeys = [[NSArray alloc] initWithArray:resultKeys copyItems:YES];
    self.resultValues = [[NSArray alloc] initWithArray:resultValues copyItems:YES];
    //first set to same as resultValues, changes with user interaction
    self.mutableResultValues = [[NSMutableArray alloc] initWithArray:resultValues copyItems:YES];
}

- (void)setTextAreaResultsWithString:(NSString*)result{
    
    if(self.resultValues == nil && self.resultKeys == nil){
        
        self.resultValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:YES], nil];
    }
    else{
        self.mutableResultValues[textAreaRow] = [NSNumber numberWithBool:YES];
        self.currentText = result;
    }
    
}

- (void)setLabelItemTextWithString:(NSString*)itemText childrenDescription:(NSString*)childItemText{
    
    self.itemSubTitleText = itemText;
    self.childrenItemText = childItemText;
}

#pragma Getters for Label Sub Data

- (NSString*)returnResultKeyAtRow:(NSUInteger)row{
    
    __block NSString *result;

    //Keys will stay the same so just return value at row
    [self.resultKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL *stop){
        
        if(row == index){
            result = key;
            *stop = YES;
        }
    }];
    return result;
}

- (NSArray*)returnSelectedArray{
    
    NSMutableArray *constructingArray = [[NSMutableArray alloc] init];
    
    [self.resultKeys enumerateObjectsUsingBlock:^(NSString* key, NSUInteger index, BOOL *stop){
        
        NSNumber *boolNumber = self.resultValues[index];
        if(boolNumber.boolValue){
            [constructingArray addObject:key];
        }
    }];
    
    return [constructingArray copy];
}
- (BOOL)resultHasCheck:(NSUInteger)row{
    
    __block NSNumber *checked;

    //mutableResults is what is displayed and shown to user regarding checkmarks
    [self.mutableResultValues enumerateObjectsUsingBlock:^(NSNumber *selected, NSUInteger index, BOOL *stop){
        if(row == index)
        {
            checked = selected;
            *stop = YES;
        }
    }];
    return checked.boolValue;
}

//resultKeys.count = results.count = mutableresults.count
- (NSUInteger)numOfRows{
    
    return self.resultKeys.count;
}

- (void)toggleCheckedValueForRow:(NSUInteger)row{
    
    __block NSNumber *checked;
    __block BOOL reverseCheck;
    
    //toggle the checkmark for only the mutableresults, resultValues stays in tact
    [self.mutableResultValues enumerateObjectsUsingBlock:^(NSNumber *selected, NSUInteger index, BOOL *stop){
        if(row == index)
        {
            reverseCheck = !selected.boolValue;
            checked = [NSNumber numberWithBool:reverseCheck];
            self.mutableResultValues[index] = checked;
            *stop = YES;
        }
    }];
}

//For the filterview clear to clear (without UI concerns) and save it for user to see
//the instant clear for the whole view
- (void)clearAndSaveChanges{
    
    [self clearMutableResults];
    self.resultValues = [[NSArray alloc] initWithArray:self.mutableResultValues copyItems:YES];
}

#pragma Triggered from modal views

- (void)saveResultsFromChanges{

    if(self.type == CRUCellViewInteractionTextBox)
    {
        if(self.currentText == nil){
            self.currentText = @"";
        }
        
        self.resultKeys = @[self.currentText];
        
        if(![self.currentText isEqualToString:@""]){
            self.mutableResultValues[textAreaRow] = [NSNumber numberWithBool:YES];
        }
        else{
            self.mutableResultValues[textAreaRow] = [NSNumber numberWithBool:NO];
        }
    }
    else if(self.type == CRUCellViewInteractionPicker){
        //clear previous results so that this is the only
        //picked value in results array
        [self clearMutableResults];
        self.mutableResultValues[self.currentPickedRow] = [NSNumber numberWithBool:YES];
        self.previousPickedRow = self.currentPickedRow;
        //reset resultValues to mutable since it was changed
        self.resultValues = [[NSArray alloc] initWithArray:self.mutableResultValues copyItems:YES];
    }
    
    self.resultValues = [[NSArray alloc] initWithArray:self.mutableResultValues copyItems:YES];
    [self toggleChecked];
    
}

- (void)cancelChanges{
    
    //reset mutable back to old
    self.mutableResultValues = [[NSMutableArray alloc] initWithArray:self.resultValues copyItems:YES];
    
    if(self.type == CRUCellViewInteractionPicker){
        //so focus will be on previous pickedRow
        self.currentPickedRow = self.previousPickedRow;
    }
    [self toggleChecked];
}

//Just clears multable results, so everything checked or selected resets
//This is in a separate method so clearSelectedResults can do other things for
//each specific type if needed
- (void)clearMutableResults{
    
    __block NSNumber *tempChecked;
    __block BOOL reverseCheck;
    
    //If the value is checked, it needs to be "cleared" aka reversed
    //This needs to be only on mutable because the user could cancel their clear changes
    [self.mutableResultValues enumerateObjectsUsingBlock:^(NSNumber *selected, NSUInteger index, BOOL *stop){
        
        if(selected.boolValue){
            reverseCheck = !selected.boolValue;
            tempChecked = [NSNumber numberWithBool:reverseCheck];
            self.mutableResultValues[index] = tempChecked;
        }
    }];
}

- (void)clearSelectedResults{
        
    if(self.type != CRUCellViewInteractionTextBox){
        
        [self clearMutableResults];
        
        if(self.type == CRUCellViewInteractionPicker){
            
            self.currentPickedRow = textAreaRow;
        }
    }
    else{
        
        self.currentText = @"";
    }
    
}

@end
