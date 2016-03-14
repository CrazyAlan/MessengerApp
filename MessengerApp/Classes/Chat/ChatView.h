//
//  ChatView.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSQMessages.h"

 @interface ChatView : JSQMessagesViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>
 
- (id)initWith:(NSString *)groupId_;

@end
