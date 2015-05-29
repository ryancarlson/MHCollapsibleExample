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
//If type is not header or toggle, results will need to be stored for interactions
//with user (i.e. user checks multiple answers per single cell from modals
@property (strong, nonatomic) NSArray *results;

@end

@implementation MHFilterLabel


- (instancetype)initLabelWithName:(NSString*)name checked:(BOOL)checked interactionType:(CRUCellViewInteractionType)type{
    MHFilterLabel *newLabel = [self init];
    newLabel.name = name;
    newLabel.checked = checked;
    newLabel.type = type;
    return newLabel;
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

@end
