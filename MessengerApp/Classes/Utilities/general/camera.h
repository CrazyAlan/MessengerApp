//
//  camera.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

 BOOL			PresentPhotoCamera		(id target, BOOL canEdit);
BOOL			PresentVideoCamera		(id target, BOOL canEdit);
BOOL			PresentMultiCamera		(id target, BOOL canEdit);

 BOOL			PresentPhotoLibrary		(id target, BOOL canEdit);
BOOL			PresentVideoLibrary		(id target, BOOL canEdit);
