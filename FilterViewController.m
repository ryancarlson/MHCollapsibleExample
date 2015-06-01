//
//  FilterViewController.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "FilterViewController.h"
#import "MHCollapsibleViewManager.h"

@interface FilterViewController()

- (NSArray*)returnLabelArray;
- (NSArray*)returnAssignedToArray;
- (NSArray*)returnSurveyArray;

@end

@implementation FilterViewController

@synthesize managerArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MHCollapsibleViewManager *labels = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Labels" tableView:self.tableView];
    
    //sends double array for filternames and single array for header lines
    [labels setDataWithFilterNames:@[self.returnLabelArray] headerTitles:@[@"Labels"]];
    
    MHCollapsibleViewManager *surveys = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Surveys" tableView:self.tableView];
    
    NSArray *surveyAnswers = @[@[self.returnSurveyArray], @[self.returnSurveyArray], @[self.returnSurveyArray]];
    NSArray *surveyQuestions = @[@"Survey 1", @"Survey 2", @"Survey 3"];
    [surveys setDataWithFilterNames:surveyAnswers headerTitles:surveyQuestions];
    surveyAnswers = nil;
    surveyQuestions = nil;
    
    MHCollapsibleViewManager *interactions = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Interactions" tableView:self.tableView];
    //Index 0 is title
    [interactions setDataWithFilterNames:@[self.returnInteractionsArray] headerTitles:@[@"Interactions"]];
    
    //ManagerArray stores each controller or manager
    managerArray = [NSMutableArray arrayWithObjects:labels, surveys, interactions, nil];
    surveys = nil;
    labels = nil;
}

//simply populates data since it's more complicated now
- (NSArray*)returnLabelArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Freshman" checked:false interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Sophomore" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Junior" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Senior" checked:false interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

- (NSArray*)returnSurveyArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Survey Question 1" checked:false interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Survey Question 2" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Survey Question 3" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Survey Question 4" checked:false interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}
//simple populates data
- (NSArray*)returnAssignedToArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Jan" checked:false interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Sue" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Andy" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Peggy" checked:false interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

//simple populates data
- (NSArray*)returnInteractionsArray{
    
    NSArray* filterData = [[NSArray alloc] initWithObjects: [[MHFilterLabel alloc] initLabelWithName:@"Personal Evangelism Decisions" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Personal Evangelism" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Holy Spirit Presentation" checked:false interactionType:CRUCellViewInteractionCheckToggle], nil];
    return filterData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section.
    MHCollapsibleViewManager *manager = [managerArray objectAtIndex:section];
    //There will at least be one because of the header
    NSUInteger numOfRows = (NSInteger) manager.numOfRows;
    NSLog(@"%d%@", (int)numOfRows, manager.title);
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //managerArray per section
   return [managerArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temp manager to get create and return cell
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
    
    UITableViewCell * cell = (UITableViewCell*)[manager returnCellWithIndex:indexPath tableView:tableView];
    
    return cell;
    
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCollapsibleViewManager *manager = [managerArray objectAtIndex:indexPath.section];
   
    //manager handles look and keeping track if whatever cell has been selected
    [manager selectedRowAtIndexPath:tableView indexPath:indexPath];
    
    //Fix ios 7 bug via stackoverflow:
    //http://stackoverflow.com/questions/19212476/uitableview-separator-line-disappears-when-selecting-cells-in-ios7
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    manager = nil;
}


@end
