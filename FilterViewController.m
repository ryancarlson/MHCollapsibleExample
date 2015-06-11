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

//Initial methods called in viewDidLoad
- (void)setHalfModalViewLook;
- (void)createManagersAndPopulateData;

//Modal interaction methods
- (void)createModalWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection *)section rowPath:(NSIndexPath *)rowPath;
- (void)bringUpHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size;
- (void)removeHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size;
- (void)resignFirstResponderWithClearOption:(BOOL)clear;
- (IBAction)buttonTapped:(UIBarButtonItem*)sender; //modals and this viewcontroller call

//Modal settings
- (void)setButtonsAndColorWithController:(UIViewController*)viewController bgColor:(UIColor*)bgColor
                                  cancel:(UIBarButtonItem*)cancel save:(UIBarButtonItem*)save clear:(UIBarButtonItem*)clear;
- (void)setSettingsForNavWithController:(UINavigationController*)navigationController cgSize:(CGSize)size;

//Handles clear, save and cancel for modals
- (void)saveChangesForCurrentSection;
- (void)cancelChangesForCurrentSection;
- (void)clearChangesForCurrentSection;

//Creating pieces for modals
- (UILabel*)createLabelWithSection:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath cgSize:(CGSize)size;
- (UITextField*)createTextFieldWithSection:(MHCollapsibleSection*)section cgSize:(CGSize)size;

//Tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

//used for picker and textfield type modals
//since they only take up half a page anyway
@property UIView *modalOverlay;

//Keeping track of the current section gives the ability to get data
//and invoke actions from the filterviewcontroller
@property (strong, nonatomic) MHCollapsibleSection *currentSection;
@property (nonatomic) CRUCellViewInteractionType currentModalType;
@property (nonatomic) NSIndexPath *currentRowPath;

//Checked for Clear button since it appears on modals as well
@property (nonatomic) BOOL modalCurrentlyShown;
//After save button, this array is populated with MHPakcgaedFilter records
//returned by each MHCollapsibleViewManager
@property (nonatomic, strong) NSMutableArray *combinedFilters;

@end

@implementation FilterViewController

//For "half" modal background
static const CGFloat viewOverlayAlpha = .4;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.combinedFilters = [[NSMutableArray alloc] init];
    [self setHalfModalViewLook];
    [self createManagersAndPopulateData];

}

#pragma Set Modal and Manager Settings
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

#pragma  Button Interaction for Modals
//Save and Cancel are actually on the temporary modals
//While the save and cancel checked here are on the filterviewcontroller itself
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
//Handles creation of modal or pretend half modal that shows the type of uiview applicable
- (void)createModalWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection *)section rowPath:(NSIndexPath *)rowPath{
    
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
            [self setButtonsAndColorWithController:(UIViewController*)tableViewController bgColor:nil cancel:cancel save:save clear:clear];

            //navigation controller for handling the back/forth of the modal
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
            //do not call setSettingsforNav since this won't be a half view
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            
            navigationController = nil;
            tableViewController = nil;
            
        }
            break;
            
        case CRUCellViewInteractionPicker:{
            
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.backgroundColor = [UIColor whiteColor];
            picker.delegate = section;
            picker.dataSource = section;
            
            UIViewController *pickerViewController = [[UIViewController alloc] init];
            [self setButtonsAndColorWithController:pickerViewController bgColor:[UIColor whiteColor] cancel:cancel save:save clear:nil];
            //[pickerViewController.view addSubview:labelText];
            [pickerViewController.view addSubview:picker];
  
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
            [self setSettingsForNavWithController:navigationController cgSize:self.view.frame.size];
            [self bringUpHalfModalWithController:navigationController cgSize:self.view.frame.size];
            //keep the previously selected row in context so the user can see what they put before
            [picker selectRow:section.getCurrentFocusForPicker inComponent:0 animated:YES];

            navigationController = nil;
            pickerViewController = nil;
        }
            break;
            
        case CRUCellViewInteractionTextBox:{
            
            UILabel *descriptionText = [self createLabelWithSection:section rowPath:rowPath cgSize:self.view.frame.size];
            UITextField *textField = [self createTextFieldWithSection:section cgSize:self.view.frame.size];
            
            UIViewController *textAreaController = [[UIViewController alloc] init];
            [self setButtonsAndColorWithController:textAreaController bgColor:[UIColor whiteColor] cancel:cancel save:save clear:nil];
            
            [textAreaController.view addSubview:descriptionText];
            [textAreaController.view addSubview:textField];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:textAreaController];
            [self setSettingsForNavWithController:navigationController cgSize:self.view.frame.size];
            [self bringUpHalfModalWithController:navigationController cgSize:self.view.frame.size];
            
            navigationController = nil;
            textAreaController = nil;
        }
            
        default:
            break;
    }
    
}

