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
@property IBOutlet UIButton *clearButton;

@end
