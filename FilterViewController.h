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

//Checked for Clear button since it appears on modals as well
@property (nonatomic) BOOL modalCurrentlyShown;

//Modal interaction methods
- (IBAction)buttonTapped:(UIBarButtonItem*)sender; //modals and this viewcontroller call

@end
