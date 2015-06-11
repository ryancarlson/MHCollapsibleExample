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

//Handles clear, save and cancel for modals
- (void)saveChangesForCurrentSection;
- (void)cancelChangesForCurrentSection;
- (void)clearChangesForCurrentSection;

@property (strong, nonatomic) MHCollapsibleSection *currentSection;
@property (nonatomic) CRUCellViewInteractionType currentModalType;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createManagersAndPopulateData];

}

//Can be overwritten or added onto since the objects exist on the class
//rather than in the method
- (void)setHalfModalViewLook{
    
    self.modalOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    self.modalOverlay.alpha = 0;
    self.modalOverlay.backgroundColor = [UIColor blackColor];
    self.navigationController.toolbarHidden = NO;
    self.modalCurrentlyShown = NO;
}

//Instatiate and create managers in this method while also populating the data to give to managers
//the end result should do the following: Managers in an array, each manager has a delegate of this controller
// Methods to call: initManagerWithAnimation, setDataFilterNames, setSubtitleTextForSectionsWithString
- (void)createManagersAndPopulateData{
    
    MHCollapsibleViewManager *labels = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Labels" tableView:self.tableView];
    
    //sends double array for filternames and single array for header lines
    [labels setDataWithFilterNames:self.returnLabelArray headerTitles:@[@"Labels"]];
    
    MHCollapsibleViewManager *surveys = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Surveys" tableView:self.tableView];
    
    NSArray *surveyQuestions = @[self.returnSurveyArray, self.returnSurveyArray, self.returnSurveyArray];
    NSArray *surveyList = @[@"Preview Weekend - Technology", @"Survey for:Lab", @"Predefined Questions"];
    [surveys setDataWithFilterNames:surveyQuestions headerTitles:surveyList];
    surveyList = nil;
    surveyQuestions = nil;
    
    MHCollapsibleViewManager *interactions = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Interactions" tableView:self.tableView];
    //Index 0 is title
    [interactions setDataWithFilterNames:@[self.returnInteractionsArray] headerTitles:@[@"Interactions"]];
    
    //do not do plural, just singleton
    //this identifies uniquely what the filters are
    [labels setSubtitleTextForSectionsWithString:@"label" rootText:@"label" managerIndex:0];
    [surveys setSubtitleTextForSectionsWithString:@"question" rootText:@"survey" managerIndex:1];
    [interactions setSubtitleTextForSectionsWithString:@"interaction" rootText:@"interaction" managerIndex:2];
    
    //ManagerArray stores each controller or manager
    labels.delegate = self;
    surveys.delegate = self;
    interactions.delegate = self;
    self.managerArray = [NSMutableArray arrayWithObjects:labels, surveys, interactions, nil];
    
    surveys = nil;
    labels = nil;
    
}

- (IBAction)buttonTapped:(UIBarButtonItem*)sender{
    
    if([sender.title isEqualToString: @"Clear"]){
        
        if(self.modalCurrentlyShown){
            //clear just shown on modal, the temp storage
            //is cleared with this method
            [self clearChangesForCurrentSection];
        }
        else{
            
            //This is a hard clear in a sense all labels and their results (not temp results) will get cleared
            [self.managerArray enumerateObjectsUsingBlock:^(MHCollapsibleViewManager *manager, NSUInteger index, BOOL *stop){
                [manager clearAllData];
            }];
            //reload the entire table since multiple managers
            //could have been affected by the clear
            [self.tableView reloadData];
        }
    }
    else if ([sender.title isEqualToString: @"Save"]){
        
        //Loop through the managers and get a MHPackagedFilter for each
        //these are concatonated. MHPackagedFilter contains key/value pairs and can have a hierarchy
        //depending if the manager had to create multiple sections
        [self.managerArray enumerateObjectsUsingBlock:^(MHCollapsibleViewManager *manager, NSUInteger index, BOOL *stop){
            NSMutableArray *filter = manager.returnPackagedFilter;
            if(filter != nil){
                [self.combinedFilters addObjectsFromArray:filter];
            }
        }];
        
        //Now the data is stored in an array of MHPackagedFilters, with key/value pairs
        //They can be parsed and packaged to whatever API needs to be called
        //For a subclass, just call super on this class and then handle the combinedFilters array accordingly
        
    }
    else if([sender.title isEqualToString:@"Cancel"]){
        
        //dismiss modal, nothing needs to be sent to the search view controller or wherever the filter gets sent
        self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma Manager Delegate
    
    self.currentSection = section;
    self.currentModalType = cellType;
    self.currentRowPath = rowPath;
    self.modalCurrentlyShown = YES;
    
    //Not all will need these buttons but most will have them in common
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(saveChangesForCurrentSection)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangesForCurrentSection)];
    
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(clearChangesForCurrentSection)];
    
    switch (cellType) {
            
        case CRUCellViewInteractionCheckList:{
            
            UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            //section will delegate displaying cell selects, etc.
            //and what data will be shown
            tableViewController.tableView.delegate = section;
            tableViewController.tableView.dataSource = section;
            
            //tableviewcontroller has save, cancel and clear buttons

            //navigation controller for handling the back/forth of the modal
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            
            navigationController = nil;
            tableViewController = nil;
            
        }
        case CRUCellViewInteractionPicker:{
            
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.delegate = section;
            picker.dataSource = section;
            
            UIViewController *pickerViewController = [[UIViewController alloc] init];
            [pickerViewController.view addSubview:picker];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
            navigationController = nil;
            pickerViewController = nil;
            
            
        }
            
        default:
            break;
    }
    
}

    }
    }
    }


    
    [self.currentSection saveChanges];

}

- (void)cancelChangesForCurrentSection{
    
    [self.currentSection cancelChanges];
    
}

- (void)clearChangesForCurrentSection{
    
    [self.currentSection clearSelections];
    
        
        UITableViewController *tableViewController = (UITableViewController*)navigationController.topViewController;
        //since the checkmarks have been cleared, reload the table to show the clear affect
        [tableViewController.tableView reloadData];
        tableViewController = nil;
        navigationController = nil;
    }
    
}

- (NSArray*)returnSurveyAnswers{
}

//simply populates data since it's more complicated now
- (NSArray*)returnLabelArray{
    
    return filterData;
}

- (NSArray*)returnSurveyArray{
    
    
    //optional description, show as section title on modal
    [checkListLabel setLabelDescriptionWithString:@"Select survey answers"];
    
    
    //optional description, show as section title on modal
    [checkListLabel2 setLabelDescriptionWithString:@"Select survey answers"];
    
    
    
    NSArray* filterData = @[checkListLabel,checkListLabel2, checkListLabel3];
    
    checkListLabel = nil;
    checkListLabel2 = nil;
    checkListLabel3 = nil;
    
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
