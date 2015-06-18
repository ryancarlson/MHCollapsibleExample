//
//  FilterViewController.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.combinedFilters = [[NSMutableArray alloc] init];
    [self setHalfModalViewLook];
    //Notification is for half modals to orientate properly if device is rotated during the modal being shown
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    //The example of this controller just has one view controller added as a sub
    //subclasses may have other view controllers so this is a variable instead of hardcoded
    self.currentSubViewControllerIndex = 0;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma Set Modal and Manager Settings
//Can be overwritten or added onto since the objects exist on the class
//rather than in the method
//modalOverlay is initialized and viewOverlayAlpha is set
- (void)setHalfModalViewLook{
    
    self.viewOverlayAlpha = .4;
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
    else if ([sender.title isEqualToString: @"Save"] && !self.modalCurrentlyShown){
        
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
    else if([sender.title isEqualToString:@"Cancel"] && !self.modalCurrentlyShown){
        
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
    
    //so the modal will take up the entire screen properly
    [self.tableView setBounces:NO];
    self.tableView.scrollEnabled = NO;
    
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
            [pickerViewController.view addSubview:picker];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
            [self setSettingsForNavWithController:navigationController cgSize:self.view.bounds.size offSet:self.tableView.contentOffset];
            [self bringUpHalfModalWithController:navigationController cgSize:self.view.bounds.size offSet:self.tableView.contentOffset];
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
            [self setButtonsAndColorWithController:textAreaController bgColor:[UIColor whiteColor] cancel:cancel save:save clear:clear];
            
            [textAreaController.view addSubview:descriptionText];
            [textAreaController.view addSubview:textField];
            
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:textAreaController];
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            
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
- (void)setSettingsForNavWithController:(UINavigationController*)navigationController cgSize:(CGSize)size offSet:(CGPoint)offset{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    navigationController.toolbarHidden = YES;
    navigationController.view.frame = CGRectMake(0, offset.y+height, width, height/2);
}

//Creates a UILabel for the actual label selected since the modal could cover up that selection
//and the user doesn't have to remember which one they selected this way
- (UILabel*)createLabelWithSection:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    UILabel *descriptionText = [[UILabel alloc] initWithFrame:CGRectMake(width/10, height/8, width-width/5, height/20)];
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
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(width/10, height/6, width - width/5, height/20)];
    NSString *previousText = section.getTextForTextArea;
    
    if([previousText isEqualToString:@""] || previousText == nil){
        textField.placeholder = section.getPlaceHolderText;
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
- (void)bringUpHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size offSet:(CGPoint)offset{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    self.modalOverlay.alpha = 0;
    
    NSUInteger extendedHeight = height;
    NSUInteger yCoordinate = offset.y;
    
    self.modalOverlay.frame = CGRectMake(offset.x, offset.y, width, extendedHeight);

    [self.view addSubview:self.modalOverlay];
    [self addChildViewController:navigationController];
    [self.view addSubview:navigationController.view];
    [UIView animateWithDuration:.2 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        navigationController.view.frame = CGRectMake(0, yCoordinate+height/2, width, height/2);
        self.modalOverlay.alpha = self.viewOverlayAlpha;
    }completion:^(BOOL finished){
    }];
    [navigationController didMoveToParentViewController:self];
}

//Removes the "half modal"
- (void)removeHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size offSet:(CGPoint)offset{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    [UIView animateWithDuration:.2 delay: 0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        navigationController.view.frame = CGRectMake(offset.x, offset.y+height, width, height/2);
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
    
    [self.tableView setBounces:YES];
    self.tableView.scrollEnabled = YES;
    
    if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:NO];
    }
    
    [self.currentSection saveChanges];
    
    //since checklist type uses real modal
    if(self.currentModalType != CRUCellViewInteractionCheckList && self.currentModalType != CRUCellViewInteractionTextBox){
    
        //currentSubViewControllerIndex is set as 0 by default in viewDidLoad
        UINavigationController *navigationController = self.childViewControllers[self.currentSubViewControllerIndex];
        [self removeHalfModalWithController:navigationController cgSize:self.view.bounds.size offSet:self.tableView.contentOffset];
     
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
    
    [self.tableView setBounces:YES];
    self.tableView.scrollEnabled = YES;
    
    if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:NO];
    }
    
    [self.currentSection cancelChanges];
    
    //since checklist type is a true modal
    if(self.currentModalType != CRUCellViewInteractionCheckList && self.currentModalType != CRUCellViewInteractionTextBox){
    
        //currentSubViewControllerIndex is set as 0 by default in viewDidLoad
        UINavigationController *navigationController = self.childViewControllers[self.currentSubViewControllerIndex];
        [self removeHalfModalWithController:navigationController cgSize:self.view.frame.size offSet:self.tableView.contentOffset];

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
        
        //currentSubViewControllerIndex set as 0 by default in viewdidload
        UINavigationController *navigationController = (UINavigationController*)self.childViewControllers[self.currentSubViewControllerIndex];
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
    
    //currentSubViewControllerIndex set 0 default in viewdidload
    UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
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

//For the "half modal" the orientation could change while the modal is up
//This recreates the frames for the overlay and the navigation controller
//to make sure it will look proper
- (void)orientationChanged:(NSNotification *)notification{
    
    if(self.modalCurrentlyShown && self.currentModalType != CRUCellViewInteractionCheckList){
        
        UINavigationController *navigationController = self.childViewControllers[self.currentSubViewControllerIndex];
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        NSUInteger width = self.view.frame.size.width;
        NSUInteger height = self.view.frame.size.height;
        CGPoint offset = self.tableView.contentOffset;
        CGFloat rotation = 0;
        switch (orientation)
        {
            case UIDeviceOrientationPortraitUpsideDown:
                rotation = -M_PI;
                break;
            case UIDeviceOrientationLandscapeLeft:
                rotation = M_PI_2;
                break;
            case UIDeviceOrientationLandscapeRight:
                rotation = -M_PI_2;
            default:
                break;
        }
        
        navigationController.view.frame = CGRectMake(offset.x, offset.y+height/2, width, height/2);
        //just rotate modal since it doesn't have text or anything to fix
        [self.modalOverlay setTransform:CGAffineTransformMakeRotation(rotation)];
        //this is to fix the width/height of overlay after rotation
        self.modalOverlay.frame = CGRectMake(offset.x, offset.y, width, height);
    }
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

//If the filterview is subclassed, the MHTableViewCell can be returned instead
//and the defaults set for the look of the cell can be overwritten by the controller
//They will still be set by the manager as default but customization is still possible
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temp manager to get create and return cell
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
    //returnCellWithIndex handles the look of a header cell, modal cell (> indicator) and checktoggle
    //to customize look, a subclassed controller could get the MHTableViewCell instead of casting it
    //and then modify the defaults from there with setDefaults and setClicked
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
