//
//  ContactTableViewController.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "ContactTableViewController.h"
#import "Contact.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

@synthesize contactArray;
@synthesize filteredContactsArray;
@synthesize contactSearchBar;
@synthesize searchController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar sizeToFit];
    
    contactArray = [NSArray arrayWithObjects:
                    [Contact constructContact:@"Freshman" name:@"Joe" assignedTo:@"John"],
                  [Contact constructContact:@"Freshman" name:@"Susan" assignedTo:@"John"],
                  [Contact constructContact:@"Freshman" name:@"Jake" assignedTo:@"Jordan"],
                  [Contact constructContact:@"Sophomore" name:@"Chloe Ann" assignedTo:@"Jordan"],
                  [Contact constructContact:@"Junior" name:@"Micah" assignedTo:@"Jordan"],
                  [Contact constructContact:@"Junior" name:@"Michelle" assignedTo:@"John"],
                  [Contact constructContact:@"Senior" name:@"Janet" assignedTo:@"John"],
                  [Contact constructContact:@"Senior" name:@"Joshua" assignedTo:@"Jordan"],
                  [Contact constructContact:@"Senior" name:@"Tracy" assignedTo:@"Jordan"],
                  [Contact constructContact:@"Senior" name:@"Mike" assignedTo:@"Jordan"], nil];
    
    self.filteredContactsArray = [NSMutableArray arrayWithCapacity:[contactArray count]];
    
    // Reload the table
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchController.view) {
        return [filteredContactsArray count];
    } else {
        return [contactArray count];
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:
     [[searchController.searchBar scopeButtonTitles] objectAtIndex:[searchController.searchBar selectedScopeButtonIndex]]];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Create a new Candy Object
    Contact *contact = nil;
    if (tableView == self.searchController.view) {
        contact = [filteredContactsArray objectAtIndex:indexPath.row];
    } else {
        contact = [contactArray objectAtIndex:indexPath.row];
    }
    // Configure the cell
    cell.textLabel.text = contact.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredContactsArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    filteredContactsArray = [NSMutableArray arrayWithArray:[contactArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end
