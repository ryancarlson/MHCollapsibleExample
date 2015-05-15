//
//  MHCollapsibleViewManager.m
//  This is a manager of a uiview and view controller
//
//  Created by Lizzy Randall on 5/6/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHCollapsibleViewManager.h"
#import "MHFilterLabel.h"

@implementation MHCollapsibleViewManager

//@synthesize tableView;
//@synthesize viewController;
@synthesize rowAnimation;

@synthesize data;
@synthesize cellStyles;
@synthesize headerTitle;

@synthesize expanded;
@synthesize numOfRows;

//Initialize with animation, title and tableView
- (id)initalizeManager:(UITableViewRowAnimation)animation title:(NSString*) title tableView:(UITableView*)tableView
{
    self.headerTitle = title;
    self.rowAnimation = animation;
    //initialized first and then can be overwritten by controller
    //tableView is needed to create cells to store types
    [self setCellProperties:nil header:nil clickedCell:nil normalCell:nil tableView:tableView];
    return self;
}

//called after Initializing Manager
- (void) initializeData:(NSMutableArray*)dataFromController
{
    self.data = [[NSMutableArray alloc] init];
    for(int i=0; i < [dataFromController count] ; i++)
    {
        [data addObject:[MHFilterLabel constructLabel:[dataFromController objectAtIndex:i] checked:false]];
    }
    self.numOfRows = (NSInteger)[data count];
}

//set the cell provided with same settings as corresponding array type
- (UITableViewCell*)setCellSettings:(UITableViewCell*)cell type:(NSString*)type
{
    UITableViewCell *tempCell = nil;
    int index = 3; //normall cell
    if([type isEqual: @"ClickedHeader"])
    {
        index = 0;
    }
    else if([type isEqual: @"NormalHeader"])
    {
        index = 1;
    }
    else if([type isEqual: @"ClickedCell"])
    {
        index = 2;
    }
    
    tempCell = [cellStyles objectAtIndex:index];
    cell.accessoryType = tempCell.accessoryType;
    cell.accessoryView = tempCell.accessoryView;
    cell.textLabel.textColor = tempCell.textLabel.textColor;
    
    if(index == 0 || index == 1)
    {
        cell.textLabel.text = self.headerTitle;
        if(self.numOfRows > 0)
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%i items",), self.numOfRows];
        else
            cell.detailTextLabel.text = @"No item";
    }
    tempCell = nil;
    return cell;
}

//takes in four cells that are formatted or takes nil and creates default cells
- (void)setCellProperties:(UITableViewCell*)clickedHeader header:(UITableViewCell*)header clickedCell:(UITableViewCell*)clickedCell normalCell:(UITableViewCell*)cell tableView:(UITableView*)tableView
{
    //normal cell with no accessory is non selected row
    if (cell == nil)
        cell = [self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView];
    //checkmark shown is the default for when row selected
    if (clickedCell == nil)
        clickedCell = [self returnAccessorizedCell:UITableViewCellAccessoryCheckmark tableView:tableView];
    if (header == nil)
    {
        header = [self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView];
        header.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow"]];
    }
    if (clickedHeader == nil)
    {
        clickedHeader = [self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView];
        //Add up arrow for accessoryView
        clickedHeader.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
        //Color is the same as the checkmark for the children rows
        clickedHeader.textLabel.textColor = [[UIColor alloc] initWithRed:0 green:.48 blue:1.0 alpha:1.0];
    }
    
    //Keeps track of cell properties for the various states
    self.cellStyles =  [NSArray arrayWithObjects: clickedHeader, header, clickedCell, cell, nil];
    //0 = clickedHeader 1 = normalHeader 2 = clickedCell (checkmark default) 3 = normalCell
}

//Returns all selected rows from data object
- (NSMutableArray*)returnSelectedRows
{
    NSMutableArray *selected = [NSMutableArray init];
    for (int i=0; i < [data count]; i++)
    {
        MHFilterLabel *label = [data objectAtIndex:i];
        if(label.checked)
            [selected addObject:label];
    }
    return selected;
}

//creates and returns a default accessorized cell to be modified
- (UITableViewCell*)returnAccessorizedCell:(UITableViewCellAccessoryType)accessory tableView:(UITableView*)tableView
{
    NSString *cellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.accessoryType = accessory;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

//creates a cell and returns what it should look like depending on if the header has been clicked
//or if normal cell has been clicked
-(UITableViewCell*)returnCell:(NSIndexPath*)indexPath tableView:(UITableView*)tableView
{
    UITableViewCell *cell;
    if(indexPath.row == 0)
    {
        if(self.expanded)
            cell =  [self setCellSettings:[self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView] type:@"ClickedHeader"];
        else
            cell = [self setCellSettings:[self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView] type:@"NormalHeader"];
    }
    else
    {
        //-1 is for offset of header row since data does not include header
        MHFilterLabel *label = [data objectAtIndex:indexPath.row-1];
        if(label.checked)
            cell = [self setCellSettings:[self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView] type:@"ClickedCell"];
        else
            cell = [self setCellSettings:[self returnAccessorizedCell:UITableViewCellAccessoryNone tableView:tableView] type:@"NormalCell"];
        cell.textLabel.text = label.name;
    }
    return cell;
}

- (void) selectedRowAtIndexPath: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    //normal cell that was selected
    if(indexPath.row > 0)
    {
        MHFilterLabel *label = [data objectAtIndex:indexPath.row-1];
        NSString *type = nil;
        
        label.checked = !label.checked;
        
        if(label.checked)
            type = @"ClickedCell";
        else
            type = @"NormalCell";
        
         [self setCellSettings:[tableView cellForRowAtIndexPath:indexPath] type:type];
    }
    //header cell, add data, change look, etc.
    else
        [self toggleCollapse:tableView indexPath:indexPath];
}


//toogles the children rows and handles the look of the header row
//as a result from collapsing/expanding
- (void) toggleCollapse: (UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    //toogle expanded, used to check for if the header has been clicked
    self.expanded = !self.expanded;
    
    int count = (int)self.numOfRows;
    
    NSIndexPath *tempPath = nil;
    //Get the section for creating array of indexpaths
    NSInteger section = indexPath.section;
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    
    for(int i=1; i <= count; i++)
    {
        tempPath = [NSIndexPath indexPathForRow:i inSection:section];
        [pathArray addObject:tempPath];
    }
    
    if(expanded)
        [tableView insertRowsAtIndexPaths:pathArray withRowAnimation:self.rowAnimation];
    else
        [tableView deleteRowsAtIndexPaths:pathArray withRowAnimation:self.rowAnimation];
    
    pathArray = nil;
    
    if(expanded)
        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //Change look of header for arrow, etc. just before deslecting the row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.expanded)
        cell = [self setCellSettings:cell type:@"ClickedHeader"];
    else
        cell = [self setCellSettings:cell type:@"NormalHeader"];
    cell = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
