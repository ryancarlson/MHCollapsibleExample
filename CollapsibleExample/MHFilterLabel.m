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
//static key/value pairs
@property (strong, nonatomic) NSArray *resultValues;
@property (strong, nonatomic) NSArray *resultKeys;

@property (strong, nonatomic) NSString *labelDescription;//description on modal if wanted

@end

@implementation MHFilterLabel

#pragma Initialize/Setters for Label

- (instancetype)initLabelWithName:(NSString*)name checked:(BOOL)checked interactionType:(CRUCellViewInteractionType)type{
    
    MHFilterLabel *newLabel = [self init];
    newLabel.name = name;
    newLabel.checked = checked;
    newLabel.type = type;
    return newLabel;
}

- (void) setLabelDescriptionWithString:(NSString *)labelDescription{
    
    self.labelDescription = labelDescription;
}

#pragma Getters for specific label

//Can be used for more description depending on modal
- (NSString*) getDescription{
    
    return self.labelDescription;
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

#pragma Setter for Label Sub Data

- (void)setResultsWithKeyArray:(NSArray *)resultKeys resultValues:(NSArray*)resultValues{
    
    self.resultKeys = [[NSArray alloc] initWithArray:resultKeys copyItems:YES];
    self.resultValues = [[NSArray alloc] initWithArray:resultValues copyItems:YES];
    //first set to same as resultValues, changes with user interaction
    self.mutableResultValues = [[NSMutableArray alloc] initWithArray:resultValues copyItems:YES];
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

#pragma Triggered from modal views

- (void)saveResultsFromChanges{
    
    //reset resultValues to mutable since it was changed
    self.resultValues = [[NSArray alloc] initWithArray:self.mutableResultValues copyItems:YES];
}

- (void)cancelChanges{
    
    //reset mutable back to old
    self.mutableResultValues = [[NSMutableArray alloc] initWithArray:self.resultValues copyItems:YES];
}

- (void)clearSelectedResults{
    
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

@end
