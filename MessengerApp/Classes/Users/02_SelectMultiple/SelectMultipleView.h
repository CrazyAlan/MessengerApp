//
//  SelectMultipleView.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

 @protocol SelectMultipleDelegate
 
- (void)didSelectMultipleUsers:(NSMutableArray *)users;

@end

 @interface SelectMultipleView : UITableViewController
 
@property (nonatomic, assign) IBOutlet id<SelectMultipleDelegate>delegate;

@end
