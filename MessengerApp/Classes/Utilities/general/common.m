//
//  common.m
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import "common.h"
#import "WelcomeView.h"
#import "NavigationController.h"

 void LoginUser(id target)
 {
	NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[WelcomeView alloc] init]];
	[target presentViewController:navigationController animated:YES completion:nil];
}

 void PostNotification(NSString *notification)
 {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}