//Used by each modal type to set buttons and the default color
//Not all of them will need each of them set, hence the check for nil on each
- (void)setButtonsAndColorWithController:(UIViewController*)viewController bgColor:(UIColor*)bgColor
                                  cancel:(UIBarButtonItem*)cancel save:(UIBarButtonItem*)save clear:(UIBarButtonItem*)clear{
    
    if(save != nil){
        viewController.navigationItem.rightBarButtonItem = save;
    }
    if(cancel != nil){
        viewController.navigationItem.leftBarButtonItem = cancel;
    }
    if(clear != nil){
        [viewController setToolbarItems:@[clear]];
    }
    if(bgColor != nil){
        viewController.view.backgroundColor = bgColor;
    }
}


//Set for half modal types
- (void)setSettingsForNavWithController:(UINavigationController*)navigationController cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    navigationController.toolbarHidden = NO;
    navigationController.view.frame = CGRectMake(0, height, width, height/2);
}

//Creates a UILabel for the actual label selected since the modal could cover up that selection
//and the user doesn't have to remember which one they selected this way
- (UILabel*)createLabelWithSection:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    UILabel *descriptionText = [[UILabel alloc] initWithFrame:CGRectMake(width/10, height/7, width-width/5, height/20)];
    descriptionText.text = [section returnLabelNameAtRow:rowPath.row];
    descriptionText.textColor = [UIColor blackColor];
    descriptionText.numberOfLines = 0;
    descriptionText.lineBreakMode = NSLineBreakByWordWrapping;
    
    return descriptionText;
}

//Creates a textfield for the user to enter their filter label
- (UITextField*)createTextFieldWithSection:(MHCollapsibleSection*)section cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(width/10, height/5, width - width/5, height/20)];
    NSString *previousText = section.getTextForTextArea;
    
    if([previousText isEqualToString:@""]){
        textField.placeholder = section.getLabelDescription;
    }
    else{
        textField.text = previousText;
    }
    
    textField.borderStyle = UITextBorderStyleLine;
    textField.delegate = section;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.keyboardType = UIKeyboardAppearanceDefault;
    //important to give responder
    [textField canBecomeFirstResponder];
    return textField;
}

//Handles animation and sub controller to add a sub controller onto this modal
//Creates a "Half-like" modal on the screen with the overlay
- (void)bringUpHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    self.modalOverlay.alpha = 0;
    [self.view addSubview:self.modalOverlay];
    [self addChildViewController:navigationController];
    [self.view addSubview:navigationController.view];
    [UIView animateWithDuration:.2 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        navigationController.view.frame = CGRectMake(0, height/2, width, height/2);
        self.modalOverlay.alpha = viewOverlayAlpha;
    }completion:^(BOOL finished){
    }];
    [navigationController didMoveToParentViewController:self];
}

//Removes the "half modal"
- (void)removeHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    [UIView animateWithDuration:.2 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        navigationController.view.frame = CGRectMake(0, height, width, height/2);
        self.modalOverlay.alpha = 0;
    }completion:^(BOOL finished){
        [self.modalOverlay removeFromSuperview];
        [navigationController willMoveToParentViewController:nil];
        [navigationController.view removeFromSuperview];
        [navigationController removeFromParentViewController];
    }];
}

//Saves the changes made by the user and handles refreshing
//so the user can see the results on the filter label of what they selected
- (void)saveChangesForCurrentSection{
    
    if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:NO];
    }
    
    [self.currentSection saveChanges];
    
    //since checklist type uses real modal
    if(self.currentModalType != CRUCellViewInteractionCheckList){
    
        UINavigationController *navigationController = self.childViewControllers[0];
        [self removeHalfModalWithController:navigationController cgSize:self.view.frame.size];
     
    }
    else{
        self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.modalCurrentlyShown = NO;
    //Reload the modal row to show results
    [self.tableView reloadRowsAtIndexPaths:@[self.currentRowPath] withRowAnimation:UITableViewRowAnimationNone];
    //Reload the header row of that modal so it's counter for # of selected items changes
    NSIndexPath *rootPath = [NSIndexPath indexPathForRow:self.currentSection.headerRowNum inSection:self.currentSection.returnManagerIndex];
    [self.tableView reloadRowsAtIndexPaths:@[rootPath] withRowAnimation:UITableViewRowAnimationNone];
    //manager header row num is always 0, reload this just in case it's a newly selected item for # change text
    rootPath = [NSIndexPath indexPathForRow:0 inSection:self.currentSection.returnManagerIndex];
    [self.tableView reloadRowsAtIndexPaths:@[rootPath] withRowAnimation:UITableViewRowAnimationNone];
    rootPath = nil;
}

