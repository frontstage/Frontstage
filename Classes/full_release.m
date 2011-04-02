//
//  full_release.m
//  audience
//
//  Created by Andy Liang on 3/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import "full_release.h"


@implementation full_release

@synthesize delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
	NSString *line1= @"1. I have been informed and understand that Cornell Interaction Design Lab is making a video in which my name, likeness, image, and/or voice may be included.";
	NSString *line2= @"2. I hereby grant Cornell University, and its employees and agents, the right to make, use and publish in whole or in part any recorded footage in which my name, likeness, image and/or voice may be included (hereinafter \"Recordings\") whether recorded on or transferred to videotape, film, slides, photographs, audio tape, digital format, or other media now known or hereafter developed. This includes, without limitation, the right to edit, mix, duplicate, use or reuse Recordings as it may desire without restriction as to changes or alterations. Cornell University shall have complete ownership of the Recordings in which I or my performance or contribution appears.";
	NSString *line3= @"3. I also grant Cornell University the right to distribute, display, broadcast, exhibit, and market any of said Recordings, either alone or as part of its finished productions, for commercial or non-commercial purposes as Cornell or its employees and agents may determine. This includes the right to use said Recordings for promotion or publicizing any of these uses.";
	NSString *line4= @"4. I hereby waive any and all right that I may have to inspect or approve the finished product or printed matter that may be used in connection therewith.";
	NSString *line5= @"5. I expressly release Cornell University and all persons acting under its permission or authority from any claim or liability arising out of or in any way connected with the above uses and representations including any and all claims for defamation or copyright infringement.";
	textView.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@", line1, line2, line3, line4, line5];
	[textView setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
	[textView setEditable:NO];
	[self.view addSubview:textView];
	
	// navigation bar
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	navBar.barStyle= UIBarStyleBlackOpaque;
	[self.view addSubview:navBar];

	// set up the navigation item and done button
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								   target:self action:@selector(back)];
	UINavigationItem *navItem = [[UINavigationItem alloc]
										initWithTitle:@"Full Release"];
	navItem.rightBarButtonItem = buttonItem;
	[navBar pushNavigationItem:navItem animated:NO];
	[navItem release];
	[buttonItem release];
	[navBar release];
}


- (void) back {
	//NSLog(@"%@",self);
	[self.delegate full_releaseDidFinish];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
