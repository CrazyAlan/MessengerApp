//
//  SelectMultipleView.m
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "common.h"

#import "SelectMultipleView.h"

 @interface SelectMultipleView()
{
	NSMutableArray *users;
	NSMutableArray *selection;
}
@end
 
@implementation SelectMultipleView

@synthesize delegate;

 - (void)viewDidLoad
 {
	[super viewDidLoad];
	self.title = @"Select Multiple";
 	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
																						  action:@selector(actionCancel)];
 	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
																						   action:@selector(actionDone)];
 	users = [[NSMutableArray alloc] init];
	selection = [[NSMutableArray alloc] init];
 	[self loadUsers];
}

#pragma mark - Backend actions

 - (void)loadUsers
 {
	PFUser *user = [PFUser currentUser];

	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID notEqualTo:user.objectId];
	[query orderByAscending:PF_USER_FULLNAME];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			[users removeAllObjects];
			[users addObjectsFromArray:objects];
			[self.tableView reloadData];
		}
		else [ProgressHUD showError:@"Network error."];
	}];
}

#pragma mark - User actions

 - (void)actionCancel
 {
	[self dismissViewControllerAnimated:YES completion:nil];
}

 - (void)actionDone
 {
	if ([selection count] == 0) { [ProgressHUD showError:@"Please select some users."]; return; }
 	[self dismissViewControllerAnimated:YES completion:^{
		if (delegate != nil)
		{
			NSMutableArray *selectedUsers = [[NSMutableArray alloc] init];
			for (PFUser *user in users)
			{
				if ([selection containsObject:user.objectId])
					[selectedUsers addObject:user];
			}
			[delegate didSelectMultipleUsers:selectedUsers];
		}
	}];
}

#pragma mark - Table view data source

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
	return 1;
}

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
	return [users count];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

	PFUser *user = users[indexPath.row];
	cell.textLabel.text = user[PF_USER_FULLNAME];

	BOOL selected = [selection containsObject:user.objectId];
	cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

	return cell;
}

#pragma mark - Table view delegate

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
 	PFUser *user = users[indexPath.row];
	BOOL selected = [selection containsObject:user.objectId];
	if (selected) [selection removeObject:user.objectId]; else [selection addObject:user.objectId];
 	[self.tableView reloadData];
}

@end