//Dismisses the half modal or full modal
//Resets the temp data stored in the label so that the changes are not kept
- (void)cancelChangesForCurrentSection{
    
    if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:NO];
    }
    
    [self.currentSection cancelChanges];
    
    //since checklist type is a true modal
    if(self.currentModalType != CRUCellViewInteractionCheckList){
    
        UINavigationController *navigationController = self.childViewControllers[0];
        [self removeHalfModalWithController:navigationController cgSize:self.view.frame.size];

    }
    else{
        
        self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.modalCurrentlyShown = NO;
}

//Clears the temp data so that a clear isn't saved, the user will need to hit save
//after clearing to make the clear permanent
- (void)clearChangesForCurrentSection{
    
    [self.currentSection clearSelections];
    
    if(self.currentModalType == CRUCellViewInteractionCheckList){
        
        UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
        UITableViewController *tableViewController = (UITableViewController*)navigationController.topViewController;
        //since the checkmarks have been cleared, reload the table to show the clear affect
        [tableViewController.tableView reloadData];
        tableViewController = nil;
        navigationController = nil;
    }
    else if(self.currentModalType == CRUCellViewInteractionPicker){
        
        UINavigationController *navigationController = (UINavigationController*)self.childViewControllers[0];
        UIViewController *pickerViewController = navigationController.topViewController;
        
        [pickerViewController.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop){
            
            if([view isKindOfClass:[UIPickerView class]]){
                
                UIPickerView *pickView = (UIPickerView*)view;
                [pickView selectRow:self.currentSection.getCurrentFocusForPicker inComponent:0 animated:YES];
            }
        }];
    }
    else if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:YES];
    }
    self.modalCurrentlyShown = NO;
}

//Resigns the keyboard so the save/cancel buttons can take control after
- (void)resignFirstResponderWithClearOption:(BOOL)clear{
    
    UINavigationController *navigationController = (UINavigationController*)self.childViewControllers[0];
    UIViewController *textFieldViewController = navigationController.topViewController;
    
    [textFieldViewController.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *textField = (UITextField*)view;
            
            if(clear){
                textField.text = @"";
            }
            [textField resignFirstResponder];
        }
    }];
    
}


- (NSArray*)returnSurveyAnswers{
    return @[@"First Year", @"Second Year", @"Third Year", @"Fourth Year", @"Fifth Year", @"Graduated", @"Doctoral", @"Faculty", @"Other"];
}

- (NSArray*)returnSpecificAnswers{
    return @[@"Loans", @"God's calling", @"Parents", @"Raising Support", @"Skills fit", @"Other", @"None"];
}

//simply populates data since it's more complicated now
- (NSArray*)returnLabelArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Freshman" checked:NO interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Sophomore" checked:NO interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Junior" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Senior" checked:NO interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

- (NSArray*)returnSurveyArray{
    
    MHFilterLabel *checkListLabel = [[MHFilterLabel alloc] initLabelWithName:@"What is your email address?" checked:NO interactionType:CRUCellViewInteractionCheckList];
    
    //optional description, show as section title on modal
    [checkListLabel setLabelDescriptionWithString:@"Select survey answers"];
    [checkListLabel setResultsWithKeyArray:self.returnSpecificAnswers resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO, @NO]];
    
    MHFilterLabel *checkListLabel2 = [[MHFilterLabel alloc] initLabelWithName:@"What is your year in school?" checked:NO interactionType:CRUCellViewInteractionPicker];
    
    //optional description, show as section title on modal
    [checkListLabel2 setLabelDescriptionWithString:@"Select survey answers"];
    [checkListLabel2 setResultsWithKeyArray:self.returnSurveyAnswers resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO]];
    
    MHFilterLabel *checkListLabel3 = [[MHFilterLabel alloc] initLabelWithName:@"What is your phone number?" checked:NO interactionType:CRUCellViewInteractionTextBox];
    
    [checkListLabel3 setLabelDescriptionWithString:@"Type keywords for survey answer here"];
    
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

#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section.
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:section];
    //There will at least be one because of the header
    NSUInteger numOfRows = (NSInteger) manager.numOfRows;
    manager = nil;
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //managerArray per section
   return [self.managerArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temp manager to get create and return cell
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
    //returnCellWithIndex handles the look of a header cell, modal cell (> indicator) and checktoggle
    UITableViewCell * cell = (UITableViewCell*)[manager returnCellWithIndex:indexPath tableView:tableView];
    manager = nil;
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
