//
//  MHCollapsibleViewManager.m
//  This is a manager of a uiview and view controller
//
//  Created by Lizzy Randall on 5/6/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHCollapsibleViewManager.h"

@interface MHCollapsibleViewManager()

@property (strong, nonatomic) NSString *headerTitle;
@property (strong, nonatomic) NSString *singleIdentifier;
@property (strong, nonatomic) NSString *pluralIdentifier;
@property (strong, nonatomic) NSMutableArray *filterSections;
@property (nonatomic) UITableViewRowAnimation rowAnimation;
//hierarchy determines if Manager will be collapsible itself
//otherwise there is just one MHCollapsibleSection dictating itself
@property (nonatomic) BOOL hierarchy;
//Boolean keeps track if header has been clicked
//expanded = YES means children rows are shown
//expanded = NO means children rows are not shown
@property (nonatomic) BOOL expanded;

- (void)toggleCollapse:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
//internal to the manager, it shows "# of selected __" if sections made
//or # of items if no selections made
- (NSString*)returnDetailText;
//This is based on a count of 1 per section if the section has at least 1 selected
//it does not total up since one section could have a label with results > 1
//internal method since it's just shown on the table the detailText
- (NSUInteger)numOfSelectedRowsForText;
- (NSString*)getIdentifier;

@end

@implementation MHCollapsibleViewManager

#pragma Initalizing

-(instancetype)init{
    self = [super init];
    if(self){
        self.filterSections = [NSMutableArray alloc];
        self.hierarchy = NO;
        self.headerTitle = @"";
        self.expanded = NO;
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
        self.hierarchy = NO;
        self.rowAnimation = animation;
        self.filterSections = [self.filterSections init];
    }
    return self;
}

#pragma Initial Settings

- (void)setFilterArraysWithFirstArrayAsHeaderTitles:(NSArray*)firstArray, ... NS_REQUIRES_NIL_TERMINATION{
    
    NSArray *headerTitles = firstArray;
    NSArray *filterArray = firstArray;
    NSUInteger count = 0; //tells of hierarchy
    MHCollapsibleSection *section;
    NSUInteger filterCount =  0;
    NSUInteger start = 1;
    NSRange range;
    
    //Defaults to hierarchy, based on count that will change
    self.hierarchy = YES;
    self.expanded = NO;
    
    va_list arguments;
    //va start makes firstArray skipped, the first argument in loop
    //is actually the second argument, this is what is wanted
    //since header titles is the firstArray
    va_start(arguments, firstArray);

    while((filterArray = va_arg(arguments, NSArray*))){
        
        filterCount = filterArray.count+1;//offset for section header row, length includes header
        range = NSMakeRange(start, filterCount);
        section = [MHCollapsibleSection alloc];
        section = [section initWithArray:filterArray headerTitle:headerTitles[count] animation:self.rowAnimation rowRange:range];
        [self.filterSections addObject:section];
        start++;
        count++;
    }
    va_end(arguments);
    
    //Only one array, this is not a hierarchy
    //so the starting range needs to not be one off
    //start is originally 1 for the manager's header
    if(count < 2){
        
        start = 0;

        //There should be only one section in this manager, but the loop is better to code for just in case
        [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *loopSection, NSUInteger index, BOOL *stop){
            [loopSection resetRangeWithNum:start];
        }];
        self.hierarchy = NO;
        self.expanded = YES;
    }

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
            self.hierarchy = YES;
            start += 1;
            self.expanded = NO;
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
- (void)setTextIdentifierAndIndexWithSingleIdentifier:(NSString *)singleIdentifier pluralIdentifier:(NSString*)pluralIdentifier managerIndex:(NSUInteger)managerIndex{
    
    [self.filterSections enumerateObjectsUsingBlock:^(MHCollapsibleSection *section, NSUInteger index, BOOL *stop){
        
        [section setSelectedIdentifierWithSingleIdentifier:singleIdentifier pluralIdentifier:pluralIdentifier];
        [section setManagerIndexWithIndex:managerIndex];
    }];
    
    //Defaults to children identifiers unless overwritten by
    //setTextIdentifierForManager...
    self.singleIdentifier = singleIdentifier;
    self.pluralIdentifier = pluralIdentifier;
}

