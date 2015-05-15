//
//  ContactTableViewController.h
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UIKit;

@interface ContactTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong,nonatomic) NSArray *contactArray;
@property (strong,nonatomic) NSMutableArray *filteredContactsArray;
@property IBOutlet UISearchBar *contactSearchBar;
@property (strong, nonatomic) UISearchController *searchController;

@end
