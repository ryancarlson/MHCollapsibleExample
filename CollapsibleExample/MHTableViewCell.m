//
//  MHTableViewCell.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 5/18/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHTableViewCell.h"

@interface MHTableViewCell()


//For toggling styles
@property UIView *defaultAccessoryView;
@property UIView *clickedAccessoryView;

@property UITableViewCellSelectionStyle defaultSelectionStyle;
@property UITableViewCellSelectionStyle clickedSelectionStyle;

@property UITableViewCellAccessoryType defaultAccessoryType;
@property UITableViewCellAccessoryType clickedAccessoryType;

@property UIColor *defaultTextLabelColor;
@property UIColor *clickedTextLabelColor;

//For triggering what to do with cell via manager
@property CRUCellViewInteractionType cellType;
@property BOOL checked;

@end

@implementation MHTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    //defaults
    self.defaultAccessoryType = UITableViewCellAccessoryNone;
    self.defaultSelectionStyle = UITableViewCellSelectionStyleNone;
    
    self.clickedSelectionStyle = UITableViewCellSelectionStyleGray;
    
    //label color
    self.defaultTextLabelColor = [UIColor blackColor];
    
    if([reuseIdentifier isEqualToString:@"Header"]){
        self.clickedAccessoryType = UITableViewCellAccessoryNone;
        self.clickedTextLabelColor = [[UIColor alloc] initWithRed:0 green:.48 blue:1.0 alpha:1.0];
        self.clickedAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHCollapseUpArrow"]];
        self.defaultAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHCollapseDownArrow"]];
    }
    else if([reuseIdentifier isEqualToString:@"Indicator"]){
        
        self.clickedAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.defaultAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        //clicked non header cell
        self.clickedAccessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    reuseIdentifier = @"MHCell";
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.accessoryType = self.defaultAccessoryType;
    self.selectionStyle = self.defaultSelectionStyle;
    
    self.checked = NO;
    return self;
}

- (void)setCellDefaultsWithAccessory:(UITableViewCellAccessoryType)accessory style:(UITableViewCellSelectionStyle)style labelColor:(UIColor*)color accessoryView:(UIView*)view{

    self.defaultAccessoryType = accessory;
    self.defaultSelectionStyle = style;
    if(color != nil){
        self.defaultTextLabelColor = color;
    }
    if(view != nil){
        self.defaultAccessoryView = view;
    }
}

- (void)setCellClickedWithAccessory:(UITableViewCellAccessoryType)accessory style:(UITableViewCellSelectionStyle)style labelColor:(UIColor*)color accessoryView:(UIView*)view{
    
    self.clickedAccessoryType = accessory;
    self.clickedSelectionStyle = style;
    if(color != nil){
        self.clickedTextLabelColor = color;
    }
    if(view != nil){
        self.clickedAccessoryView = view;
    }
}

- (void)changeCellStateWithToggle:(BOOL)toggle{
    
    self.checked = toggle;
    
    if(self.checked){
        
        self.accessoryType = self.clickedAccessoryType;
        self.accessoryView = self.clickedAccessoryView;
        self.textLabel.textColor = self.clickedTextLabelColor;
        self.selectionStyle = self.clickedSelectionStyle;
    }
    else{
        self.accessoryType = self.defaultAccessoryType;
        self.accessoryView = self.defaultAccessoryView;
        self.textLabel.textColor = self.defaultTextLabelColor;
        self.selectionStyle = self.defaultSelectionStyle;
    }
        
}


- (void)setCellViewInteractionWithType:(CRUCellViewInteractionType)type{
    self.cellType = type;
}

- (CRUCellViewInteractionType)cellViewInteractionType{
    return self.cellType;
}

- (void)setCellLookWithMHCell:(MHTableViewCell*)cell{
    
    //Copy accessory and style information
    self.accessoryView = cell.accessoryView;
    self.accessoryType = cell.accessoryType;
    self.selectionStyle = cell.selectionStyle;
    //Copy background information
    self.backgroundColor = cell.backgroundColor;
    self.backgroundView = cell.backgroundView;
    self.selectedBackgroundView = cell.selectedBackgroundView;
    //Copy label information
    self.textLabel.textColor = cell.textLabel.textColor;
    self.textLabel.textAlignment = cell.textLabel.textAlignment;
    //Copy detail text
    self.detailTextLabel.text = cell.detailTextLabel.text;
    //copies type
    self.cellType = cell.cellViewInteractionType;
}

- (void)toggleCheck{
    self.checked = !self.checked;
}

- (BOOL)cellChecked{
    return self.checked;
}


@end
