//
//  SelectSingleView.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <Parse/Parse.h>

 @protocol SelectSingleDelegate
 
- (void)didSelectSingleUser:(PFUser *)user;

@end

 @interface SelectSingleView : UITableViewController <UISearchBarDelegate>
 
@property (nonatomic, assign) IBOutlet id<SelectSingleDelegate>delegate;

@end
