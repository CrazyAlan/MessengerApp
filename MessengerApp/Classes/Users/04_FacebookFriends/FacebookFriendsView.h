//
//  FacebookFriendsView.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <Parse/Parse.h>

 @protocol FacebookFriendsDelegate
 
- (void)didSelectFacebookUser:(PFUser *)user;

@end

 @interface FacebookFriendsView : UITableViewController <UISearchBarDelegate>
 
@property (nonatomic, assign) IBOutlet id<FacebookFriendsDelegate>delegate;

@end
