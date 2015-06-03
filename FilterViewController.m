//
//  FilterViewController.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController() 

- (NSArray*)returnLabelArray;
- (NSArray*)returnAssignedToArray;
- (NSArray*)returnSurveyArray;
- (NSArray*)returnSurveyAnswers;
- (void)saveChangesForCurrentSection;
- (void)cancelChangesForCurrentSection;
- (void)clearChangesForCurrentSection;

@property (strong, nonatomic) MHCollapsibleSection *currentSection;
@property (nonatomic) CRUCellViewInteractionType currentModalType;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MHCollapsibleViewManager *labels = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Labels" tableView:self.tableView];
    
    //sends double array for filternames and single array for header lines
    [labels setDataWithFilterNames:self.returnLabelArray headerTitles:@[@"Labels"]];
    
    MHCollapsibleViewManager *surveys = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Surveys" tableView:self.tableView];
    
    NSArray *surveyQuestions = @[self.returnSurveyArray, self.returnSurveyArray, self.returnSurveyArray];
    NSArray *surveyList = @[@"Survey 1", @"Survey 2", @"Survey 3"];
    [surveys setDataWithFilterNames:surveyQuestions headerTitles:surveyList];
    surveyList = nil;
    surveyQuestions = nil;
    
    MHCollapsibleViewManager *interactions = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Interactions" tableView:self.tableView];
    //Index 0 is title
    [interactions setDataWithFilterNames:@[self.returnInteractionsArray] headerTitles:@[@"Interactions"]];
    
    //ManagerArray stores each controller or manager
    labels.delegate = self;
    surveys.delegate = self;
    interactions.delegate = self;
    self.managerArray = [NSMutableArray arrayWithObjects:labels, surveys, interactions, nil];
    
    surveys = nil;
    labels = nil;

}

#pragma Manager Delegate
- (void) createModalWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection *)section row:(NSUInteger)row{
    
    self.currentSection = section;
    self.currentModalType = cellType;
    
    //Not all will need these buttons but most will have them in common
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(saveChangesForCurrentSection)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangesForCurrentSection)];
    UIBarButtonItem *clear =[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearChangesForCurrentSection)];
    
    switch (cellType) {
            
        case CRUCellViewInteractionCheckList:
        {
            UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            //section will delegate displaying cell selects, etc.
            //and what data will be shown
            tableViewController.tableView.delegate = section;
            tableViewController.tableView.dataSource = section;
            
            //tableviewcontroller has save, cancel and clear buttons
            tableViewController.navigationItem.title = [section returnLabelNameAtRow:row];
            tableViewController.navigationItem.rightBarButtonItem = save;
            tableViewController.navigationItem.leftBarButtonItem = cancel;
            [tableViewController setToolbarItems:@[clear]];

            //navigation controller for handling the back/forth of the modal
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            
            navigationController = nil;
            tableViewController = nil;
            
        }
        break;
            
        default:
            break;
    }
    
}

- (void)saveChangesForCurrentSection{

    [self.currentSection saveChanges];

    self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelChangesForCurrentSection{
    
    [self.currentSection cancelChanges];
    
    self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearChangesForCurrentSection{
    
    [self.currentSection clearSelections];
    
    UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
    if([navigationController.topViewController isKindOfClass:[UITableViewController class]]){
        
        UITableViewController *tableViewController = (UITableViewController*)navigationController.topViewController;
        //since the checkmarks have been cleared, reload the table to show the clear affect
        [tableViewController.tableView reloadData];
        tableViewController = nil;
        navigationController = nil;
    }
    
}
- (NSArray*)returnSurveyAnswers{
    return @[@"Answer 1", @"Answer2", @"Answer3", @"Answer4", @"Answer 5"];
}

//simply populates data since it's more complicated now
- (NSArray*)returnLabelArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Freshman" checked:false interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Sophomore" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Junior" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Senior" checked:false interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

- (NSArray*)returnSurveyArray{
    
    MHFilterLabel *checkListLabel = [[MHFilterLabel alloc] initLabelWithName:@"Survey Question 1" checked:false interactionType:CRUCellViewInteractionCheckList];
    NSDictionary *surveyAnswers = [[NSDictionary alloc] initWithObjects:@[@NO, @NO, @NO, @NO, @NO] forKeys:self.returnSurveyAnswers];
    
    //optional description, show as section title on modal
    [checkListLabel setLabelDescriptionWithString:@"Select survey answers"];
    [checkListLabel setResultsWithDictionary:surveyAnswers];
    
    NSArray* filterData = @[checkListLabel,[[MHFilterLabel alloc] initLabelWithName:@"Survey Question 2" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Survey Question 3" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Survey Question 4" checked:false interactionType:CRUCellViewInteractionCheckToggle]];
    
    checkListLabel = nil;
    surveyAnswers = nil;
    
    return filterData;
}
- (NSArray*)returnAssignedToArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Jan" checked:false interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Sue" checked:false interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Andy" checked:false interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Peggy" checked:false interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

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
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:section];
    //There will at least be one because of the header
    NSUInteger numOfRows = (NSInteger) manager.numOfRows;
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //managerArray per section
   return [self.managerArray count];
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
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
   
    //manager handles look and keeping track if whatever cell has been selected
    [manager selectedRowAtIndexPath:tableView indexPath:indexPath];
    
    //Fix ios 7 bug via stackoverflow:
    //http://stackoverflow.com/questions/19212476/uitableview-separator-line-disappears-when-selecting-cells-in-ios7
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    manager = nil;
}


@end
