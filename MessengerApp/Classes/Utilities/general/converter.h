//
//  converter.h
//  MessengerApp
//
//  Created by Eric Schanet on 05.05.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

 NSString*		Date2String				(NSDate *date);
NSDate*			String2Date				(NSString *dateStr);

 NSString*		TimeElapsed				(NSTimeInterval seconds);
