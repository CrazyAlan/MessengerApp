//
//  AdressBookView.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Parse/Parse.h>

 @protocol AddressBookDelegate
 
- (void)didSelectAddressBookUser:(PFUser *)user;

@end

 @interface AddressBookView : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
 
@property (nonatomic, assign) IBOutlet id<AddressBookDelegate>delegate;

@end
