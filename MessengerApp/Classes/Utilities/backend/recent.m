//
//  recent.m
//  MessengerApp
//
//  Created by Eric Schanet on 05.05.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <Parse/Parse.h>

#import "AppConstant.h"

#import "recent.h"

 NSString* StartPrivateChat(PFUser *user1, PFUser *user2)
 {
	NSString *id1 = user1.objectId;
	NSString *id2 = user2.objectId;
 	NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
 	CreateRecentItem(user1, groupId, user2[PF_USER_FULLNAME]);
	CreateRecentItem(user2, groupId, user1[PF_USER_FULLNAME]);
 	return groupId;
}

 NSString* StartMultipleChat(NSMutableArray *users)
 {
	NSString *groupId = @"";
	NSString *description = @"";
 	[users addObject:[PFUser currentUser]];
 	NSMutableArray *userIds = [[NSMutableArray alloc] init];
 	for (PFUser *user in users)
	{
		[userIds addObject:user.objectId];
	}
 	NSArray *sorted = [userIds sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
 	for (NSString *userId in sorted)
	{
		groupId = [groupId stringByAppendingString:userId];
	}
 	for (PFUser *user in users)
	{
		if ([description length] != 0) description = [description stringByAppendingString:@" & "];
		description = [description stringByAppendingString:user[PF_USER_FULLNAME]];
	}
 	for (PFUser *user in users)
	{
		CreateRecentItem(user, groupId, description);
	}
 	return groupId;
}

 void CreateRecentItem(PFUser *user, NSString *groupId, NSString *description)
 {
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_USER equalTo:user];
	[query whereKey:PF_RECENT_GROUPID equalTo:groupId];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			if ([objects count] == 0)
			{
				PFObject *recent = [PFObject objectWithClassName:PF_RECENT_CLASS_NAME];
				recent[PF_RECENT_USER] = user;
				recent[PF_RECENT_GROUPID] = groupId;
				recent[PF_RECENT_DESCRIPTION] = description;
				recent[PF_RECENT_LASTUSER] = [PFUser currentUser];
				recent[PF_RECENT_LASTMESSAGE] = @"";
				recent[PF_RECENT_COUNTER] = @0;
				recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
				[recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"CreateRecentItem save error.");
				}];
			}
		}
		else NSLog(@"CreateRecentItem query error.");
	}];
}

 void UpdateRecentCounter(NSString *groupId, NSInteger amount, NSString *lastMessage)
 {
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_GROUPID equalTo:groupId];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *recent in objects)
			{
				PFUser *user = recent[PF_RECENT_USER];
				if ([user.objectId isEqualToString:[PFUser currentUser].objectId] == NO)
					[recent incrementKey:PF_RECENT_COUNTER byAmount:[NSNumber numberWithInteger:amount]];
				//---------------------------------------------------------------------------------------------------------------------------------
				recent[PF_RECENT_LASTUSER] = [PFUser currentUser];
				recent[PF_RECENT_LASTMESSAGE] = lastMessage;
				recent[PF_RECENT_UPDATEDACTION] = [NSDate date];
				[recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"UpdateRecentCounter save error.");
				}];
			}
		}
		else NSLog(@"UpdateRecentCounter query error.");
	}];
}

 void ClearRecentCounter(NSString *groupId)
 {
	PFQuery *query = [PFQuery queryWithClassName:PF_RECENT_CLASS_NAME];
	[query whereKey:PF_RECENT_GROUPID equalTo:groupId];
	[query whereKey:PF_RECENT_USER equalTo:[PFUser currentUser]];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *recent in objects)
			{
				recent[PF_RECENT_COUNTER] = @0;
				[recent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"ClearRecentCounter save error.");
				}];
			}
		}
		else NSLog(@"ClearRecentCounter query error.");
	}];
}