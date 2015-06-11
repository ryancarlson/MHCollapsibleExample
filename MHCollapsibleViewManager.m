//
//  MHCollapsibleViewManager.m
//  This is a manager of a uiview and view controller
//
//  Created by Lizzy Randall on 5/6/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHCollapsibleViewManager.h"

@implementation MHCollapsibleViewManagerDeletegate

- (void) createModalWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath{
    //do stuff
}
@end

@interface MHCollapsibleViewManager()

@property (strong, nonatomic) NSString *headerTitle;
@property (strong, nonatomic) NSString *subtitleCountText;
@property (strong, nonatomic) NSMutableArray *filterSections;
@property (nonatomic) UITableViewRowAnimation rowAnimation;
//hierarchy determines if Manager will be collapsible itself
//otherwise there is just one MHCollapsibleSection dictating itself
@property (nonatomic) BOOL hierarchy;
//Boolean keeps track if header has been clicked
//expanded = true means children rows are shown
//expanded = false means children rows are not shown
@property (nonatomic) BOOL expanded;


- (void) toggleCollapse:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

- (NSString*)returnDetailText;

-(NSUInteger)numOfSelectedRowsForText;

- (NSUInteger)numOfSections;

@end

@implementation MHCollapsibleViewManager

-(instancetype)init{
    self = [super init];
    if(self){
        self.filterSections = [NSMutableArray alloc];
        self.hierarchy = false;
        self.headerTitle = @"";
        self.expanded = false;
        self.rowAnimation = UITableViewRowAnimationFade;
    }
    return self;
}

//Initialize with animation, title and tableView
- (instancetype)initManagerWithAnimation:(UITableViewRowAnimation)animation
                       topHierarchyTitle:(NSString*) title tableView:(UITableView*)tableView{
    
    self = [self init];
    if(self){
        self.headerTitle = title;
        self.hierarchy = false;
        self.rowAnimation = animation;
        self.filterSections = [self.filterSections init];
    }
    return self;
}

//Return methods
- (NSString*)title{
    return self.headerTitle;
}

- (NSUInteger)numOfSections{
    NSUInteger rowCount = 0;
    if(self.expanded){
        rowCount = self.filterSections.count;
    }
    return rowCount;
}

- (BOOL)sectionExistsInManager:(MHCollapsibleSection*)comparisonSection{
    
    __block BOOL sectionExists = NO;
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        if(comparisonSection.headerRowNum == section.headerRowNum){
            sectionExists = YES;
            *stop = YES;
        }
     }];
    return sectionExists;
}

- (NSUInteger)numOfRows{
    
    __block NSUInteger rowCount = 0;
    if(self.hierarchy){
        rowCount++;
    }
    if(self.expanded || !self.hierarchy){
        [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection* section, NSUInteger index, BOOL *stop){
            rowCount += section.numOfRows;
        }];
    }

    return rowCount;
}

- (void)clearAllData{
    
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        [section clearSectionAndLabelData];
    }];
}


//called after Initializing Manager
//can take double array or single array depending if hierarchy
- (void)setDataWithFilterNames:(NSArray*)filterNames headerTitles:(NSArray*)headerTitles {
    
    __block NSUInteger start = 0;
    //used in loop to populate section array
    __block NSUInteger filterCount =  filterNames.count;
    __block MHCollapsibleSection *section;
    __block NSRange range;
    
    //if array is not double array, there is only one section
    if(![[filterNames objectAtIndex:0] isKindOfClass:[NSArray class]]){
        
        NSString *sectionTitle;
        if(headerTitles != nil){
            sectionTitle = [headerTitles objectAtIndex:0];
        }
        else{
            sectionTitle = self.headerTitle;
        }
        
        filterCount++; //offset for header included in the length
        section = [MHCollapsibleSection alloc];
        range = NSMakeRange(start, filterCount);
        section = [section initWithArray:filterNames headerTitle:sectionTitle animation:self.rowAnimation rowRange:range];
        [self.filterSections addObject:section];
 
    }
    else{
        //filterNames should have multiple arrays if it was a hierarchy
        //if just one, it's treated the same as a regular array, single MHCollapsibleSection
        if(filterCount > 1 && [[filterNames objectAtIndex:0] isKindOfClass: [NSArray class]]){
            self.hierarchy = true;
            start += 1;
            self.expanded = false;
        }
    
        if(headerTitles.count == filterCount){
            [filterNames enumerateObjectsUsingBlock:^(NSArray *filters, NSUInteger index, BOOL *stop){
                filterCount = filters.count+1;//offset for header
                range = NSMakeRange(start, filterCount);
                section = [MHCollapsibleSection alloc];
                section = [section initWithArray:filters headerTitle:[headerTitles objectAtIndex:index] animation:self.rowAnimation rowRange:range];
                [self.filterSections addObject:section];
                start++; //offset one for location for the next header
            }];
        }
    }
    section = nil;
}

