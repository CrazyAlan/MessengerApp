//
//  image.h
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

 UIImage*		SquareImage				(UIImage *image, CGFloat size);
UIImage*		ResizeImage				(UIImage *image, CGFloat width, CGFloat height);
UIImage*		CropImage				(UIImage *image, CGFloat x, CGFloat y, CGFloat width, CGFloat height);
