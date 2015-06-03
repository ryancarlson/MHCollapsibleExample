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

//static dictionary, not edited by user
//used to keep state before user interacts with cells by checking
@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic) NSMutableDictionary *selectedResults; //keeps track of selected, what is shown to user
@property (strong, nonatomic) NSString *labelDescription;//description on modal if wanted

@end

@implementation MHFilterLabel


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

- (void)setResultsWithDictionary:(NSDictionary *)results{
    
    //selected results is kept for modals that have cancel buttons
    //only if save is pressed will the saved results apply to the results
    self.results = [[NSDictionary alloc] initWithDictionary:results copyItems:TRUE];
    self.selectedResults = [[NSMutableDictionary alloc] initWithDictionary:results copyItems:TRUE];
}

- (NSString*)returnResultKeyAtRow:(NSUInteger)row{
    
    __block NSString *result;
    __block NSUInteger index = 0;

    [self.selectedResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if(row == index)
        {
            result = key;
            *stop = YES;
        }
        index++;
    }];
    return result;
}

- (BOOL)resultHasCheck:(NSUInteger)row{
    
    __block NSNumber *checked;
    __block NSUInteger index = 0;

    [self.selectedResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if(row == index)
        {
            checked = obj;
            *stop = YES;
        }
        index++;
    }];
    return checked.boolValue;
}

- (NSUInteger)numOfRows{
    return self.results.count;
}

- (void)toggleCheckedValueForRow:(NSUInteger)row{
    
    __block NSNumber *checked;
    __block BOOL reverseCheck;
    __block NSUInteger index = 0;
    __block NSString *stringKey;
    
    //toggling the checkedvalue will always be the working selectedResults dictionary
    [self.selectedResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if(row == index)
        {
            checked = obj;
            reverseCheck = !checked.boolValue;
            checked = [NSNumber numberWithBool:reverseCheck];
            stringKey = key;
            [self.selectedResults setValue:checked forKey:stringKey];
            *stop = YES;
        }
        index++;
    }];
}

- (void)saveResultsFromChanges{
    
    self.results = [[NSDictionary alloc] initWithDictionary:self.selectedResults copyItems:YES];
}

- (void)cancelChanges{
    
    self.selectedResults = [[NSMutableDictionary alloc] initWithDictionary:self.results copyItems:YES];
}

- (void)clearSelectedResults{
    
    __block NSNumber *tempChecked;
    __block BOOL reverseCheck;
    __block NSString *stringKey;
    
    [self.selectedResults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        tempChecked = obj;
        if(tempChecked.boolValue){
            reverseCheck = !tempChecked.boolValue;
            tempChecked = [NSNumber numberWithBool:reverseCheck];
            stringKey = key;
            [self.selectedResults setValue:tempChecked forKey:stringKey];
        }
    }];
    
}

@end