- (void)setTextIdentifierForManagerWithSingleIdentifier:(NSString *)singleIdentifier pluralIdentifier:(NSString*)pluralIdentifier{
    
    self.singleIdentifier = singleIdentifier;
    self.pluralIdentifier = pluralIdentifier;
}


#pragma Get Information on the Manager

- (NSString*)title{
    
    return self.headerTitle;
}

//numOfSections changes based on if manager is expanded
- (NSUInteger)numOfSections{
    
    NSUInteger rowCount = 0;
    if(self.expanded){
        rowCount = self.filterSections.count;
    }
    return rowCount;
}

//numOfRows changes based on if the manager is expanded
//and if it is a hierarchy
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

//creates and returns a default accessorized cell to be modified
- (MHTableViewCell*)createCellWithtableView:(UITableView*)tableView interactionType:(CRUCellViewInteractionType)type checked:(BOOL)checked{
    
    NSString *cellIdentifier = @"Cell";

    MHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(type == CRUCellViewInteractionHeader){
        cellIdentifier = @"Header";
    }
    else if(type != CRUCellViewInteractionCheckToggle){
        //Indicator is checked in MHCell's version of initWithStyle
        //it determines the look of the cell by default
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

- (NSString*)getIdentifier{
    
    NSString *identifier;
    if(self.numOfSelectedRowsForText > 1){
        identifier = self.pluralIdentifier;
    }
    else{
        identifier = self.singleIdentifier;
    }
    return identifier;
}

- (NSString*)returnDetailText{
    
    NSUInteger count = self.numOfSelectedRowsForText;
    NSString *detailedText;
    NSString *itemTitle = self.getIdentifier;
    
    if(itemTitle == nil){
        itemTitle = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_defaultText_single", @"Localizable", nil);
    }
    
    if(count < 1){
        count = self.filterSections.count;
        if(count > 1){
            itemTitle = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_defaultText_plural", @"Localizable", nil);
        }
    }
    detailedText = [NSString stringWithFormat:NSLocalizedString(itemTitle,nil), count];
    
    itemTitle = nil;
    return detailedText;
}

//creates a cell and returns what it should look like depending on if the header has been clicked
//or if normal cell has been clicked
-(MHTableViewCell*)returnCellWithIndex:(NSIndexPath*)indexPath tableView:(UITableView*)tableView{
    
    __block  CRUCellViewInteractionType type = CRUCellViewInteractionCheckToggle;
    __block  NSString *cellText = nil;
    __block  NSString *detailText = nil;
    __block  NSUInteger indexRow = indexPath.row;
    __block  BOOL collapsed = NO;
    
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

- (void)selectedRowAtIndexPath:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
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
                        //Reload the header row of that modal so it's counter for # of selected items changes
                        NSIndexPath *rootPath = [NSIndexPath indexPathForRow:section.headerRowNum inSection:section.returnManagerIndex];
                        [tableView reloadRowsAtIndexPaths:@[rootPath] withRowAnimation:UITableViewRowAnimationNone];
                        rootPath = nil;
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
- (void)toggleCollapse:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
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

//Returns a mutable array of packaged filters for each filter label
//MHPackaged Filter is made up of key value pairs with a root key value pair
//if it's a hierarchy. The root shows what type the children expansions are
//for example surveys and survey questions. Each question name ex: "What is your phone number?"
//will have a value. Key value pair: Question, Answer and yes there can be exactly the same
//for the key value pair, so the same key can exist but with different values
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
                
                filterTag = self.singleIdentifier;
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
