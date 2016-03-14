//
//  NavigationController.m
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"Navigation Load");
    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.translucent = YES;}

@end
