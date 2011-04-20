//
//  login.m
//  audience
//
//  Created by Andy Liang on 3/9/11.
//  Copyright 2011 None. All rights reserved.
//

#import "login.h"
#import "ASIFormDataRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
#import "info_usage.h"
#import "MainScreen.h"


@implementation login


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	// hide username and password input
	[username_text setHidden:YES]; [username setUserInteractionEnabled:NO]; [username setHidden:YES];
	[password_text setHidden:YES]; [password setUserInteractionEnabled:NO]; [password setHidden:YES];
	[go setHidden:YES]; [go setUserInteractionEnabled:NO];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if (textField == session_id) { // user submitted session ID, check database to see if it exists
		// post value
		NSString *updateURL= [NSString stringWithFormat:@"http://www.cornellhci.org/frontstage-iOS/check_session_id.php"];
		NSURL *reqURL = [NSURL URLWithString:updateURL];
		ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
		[httprequest setPostValue:session_id.text forKey:@"session_id"];
		[httprequest setPostValue:@"some_secret" forKey:@"secret"];
		[httprequest startSynchronous];
		CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
		NSError *error;
		NSArray *resultsArray = [jsonDeserializer deserialize:[httprequest responseData] error:&error];
		
		if (![[[httprequest responseString] substringToIndex:4] isEqualToString:@"ERROR"]) { // if return "OK", then sesssion exists
			// hide session_id input field
			[session_id setHidden:YES]; [session_id setUserInteractionEnabled:NO]; [session_id_text setHidden:YES];
			// show username and password input fields
			[username_text setHidden:NO]; [username setUserInteractionEnabled:YES]; [username setHidden:NO];
			[password_text setHidden:NO]; [password setUserInteractionEnabled:YES]; [password setHidden:NO];
			[go setHidden:NO]; [go setUserInteractionEnabled:YES];
			// store session id as user default for use later
			[[NSUserDefaults standardUserDefaults] setObject:session_id.text forKey:@"session_id"];
			// store enabled feature fields
			[[NSUserDefaults standardUserDefaults] setObject:[[resultsArray objectAtIndex:0] objectForKey:@"wordcloud"] forKey:@"wordcloud"];
			
		} else { // session does not exist or any other problem occurred, show alert
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"The session ID is invalid."
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	} else if (textField == username) { // user done editing username, go to password field
		[password becomeFirstResponder];
	} else { // user done editing password, dismiss keyboard
		[password resignFirstResponder];
	}
	return YES;
}

- (IBAction) loginTapped {
	// SHA1 hashing with salt appended
	NSString *hashkey = [NSString stringWithFormat:@"AYhG93b0qyJfIxfs2guVoUubWwvniR2G0FgaC9mi%@",password.text];
	// PHP uses ASCII encoding, not UTF
	const char *s = [hashkey cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
	
	// This is the destination
	uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	// This one function does an unkeyed SHA1 hash of your hash data
	CC_SHA1(keyData.bytes, keyData.length, digest);
	
	// Now convert to NSData structure to make it usable again
	NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	// description converts to hex but puts <> around it and spaces every 4 bytes
	NSString *hash = [out description];
	hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
	hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
	// hash is now a string with just the 40char hash value in it
	
	NSString *updateURL= [NSString stringWithFormat:@"http://www.cornellhci.org/frontstage-iOS/login.php"];
	NSURL *reqURL = [NSURL URLWithString:updateURL];
	ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
	[httprequest setPostValue:username.text forKey:@"username"];
	[httprequest setPostValue:hash forKey:@"password"];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"] forKey:@"session_id"];
	[httprequest setPostValue:@"some_secret" forKey:@"secret"];
	[httprequest startSynchronous];
	
	// response contains user_id, username, and terms
	NSData *response= [httprequest responseData];
	NSError *error;
	CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	NSArray *resultsArray = [jsonDeserializer deserialize:response error:&error];
	[[NSUserDefaults standardUserDefaults] setObject:[[resultsArray objectAtIndex:0] objectForKey:@"user_id"] forKey:@"user_id"];
	[[NSUserDefaults standardUserDefaults] setObject:[[resultsArray objectAtIndex:0] objectForKey:@"username"] forKey:@"username"];

	if ([[[resultsArray objectAtIndex:0] objectForKey:@"terms"] isEqualToString:@"0"]) { // user has not agreed to the terms
		// display terms modal view
		info_usage *info = [[info_usage alloc] initWithNibName:@"info_usage" bundle:nil];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:info];
		[nav.navigationBar setBarStyle:UIBarStyleBlackOpaque];
		[info setTitle:@"Terms"];
		[self presentModalViewController:nav animated:YES];
		[nav release];
		[info release];
		
	} else { // user has already agreed to the terms
		// go to main view with features
		MainScreen *ms = [[MainScreen alloc] initWithNibName:@"MainScreen" bundle:nil];
		ms.features = [[NSMutableArray alloc] initWithObjects:@"wordcloud",@"clicker",nil];
		[ms setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		[self presentModalViewController:ms animated:YES];
		[ms release];
		
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	username_text= nil;
	password_text= nil;
	session_id_text= nil;
	username= nil;
	password= nil;
	session_id= nil;
	go= nil;
}


- (void)dealloc {
	[username_text release];
	[password_text release];
	[session_id_text release];
	[username release];
	[password release];
	[session_id release];
	[go release];
	username_text= nil;
	password_text= nil;
	session_id_text= nil;
	username= nil;
	password= nil;
	session_id= nil;
	go= nil;
    [super dealloc];	
}


@end
