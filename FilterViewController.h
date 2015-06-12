//
//  FilterViewController.h
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCollapsibleViewManager.h"

@interface FilterViewController : UITableViewController<MHCollapibleViewManagerDelegate>

@property (strong, nonatomic) NSMutableArray *managerArray;
//used for picker and textfield type modals
//since they only take up half a page anyway
@property (strong, nonatomic) UIView *modalOverlay;
@property (nonatomic) CGFloat viewOverlayAlpha;
//Keeping track of the current section gives the ability to get data
//and invoke actions from the filterviewcontroller
@property (strong, nonatomic) MHCollapsibleSection *currentSection;
@property (nonatomic) CRUCellViewInteractionType currentModalType;
@property (nonatomic) NSIndexPath *currentRowPath;
@property (nonatomic) NSUInteger currentSubViewControllerIndex;
//Checked for Clear button since it appears on modals as well
@property (nonatomic) BOOL modalCurrentlyShown;
//After save button, this array is populated with MHPakcgaedFilter records
//returned by each MHCollapsibleViewManager
@property (nonatomic, strong) NSMutableArray *combinedFilters;


//Initial methods called in viewDidLoad
- (void)setHalfModalViewLook;
- (void)createManagersAndPopulateData;

//Modal interaction methods
- (void)createModalWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection *)section rowPath:(NSIndexPath *)rowPath;
- (void)bringUpHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size offSet:(CGPoint)offset;
- (void)removeHalfModalWithController:(UINavigationController*)navigationController cgSize:(CGSize)size offSet:(CGPoint)offset;
- (void)resignFirstResponderWithClearOption:(BOOL)clear;
- (IBAction)buttonTapped:(UIBarButtonItem*)sender; //modals and this viewcontroller call

//Modal settings
- (void)setButtonsAndColorWithController:(UIViewController*)viewController bgColor:(UIColor*)bgColor
                                  cancel:(UIBarButtonItem*)cancel save:(UIBarButtonItem*)save clear:(UIBarButtonItem*)clear;
- (void)setSettingsForNavWithController:(UINavigationController*)navigationController cgSize:(CGSize)size offSet:(CGPoint)offset;

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

@end
