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

//Getters

- (BOOL)selectedCell;

- (void)toggleChecked;

- (NSString*)labelName;

- (CRUCellViewInteractionType)labelType;

@end
