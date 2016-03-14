//
//  RecentCell.h
//  MessengerApp
//
//  Created by Eric Schanet on 05.05.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <Parse/Parse.h>

 @interface RecentCell : UITableViewCell
 
- (void)bindData:(PFObject *)recent_;

@end
