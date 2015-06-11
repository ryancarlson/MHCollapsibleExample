//
//  MHCollapsibleSection.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 5/19/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHCollapsibleSection.h"

@interface MHCollapsibleSection()

@property (strong, nonatomic) NSArray *filterDataForSection;
@property (strong, nonatomic) NSString *headerTitle;
@property (strong, nonatomic) NSString *subTitleItemText;
@property (nonatomic) NSRange filterDataRange;
@property (nonatomic) UITableViewRowAnimation rowAnimation;
@property (nonatomic) BOOL expanded;
//only one modal at a time, this keeps track of which filterDataForSection index
//is actually being interacted with currently
@property (nonatomic) NSUInteger currentModalIndex;
@property (nonatomic) NSUInteger managerIndex;

- (MHFilterLabel*)returnOffsetLabel:(NSUInteger)row;

@end

@implementation MHCollapsibleSection

#pragma Initialize Section
- (instancetype)initWithArray:(NSArray*)filters headerTitle:(NSString*)headerTitle
                     animation:(UITableViewRowAnimation)animation rowRange:(NSRange)rowRange{
    self = [self init];
    self.filterDataForSection = filters;
    self.headerTitle = headerTitle;
    self.filterDataRange = rowRange;
    self.expanded = false;
    return self;
}

- (instancetype) init{
    self = [super init];
    self.filterDataForSection = [[NSArray alloc] init];
    return self;
}

- (NSArray*)returnCopyOfFilterData{
    
    return self.filterDataForSection.copy;
}

#pragma Section Information

- (void)toggleExpanded{
    self.expanded = !self.expanded;
}

- (BOOL)returnExpanded{
    return self.expanded;
}

- (NSString*)title{
    return self.headerTitle;
}

//returns count based if section is collapsed or not
- (NSUInteger)numOfRows{
    NSUInteger count = 0;
    if(self.expanded){
        count += self.filterDataRange.length;
    }
    else{
        count++;
    }
    return count;
}

- (void)setManagerIndexWithIndex:(NSUInteger)index{
    self.managerIndex = index;
}

- (NSUInteger)returnManagerIndex{
    return self.managerIndex;
}

//For section text
- (NSUInteger)selectedCountForSubTitleText{
    __block NSUInteger count = 0;
    
    [self.filterDataForSection enumerateObjectsUsingBlock:^(MHFilterLabel *label, NSUInteger index, BOOL *stop){
        count += label.containsAtLeastOneSelected;
    }];
    return count;
}

//This is not number of selected rows total since a checklist can have multiple selected
//For each filter, if at least one selected is found for this section
//count will be 1. This is method is called for each section so the manager can display proper text
- (NSUInteger)countOneSelectedRowForSubtitleText{
    
    __block NSUInteger count = 0;
    [self.filterDataForSection enumerateObjectsUsingBlock:^(MHFilterLabel *label, NSUInteger index, BOOL *stop){
        if(label.hasSelectedItems){
            count++;
            *stop = YES;
        }
    }];
    return count;
}

- (NSUInteger)selectedCount{
    
    __block NSUInteger count = 0;
    
    [self.filterDataForSection enumerateObjectsUsingBlock:^(MHFilterLabel *label, NSUInteger index, BOOL *stop){
        count += label.numOfRowsSelected;
    }];
    return count;
}

- (NSString*)detailedHeaderSectionText{
    
    NSUInteger count = [self selectedCountForSubTitleText];
    NSString *detailedText;
    NSString *itemTitle = self.subTitleItemText;
    NSString *plural = @"";
    NSString *selected = @"selected";
    
    if(itemTitle == nil){
        itemTitle = @"item";
    }
    
    if(count < 1){
        selected = @"";
        itemTitle = @"item";
        count = self.itemCount;
        if(count > 1){
            plural = @"s";
        }
    }
    else{
        if(count > 1){
            plural = @"s";
        }
    }
    detailedText = [NSString stringWithFormat:NSLocalizedString(@"%i %@ %@%@",), count, selected, itemTitle, plural];
    
    itemTitle = nil;
    plural = nil;
    selected = nil;
    return detailedText;
}

- (void)setSubtitleItemTextForSectionWithString:(NSString*)subTitleItemText{
    
    self.subTitleItemText = subTitleItemText;
}

//static count of data
- (NSUInteger)itemCount{
    return self.filterDataForSection.count;
}

//dynamic header location for this section
- (NSUInteger)headerRowNum{
    return self.filterDataRange.location;
}

- (NSString*)getIdentifier{
    
    return self.subTitleItemText;
}

//Set the location with new number, this happens when other
//sections are collapsed, the location will chanage
//Manager handles updating
- (void)resetRangeWithNum:(NSUInteger)newLocation{
    NSUInteger length = self.filterDataRange.length;
    self.filterDataRange = NSMakeRange(newLocation, length);
}

//Returns if number is in stange
- (BOOL)rowNumInRange:(NSUInteger)num{
    BOOL inRange = NSLocationInRange(num, self.filterDataRange);
    return inRange;
}

#pragma Specific Label Information
- (NSString*)returnLabelNameAtRow:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    return label.labelName;
}

