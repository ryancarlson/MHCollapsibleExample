//
//  ExampleSubclassFilterViewController.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 6/12/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "ExampleSubclassFilterViewController.h"

@interface ExampleSubclassFilterViewController ()

- (NSArray*)returnLabelArray;
- (NSArray*)returnInteractionsArray;
- (NSArray*)returnAssignedToArray;
- (NSArray*)returnGuestbookArray;
- (NSArray*)returnEngelsScaleArray;
- (NSArray*)returnInternationalStudentsArray;

@end

@implementation ExampleSubclassFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createManagersAndPopulateData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createManagersAndPopulateData{
    
    MHCollapsibleViewManager *labels = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Labels" tableView:self.tableView];
    
    [labels setFilterArraysWithFirstArrayAsHeaderTitles:@[@"Labels"], self.returnLabelArray, nil];
    //sends double array for filternames and single array for header lines
    //[labels setDataWithFilterNames:self.returnLabelArray headerTitles:@[@"Labels"]];
    
    MHCollapsibleViewManager *surveys = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Surveys" tableView:self.tableView];
    
    NSArray *surveyQuestions = @[self.returnGuestbookArray, self.returnEngelsScaleArray, self.returnInternationalStudentsArray];
    NSArray *surveyList = @[@"Bridges@UCF Guestbook", @"Engels Scale", @"International Students"];
    [surveys setFilterArraysWithFirstArrayAsHeaderTitles:surveyList, self.returnGuestbookArray, self.returnEngelsScaleArray, self.returnInternationalStudentsArray, nil];
    surveyList = nil;
    surveyQuestions = nil;
    
    MHCollapsibleViewManager *interactions = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle topHierarchyTitle:@"Interactions" tableView:self.tableView];
    //Index 0 is title
    [interactions setFilterArraysWithFirstArrayAsHeaderTitles:@[@"Interactions"], self.returnInteractionsArray, nil];
    //[interactions setDataWithFilterNames:@[self.returnInteractionsArray] headerTitles:@[@"Interactions"]];
    
    //do not do plural, just singleton
    //this identifies uniquely what the filters are
    [labels setTextIdentifierAndIndexWithSingleIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_label_single", @"Localizable", nil)
                                         pluralIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_label_plural", @"Localizable", nil) managerIndex:0];
    [surveys setTextIdentifierAndIndexWithSingleIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_question_single", @"Localizable", nil)
                                          pluralIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_question_plural", @"Localizable", nil)
                                              managerIndex:1];
    [surveys setTextIdentifierForManagerWithSingleIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_single", @"Localizable", nil)
                                            pluralIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_plural", @"Localizable", nil)];
    [interactions setTextIdentifierAndIndexWithSingleIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_interaction_single", @"Localizable", nil)
                                               pluralIdentifier: NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_interaction_plural", @"Localizable", nil) managerIndex:2];
    
    //ManagerArray stores each controller or manager
    labels.delegate = self;
    surveys.delegate = self;
    interactions.delegate = self;
    self.managerArray = [NSMutableArray arrayWithObjects:labels, surveys, interactions, nil];
    
    surveys = nil;
    labels = nil;
}

//simply populates data since it's more complicated now
- (NSArray*)returnLabelArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Involved" checked:NO interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Engaged Disciple" checked:NO interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Leader" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Seeker" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"2011 New" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"2012 New" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"2013 New" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"2014 New" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"2015 New" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"6x6 Challenge" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Aubreys friends" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Bridges Ambassadors" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Bridges Friend" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Bridges Logistics" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Bridges Staff" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Chinese Min Laborer" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"COA Min Laborer" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Friendship Partner" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Multi-Nations Min Laborer" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"New/Growing Disciples" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"SAN Min Laborer" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Thanksgiving volunteer" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"vision 2014" checked:NO interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}


- (NSArray*)returnInternationalStudentsArray{
    
    NSArray *filterData;
    NSString *placeHolderText =  NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_placeHolder", @"Localizable", nil);
    
    MHFilterLabel *checkListLabel = [[MHFilterLabel alloc] initLabelWithName:@"English Name" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel2 = [[MHFilterLabel alloc] initLabelWithName:@"姓名（汉字)" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel2 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel3 = [[MHFilterLabel alloc] initLabelWithName:@"Spiritual Status" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel3 setResultsWithKeyArray:@[@"Unknown", @"Non-believer, uninterested", @"Non-believer, seeking", @"Believer, new/needs follow-up", @"Believer, established/growing", @"Believer, ministering", @"Believer, multiplying", @"No Response"] resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO]];
    MHFilterLabel *checkListLabel4 = [[MHFilterLabel alloc] initLabelWithName:@"Martial Status" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel4 setResultsWithKeyArray:@[@"Single", @"Married", @"Divorced", @"No Response"] resultValues:@[@NO, @NO, @NO, @NO]];
    MHFilterLabel *checkListLabel5 = [[MHFilterLabel alloc] initLabelWithName:@"Spouse" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel5 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel6 = [[MHFilterLabel alloc] initLabelWithName:@"Children" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel6 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel7 = [[MHFilterLabel alloc] initLabelWithName:@"Hometown/Province" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel7 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel8 = [[MHFilterLabel alloc] initLabelWithName:@"University in Home Country" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel8 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel9 = [[MHFilterLabel alloc] initLabelWithName:@"Major/Field of Study" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel9 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel10 = [[MHFilterLabel alloc] initLabelWithName:@"Church" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel10 setResultsWithKeyArray:@[@"中华教会 OCC (Bumby/Rouse)", @"福音教会 OCECC", @"灵粮堂 Bread of Life (Red Bug)", @"台福教会 Dr. Wu's", @"基石教会 Living Stone", @"Other", @"None", @"No Response"] resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO]];
    MHFilterLabel *checkListLabel11 = [[MHFilterLabel alloc] initLabelWithName:@"Church(if other)" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel11 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel12 = [[MHFilterLabel alloc] initLabelWithName:@"Date of Arrival in Orlando" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel12 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel13 = [[MHFilterLabel alloc] initLabelWithName:@"Date of Departure in Orlando" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel13 setPlaceHolderTextWithString:placeHolderText];
    MHFilterLabel *checkListLabel14 = [[MHFilterLabel alloc] initLabelWithName:@"Notes" checked:NO interactionType:CRUCellViewInteractionTextBox];
    filterData = @[checkListLabel, checkListLabel2, checkListLabel3, checkListLabel4, checkListLabel5, checkListLabel6, checkListLabel7, checkListLabel8, checkListLabel9, checkListLabel10,
                   checkListLabel11, checkListLabel12, checkListLabel13, checkListLabel14];
    return filterData;
}

- (NSArray*)returnEngelsScaleArray{
    
    NSArray *filterData;
    MHFilterLabel *checkListLabel1 = [[MHFilterLabel alloc] initLabelWithName:@"Engel's Scale" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel1 setResultsWithKeyArray:@[@"don't know", @"-8 - no effective knowldge of Christianity", @"-7 - initial awareness of Christianity", @"-6 - interest in Christianity", @"-5 - aware of basic facts of the gospel", @"-4 - positive attitude toward the gospel", @"-3 - awareness of personal need", @"-2 - challenge and decision to act", @"-1 -repentance of faith", @"0 - CONVERSION", @"+1 new Christian", @"+2 - growing disciple", @"+3 - ministering disciple", @"+4 - multiplying disciple", @"No Response"] resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO]];
    filterData = @[checkListLabel1];
    return filterData;
}

- (NSArray*)returnGuestbookArray{
    
    NSString *placeHolderText =  NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_placeHolder", @"Localizable", nil);
    
    MHFilterLabel *checkListLabel = [[MHFilterLabel alloc] initLabelWithName:@"What is your email address?" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel setPlaceHolderTextWithString:placeHolderText];
    
    MHFilterLabel *checkListLabel2 = [[MHFilterLabel alloc] initLabelWithName:@"What is your gender?" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel2 setResultsWithKeyArray:@[@"Female", @"Male", @"No Response"] resultValues:@[@NO, @NO, @NO]];
    
    MHFilterLabel *checkListLabel3 = [[MHFilterLabel alloc] initLabelWithName:@"What is your home country?" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel3 setPlaceHolderTextWithString:placeHolderText];
    
    MHFilterLabel *checkListLabel4 = [[MHFilterLabel alloc] initLabelWithName:@"What is your home country?" checked:NO interactionType:CRUCellViewInteractionTextBox];
    [checkListLabel4 setPlaceHolderTextWithString:placeHolderText];
    
    MHFilterLabel *checkListLabel5 = [[MHFilterLabel alloc] initLabelWithName:@"How long have you been in America?" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel5 setResultsWithKeyArray:@[@"Less than 1 month", @"1-3 months", @"4-12 months", @"1-2 years", @"2+ years", @"No Response"] resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO]];
    
    MHFilterLabel *checkListLabel6 = [[MHFilterLabel alloc] initLabelWithName:@"Would you like to receive email updates from Bridges@UCF about fun and social events?" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel6 setResultsWithKeyArray:@[@"Yes", @"No", @"No Response"] resultValues:@[@NO, @NO, @NO]];
    
    MHFilterLabel *checkListLabel7 = [[MHFilterLabel alloc] initLabelWithName:@"Would you like to be matched with an American friend to practice English or get to know American culture?" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel7 setResultsWithKeyArray:@[@"Yes", @"No", @"No Response"] resultValues:@[@NO, @NO, @NO]];
    
    MHFilterLabel *checkListLabel8 = [[MHFilterLabel alloc] initLabelWithName:@"Would you like to find out more about the Bible and Jesus Christ?" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [checkListLabel8 setResultsWithKeyArray:@[@"Yes", @"No", @"No Response"] resultValues:@[@NO, @NO, @NO]];
    
    NSArray* filterData = @[checkListLabel,checkListLabel2, checkListLabel3, checkListLabel4, checkListLabel5, checkListLabel6, checkListLabel7, checkListLabel8];
    checkListLabel = nil;
    checkListLabel2 = nil;
    checkListLabel3 = nil;
    checkListLabel4 = nil;
    checkListLabel5 = nil;
    checkListLabel6 = nil;
    checkListLabel7 = nil;
    checkListLabel8 = nil;
    return filterData;
}
- (NSArray*)returnAssignedToArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Jan" checked:NO interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Sue" checked:NO interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Andy" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Peggy" checked:NO interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

- (NSArray*)returnInteractionsArray{
    
    NSArray* filterData = @[[[MHFilterLabel alloc] initLabelWithName:@"Comment Only" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Spiritual Conversation" checked:NO interactionType:CRUCellViewInteractionCheckToggle],[[MHFilterLabel alloc] initLabelWithName:@"Personal Evangelism" checked:NO interactionType:CRUCellViewInteractionCheckToggle] , [[MHFilterLabel alloc] initLabelWithName:@"Personal Evangelism Decisions" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Holy Spirit Presentation" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Graduating on a Mission" checked:NO interactionType:CRUCellViewInteractionCheckToggle], [[MHFilterLabel alloc] initLabelWithName:@"Faculty on Mission" checked:NO interactionType:CRUCellViewInteractionCheckToggle]];
    return filterData;
}

- (void)buttonTapped:(UIBarButtonItem *)sender{
    
    [super buttonTapped:sender];
    
    if(!self.modalCurrentlyShown && [sender.title isEqualToString:@"Save"]){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
