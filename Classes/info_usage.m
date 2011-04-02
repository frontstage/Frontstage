//
//  info_usage.m
//  audience
//
//  Created by Andy Liang on 3/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import "info_usage.h"
#import "ASIFormDataRequest.h"
#import "terms.h"

@implementation info_usage


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[segment setFrame:CGRectMake(56, 211, 207, 30)];
	
	super.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
																								   style:UIBarButtonItemStyleBordered
																								   target:self
																								   action:@selector(next)];
	[super.navigationItem.rightBarButtonItem release];
}


- (void) next {
	NSString *updateURL= [NSString stringWithFormat:@"http://www.cornellhci.org/frontstage-iOS/update_terms.php"];
	NSURL *reqURL = [NSURL URLWithString:updateURL];
	ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"] forKey:@"session_id"];
	[httprequest setPostValue:([segment selectedSegmentIndex]==0)?@"1":@"0" forKey:@"info_usage"];
	[httprequest setPostValue:@"some_secret" forKey:@"secret"];
	[httprequest startSynchronous];
	if ([[httprequest responseString] isEqualToString:@"OK"]) {
		terms *tv = [[terms alloc] initWithNibName:@"terms" bundle:nil];
		[self.navigationController pushViewController:tv animated:YES];
		[tv release];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    segment= nil;
}


- (void)dealloc {
    [super dealloc];
	[segment release];
	segment= nil;
}


@end
