//
//  WelcomeView.m
//  MessengerApp
//
//  Created by Eric Schanet on 15.04.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import "AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "image.h"
#import "push.h"

#import "WelcomeView.h"
#import "LoginView.h"
#import "RegisterView.h"

@implementation WelcomeView


- (void)viewDidLoad

{
	[super viewDidLoad];
	self.title = @"Messenger";
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
    logo.frame = CGRectMake(80, 100, [UIScreen mainScreen].bounds.size.width - 160, [UIScreen mainScreen].bounds.size.width - 160);
    [self.view addSubview:logo];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:backButton];
}

#pragma mark - User actions


- (IBAction)actionRegister:(id)sender

{
	RegisterView *registerView = [[RegisterView alloc] init];
	[self.navigationController pushViewController:registerView animated:YES];
}


- (IBAction)actionLogin:(id)sender

{
	LoginView *loginView = [[LoginView alloc] init];
	[self.navigationController pushViewController:loginView animated:YES];
}

#pragma mark - Facebook login methods


- (IBAction)actionFacebook:(id)sender

{
	[ProgressHUD show:@"Signing in..." Interaction:NO];
	[PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error)
	{
		if (user != nil)
		{
			if (user[PF_USER_FACEBOOKID] == nil)
			{
				[self requestFacebook:user];
			}
			else [self userLoggedIn:user];
		}
		else [ProgressHUD showError:error.userInfo[@"error"]];
	}];
}


- (void)requestFacebook:(PFUser *)user

{
	FBRequest *request = [FBRequest requestForMe];
	[request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
	{
		if (error == nil)
		{
			NSDictionary *userData = (NSDictionary *)result;
			[self processFacebook:user UserData:userData];
		}
		else
		{
			[PFUser logOut];
			[ProgressHUD showError:@"Failed to fetch Facebook user data."];
		}
	}];
}


- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData

{
	NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFImageResponseSerializer serializer];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		UIImage *image = (UIImage *)responseObject;
		//-----------------------------------------------------------------------------------------------------------------------------------------
		UIImage *picture = ResizeImage(image, 280, 280);
		UIImage *thumbnail = ResizeImage(image, 60, 60);
		//-----------------------------------------------------------------------------------------------------------------------------------------
		PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
		[filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error != nil) [ProgressHUD showError:@"Network error."];
		}];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(thumbnail, 0.6)];
		[fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error != nil) [ProgressHUD showError:@"Network error."];
		}];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		user[PF_USER_EMAILCOPY] = userData[@"email"];
		user[PF_USER_FULLNAME] = userData[@"name"];
		user[PF_USER_FULLNAME_LOWER] = [userData[@"name"] lowercaseString];
		user[PF_USER_FACEBOOKID] = userData[@"id"];
		user[PF_USER_PICTURE] = filePicture;
		user[PF_USER_THUMBNAIL] = fileThumbnail;
		[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		{
			if (error == nil)
			{
				[self userLoggedIn:user];
			}
			else
			{
				[PFUser logOut];
				[ProgressHUD showError:error.userInfo[@"error"]];
			}
		}];
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		[PFUser logOut];
		[ProgressHUD showError:@"Failed to fetch Facebook profile picture."];
	}];
	
	[[NSOperationQueue mainQueue] addOperation:operation];
}


- (void)userLoggedIn:(PFUser *)user

{
	ParsePushUserAssign();
	[ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back %@!", user[PF_USER_FULLNAME]]];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
