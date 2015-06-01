//
//  MHTableViewCell.h
//  CollapsibleExample
//
//  Created by Lizzy Randall on 5/18/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MHTableViewCell : UITableViewCell

//Describes type of cell for interactions
//Good to check when cell is selected for view controllers/etc. to handle
//the interaction respectively
typedef NS_ENUM(NSUInteger, CRUCellViewInteractionType){
    CRUCellViewInteractionHeader, //for arrow image/look of header
    CRUCellViewInteractionCheckToggle, //normal row that toggles a checkmark
    CRUCellViewInteractionCheckList, //modal with uitableview to check multiple types
    CRUCellViewInteractionPicker, //modal with uipicker to pick one
    CRUCellViewInteractionTextBox //modal with textbox for user to enter manually
};

//calls super first then sets defaults
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCellDefaultsWithAccessory:(UITableViewCellAccessoryType)accessory style:(UITableViewCellSelectionStyle)style labelColor:(UIColor*)color accessoryView:(UIView*)view;

- (void)setCellClickedWithAccessory:(UITableViewCellAccessoryType)accessory style:(UITableViewCellSelectionStyle)style labelColor:(UIColor*)color accessoryView:(UIView*)view;

//Set the type after creating cell
- (void)setCellViewInteractionWithType:(CRUCellViewInteractionType)type;

//Get the type to handle interaction
- (CRUCellViewInteractionType)cellViewInteractionType;

//For outside processed to see if the cell has been
//selected or not previously. Used for Check toggle types
- (BOOL)cellChecked;

//Use for cell selection changes that involve changing look of cell
//Sets:
//  accessoryView, accessoryType, selectionStyle
//  backgroundColor, backgroundView, selectedBackgroundView
//  textLabel.textColor, textAlignment
- (void)setCellLookWithMHCell:(UITableViewCell*)cell;

- (void) changeCellStateWithToggle:(BOOL)toggle;

@end
