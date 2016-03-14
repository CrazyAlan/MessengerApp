//
//  push.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <Parse/Parse.h>

 void			ParsePushUserAssign		(void);
void			ParsePushUserResign		(void);

 void			SendPushNotification	(NSString *groupId, NSString *text);