//overrides the "items" text for sections with a specific string
- (void)setSubtitleTextForSectionsWithString:(NSString*)subtitle rootText:(NSString*)rootText managerIndex:(NSUInteger)managerIndex{
    
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        
        [section setSubtitleItemTextForSectionWithString:subtitle];
        [section setManagerIndexWithIndex:managerIndex];
    }];
    
    self.subtitleCountText = rootText;
}


//creates and returns a default accessorized cell to be modified
- (MHTableViewCell*)createCellWithtableView:(UITableView*)tableView interactionType:(CRUCellViewInteractionType)type checked:(BOOL)checked{
    
    NSString *cellIdentifier = @"Cell";

    MHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(type == CRUCellViewInteractionHeader){
        cellIdentifier = @"Header";
    }
    else if(type != CRUCellViewInteractionCheckToggle){
        cellIdentifier = @"Indicator";
    }
    if(!cell){
        cell = [[MHTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [cell setCellViewInteractionWithType:type];
    switch (type) {
        case CRUCellViewInteractionTextBox:
        case CRUCellViewInteractionPicker:
        case CRUCellViewInteractionCheckList:{
            [cell changeCellStateWithToggle:checked];
        }
            break;
        case CRUCellViewInteractionHeader:{
            if(checked){
            [cell setCellClickedWithAccessory:UITableViewCellAccessoryNone
                                          style:UITableViewCellSelectionStyleGray
                                     labelColor:nil accessoryView:nil];
            }
            else{
            [cell setCellDefaultsWithAccessory:UITableViewCellAccessoryNone
                                           style:UITableViewCellSelectionStyleNone
                                      labelColor:nil accessoryView:nil];
            }
            [cell changeCellStateWithToggle:checked];
        }
            break;
        default:{
            if(checked){
                [cell setCellClickedWithAccessory:UITableViewCellAccessoryCheckmark
                                              style:UITableViewCellSelectionStyleDefault
                                         labelColor:[UIColor blackColor] accessoryView:nil];
                [cell changeCellStateWithToggle:checked];
            }
            else{
                [cell setCellDefaultsWithAccessory:UITableViewCellAccessoryNone
                                               style:UITableViewCellSelectionStyleNone
                                          labelColor:[UIColor blackColor] accessoryView:nil];
                [cell changeCellStateWithToggle:checked];
            }
            
        }
    }
    return cell;
}

- (NSString*)returnDetailText{
    
    NSUInteger count = self.numOfSelectedRowsForText;
    NSString *detailedText;
    NSString *itemTitle = self.subtitleCountText;
    NSString *plural = @"";
    NSString *selected = @"selected";
    
    if(itemTitle == nil){
        itemTitle = @"item";
    }
    
    if(count < 1){
        selected = @"";
        itemTitle = @"item";
        count = [self.filterSections count];
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
       
-(NSUInteger)numOfSelectedRowsForText{
    
    __block NSUInteger count = 0;
    
    //The sub title text should match just one per selection (if there is one selected record)
    //even if the checklist has lots of values checked the number just needs to represent that one section has one selected
    //Ex: 3 surveys selected (though one survey question could have multiple questions selected)
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        
            count += section.countOneSelectedRowForSubtitleText;
    }];
    
    return count;
}
//creates a cell and returns what it should look like depending on if the header has been clicked
//or if normal cell has been clicked
-(MHTableViewCell*)returnCellWithIndex:(NSIndexPath*)indexPath tableView:(UITableView*)tableView{
    
    __block  CRUCellViewInteractionType type = CRUCellViewInteractionCheckToggle;
    __block  NSString *cellText = nil;
    __block  NSString *detailText = nil;
    __block  NSUInteger indexRow = indexPath.row;
    __block  BOOL collapsed = false;
    
    //handle Manager specifics
    if(self.hierarchy && indexRow == 0){
        type = CRUCellViewInteractionHeader;
        collapsed = self.expanded;
        cellText = self.headerTitle;
        detailText = self.returnDetailText;
    }
    else{
        
        [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
            
            if( indexRow == section.headerRowNum){
                type = CRUCellViewInteractionHeader;
                cellText = section.title;
                collapsed = section.returnExpanded;
                detailText = section.detailedHeaderSectionText;
                *stop = YES;//kick out since we found the row
            }
            else if(section.returnExpanded && [section rowNumInRange:indexRow]){
                type = [section returnTypeWithRow:indexRow];
                cellText = [section returnLabelNameAtRow:indexRow];
                collapsed = [section checkStateOfRowWithIndexRow:indexRow];
                detailText = [section returnDescriptionWithRow:indexRow];
                *stop = YES;//kick out since we found the row
            }
        }];
    }
    
    MHTableViewCell *cell = [self createCellWithtableView:tableView interactionType:type checked:collapsed];
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (void)selectedRowAtIndexPath: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    __block MHTableViewCell *cell = (MHTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    __block CRUCellViewInteractionType type = cell.cellViewInteractionType;
    __block NSUInteger indexRow = indexPath.row;

    //toogle manager as a whole for hierarchy
    if(self.hierarchy && indexRow == 0){
        
        [self toggleCollapse:tableView indexPath:indexPath];
        [cell changeCellStateWithToggle:self.expanded];
    }
    else{
        
        switch (type) {
            //modal types
            case CRUCellViewInteractionPicker:
            case CRUCellViewInteractionCheckList:
            case CRUCellViewInteractionTextBox:
            {
                [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
                    
                    if(section.returnExpanded && [section rowNumInRange:indexRow]){
                        //NOTE: this flips the expanded boolean and then returns it
                        BOOL check = [section toggleCheckAndReturnWithIndex:indexRow];
                        [cell changeCellStateWithToggle:check];
                        [section setCurrentModalIndexWithRow:indexRow];
                        //call delegate to create modal for checklist
                        //section should delegate views/data on modal
                        [self.delegate createModalWithType:type section:section rowPath:indexPath];
                        *stop = YES;//kick out since we found the row
                    }
                }];
            }
            break;
            
            //Header and Toggle types (non modal)
            default:
            {
                [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
                    //toggle the header in collapsed state or expanded state
                    if(type == CRUCellViewInteractionHeader && indexRow == section.headerRowNum){
                        [section toggleExpanded];
                        if(self.hierarchy){
                            [self updateOtherSectionLocationsWithSection:section index:index];
                        }
                        [section toggleCollapse:tableView indexPath:indexPath];
                        [cell changeCellStateWithToggle:section.returnExpanded];
                        
                        *stop = YES;//kick out since we found the row
                    }
                    //toggle checkmark for check toggle
                    else if(section.returnExpanded && [section rowNumInRange:indexRow] && type == CRUCellViewInteractionCheckToggle){
                        //NOTE: this flips the expanded boolean and then returns it
                        BOOL check = [section toggleCheckAndReturnWithIndex:indexRow];
                        [cell changeCellStateWithToggle:check];
                        *stop = YES;//kick out since we found the row
                    }
                }];
            }
                break;
        }//end switch
    }
    //Notify the view controller to invoke specific modal based on type
       
}

//Before the section even expands or collapses, the other sections are notified so their ranges will
//match. This is because the tableview can trigger the cells offscreen to reppear and so the other sections
//need to know before the one that actually collapses
- (void)updateOtherSectionLocationsWithSection:(MHCollapsibleSection*)changedSection index:(NSUInteger)sectionSpot{
    
    __block NSUInteger newLocation = 0;
    __block NSUInteger previousNumOfRows = 1;
    
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
  
        newLocation += previousNumOfRows;
        [section resetRangeWithNum:newLocation];
        previousNumOfRows = section.numOfRows;
    }];
    
}


