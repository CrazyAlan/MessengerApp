//
//  FriendsView.h
//  MessengerApp
//
//  Created by Eric Schanet on 05.05.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectSingleView.h"
#import "SelectMultipleView.h"
#import "AddressBookView.h"
#import "FacebookFriendsView.h"

 @interface PeopleView : UITableViewController <UIActionSheetDelegate, SelectSingleDelegate, SelectMultipleDelegate, AddressBookDelegate, FacebookFriendsDelegate>
 
@end
