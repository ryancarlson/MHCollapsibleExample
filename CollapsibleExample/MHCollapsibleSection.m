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
@property (nonatomic) NSRange filterDataRange;
@property (nonatomic) UITableViewRowAnimation rowAnimation;
@property (nonatomic) BOOL expanded;

- (MHFilterLabel*)returnOffsetLabel:(NSUInteger)row;

@end

@implementation MHCollapsibleSection

- (instancetype) initWithArray:(NSArray*)filters headerTitle:(NSString*)headerTitle
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

//static count of data
- (NSUInteger)itemCount{
    return self.filterDataForSection.count;
}

//dynamic header location for this section
- (NSUInteger)headerRowNum{
    return self.filterDataRange.location;
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

- (NSString*)returnLabelNameAtRow:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    return label.labelName;
}

- (CRUCellViewInteractionType)returnTypeWithRow:(NSUInteger)row{
    MHFilterLabel *label = [self returnOffsetLabel:row];
    return label.labelType;
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

//takes row number and converts to corresponding
//index in data array then returns label
- (MHFilterLabel*)returnOffsetLabel:(NSUInteger)row{
    //offset one for header as well
    NSUInteger offset = row-self.filterDataRange.location-1;
    MHFilterLabel *label = [self.filterDataForSection objectAtIndex:offset];
    return label;
}


//toogles the children rows and handles the look of the header row
//as a result from collapsing/expanding
- (void) toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    //toogle expanded, used to check for if the header has been clicked
    //self.expanded = !self.expanded;

    //+1 is for header, header doesn't get inserted or removed
    NSUInteger start = self.filterDataRange.location+1;
    NSUInteger maxRange = NSMaxRange(self.filterDataRange);
    
    NSLog(@"%@%d%d", @"Start and MaxRange", (int)start, (int)maxRange);
    
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