//toogles the children rows
- (void)toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    __block NSIndexPath *tempPath = nil;
    //Get the section for creating array of indexpaths
    __block NSInteger pathSection = indexPath.section;
    __block NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        if(section.returnExpanded){
            //toggles bool for section
            [section toggleExpanded];
            //notifies other sections so their ranges match
            [self updateOtherSectionLocationsWithSection:section index:index];
            //does delete/insert for section
            [section toggleCollapse:tableView indexPath:indexPath];
        }
        tempPath = [NSIndexPath indexPathForRow:section.headerRowNum inSection:pathSection];
        [pathArray addObject:tempPath];
    }];
    
    self.expanded = !self.expanded;
    
    if(self.expanded){
        [tableView insertRowsAtIndexPaths:pathArray withRowAnimation:self.rowAnimation];
    }
    else{
        [tableView deleteRowsAtIndexPaths:pathArray withRowAnimation:self.rowAnimation];
    }
    
    if(self.expanded){
        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    pathArray = nil;
    
}

- (NSMutableArray*)returnPackagedFilter{
    
    __block NSString *filterTag = @"";
    __block NSString *resultValue = @"";
    __block NSMutableArray *filterArray = [[NSMutableArray alloc] init];
    __block NSArray *sectionDataArray = [[NSArray alloc] init];
    __block NSArray *labelDataArray = [[NSArray alloc] init];
    __block MHPackagedFilter *filter;
    

    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        
        if(section.selectedCountForSubTitleText > 0){
            
            if(self.hierarchy){
                
                filterTag = self.subtitleCountText;
                filter = [[MHPackagedFilter alloc] initWithRootKey:filterTag rootValue:section.getIdentifier hierarchy:YES];
            }
            else{
                
                filterTag = section.getIdentifier;
            }
            
            filter = [[MHPackagedFilter alloc] initWithRootKey:filterTag rootValue:section.getIdentifier hierarchy:NO];
            sectionDataArray = section.returnCopyOfFilterData;
            [sectionDataArray enumerateObjectsUsingBlock:^(MHFilterLabel *label, NSUInteger index, BOOL *stop){
                if(self.hierarchy){
                    if(label.hasSelectedItems){
                        labelDataArray = label.returnSelectedArray;
                        [labelDataArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger index, BOOL *stop){
                            [filter addFilterWithKey:label.labelName value:key];
                        }];
                    }
                }
                else{
                    if(label.selectedCell){
                        resultValue = label.labelName;
                        [filter addFilterWithKey:filterTag value:resultValue];
                    }
                }
            }];
            [filterArray addObject:filter];
        }
        
    }];
    
    return filterArray;
}




@end