- (CRUCellViewInteractionType)returnTypeWithRow:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    return label.labelType;
}

- (NSString*)returnDescriptionWithRow:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    return label.getDescription;
}


- (BOOL)checkStateOfRowWithIndexRow:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    return label.selectedCell;
}

- (BOOL)toggleCheckAndReturnWithIndex:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    [label toggleChecked];
    return label.selectedCell;
}

- (NSUInteger)getCurrentFocusForPicker {
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    NSUInteger currentIndex = label.getCurrentPickedRow;
    label = nil;
    return currentIndex;
    
}

- (NSString*)getTextForTextArea {
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    NSString *currentText = label.getCurrentText;
    label = nil;
    return currentText;
}

- (NSString*)getLabelDescription{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    NSString *description = label.getDescription;
    return description;
}

//takes row number and converts to corresponding
//index in data array then returns label
- (MHFilterLabel*)returnOffsetLabel:(NSUInteger)row{
    //offset one for header as well
    NSUInteger offset = row-self.filterDataRange.location-1;
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:offset];
    return label;
}

- (void)setCurrentModalIndexWithRow:(NSUInteger)row{
    
    //set index to offset so that it will be the proper counter in the array
    self.currentModalIndex = row-self.filterDataRange.location-1;
    
     MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    
    if(label.labelType == CRUCellViewInteractionTextBox){
        if(!label.resultsKeysExists){
            [label setResultsWithKeyArray:@[@""] resultValues:@[[NSNumber numberWithBool:NO]]];
        }
    }
    
}

#pragma PickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    [label setCurrentPickedRowWithRow:row];
    label = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    NSUInteger numRows = label.numOfRows;
    label = nil;
    return numRows;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    NSString *resultKey = [label returnResultKeyAtRow:row];
    label = nil;
    return resultKey;
}

#pragma TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    [label setCurrentTextWithString:textField.text];
    label = nil;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}


#pragma TableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger indexRow = indexPath.row;
    NSString *cellIdentifier = @"ToggleCell";
    __block NSString *cellText;
    __block BOOL checked;
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    cellText = [label returnResultKeyAtRow:indexRow];
    checked = [label resultHasCheck:indexRow];
    label = nil;
    
    MHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[MHTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [cell setCellViewInteractionWithType:CRUCellViewInteractionCheckToggle];
    cell.textLabel.text = cellText;
    //set look based on if checked or not
    [cell changeCellStateWithToggle:checked];
    return (UITableViewCell*)cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    //NSString *description = label.getDescription;
    NSString *description = label.labelName;
    return description;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    NSUInteger count = label.numOfRows;
    label = nil;
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger indexRow = indexPath.row;
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    //toggles check for temp results
    [label toggleCheckedValueForRow:indexRow];
    
    MHTableViewCell *cell = (MHTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeCellStateWithToggle:[label resultHasCheck:indexRow]];
    
    //Fix ios 7 bug via stackoverflow:
    //http://stackoverflow.com/questions/19212476/uitableview-separator-line-disappears-when-selecting-cells-in-ios7
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    cell = nil;
    label = nil;
}

# pragma Changes Triggered By Modals
- (void)saveChanges{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    
    //sets the working dictionary to the static to save changes made by user
    //also resets variables that drive what dictionary is traversed for the label
    [label saveResultsFromChanges];
    
    label = nil;
}

- (void)cancelChanges{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    
    //sets the working dictionary to the static to override the users changes
    [label cancelChanges];
    
    label = nil;
    
}

- (void)clearSelections{
    
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:self.currentModalIndex];
    
    //goes through selected dictionary (what user sees) and unchecks
    //every result entry that has been checked
    [label clearSelectedResults];
    
    label = nil;
    
}


- (void)clearSectionAndLabelData{
    
    [self.filterDataForSection enumerateObjectsUsingBlock:^(MHFilterLabel *label, NSUInteger index, BOOL *stop){
        //mocking a selection
        if(label.selectedCell){
            [label toggleChecked];
        }
        [label clearAndSaveChanges];
    }];
}

#pragma Collapsing Code
//toogles the children rows (corresponding to Label Names) and handles the look of the header row
//as a result from collapsing/expanding
- (void)toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    //toogle expanded, used to check for if the header has been clicked
    //self.expanded = !self.expanded;

    //+1 is for header, header doesn't get inserted or removed
    NSUInteger start = self.filterDataRange.location+1;
    NSUInteger maxRange = NSMaxRange(self.filterDataRange);
    
    NSIndexPath *tempPath = nil;
    //Get the section for creating array of indexpaths
    NSInteger section = indexPath.section;
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    
    for(NSUInteger i=start; i < maxRange; i++)
    {
        tempPath = [NSIndexPath indexPathForRow:i inSection:section];
        [pathArray addObject:tempPath];
    }
    
    if(self.expanded){
        [tableView insertRowsAtIndexPaths:pathArray withRowAnimation:self.rowAnimation];
    }
    else{
        [tableView deleteRowsAtIndexPaths:pathArray withRowAnimation:self.rowAnimation];
    }
    
    pathArray = nil;
    
    if(self.expanded){
        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
