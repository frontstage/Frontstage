//
//  terms.m
//  audience
//
//  Created by Andy Liang on 3/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import "terms.h"
#import "full_release.h"
#import "ASIFormDataRequest.h"
#import "MainScreen.h"

@implementation terms

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Terms"];
	super.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(submit)];
	[super.navigationItem.rightBarButtonItem release];
    
    // populate date with device date
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [date setText:dateString];
    
    
}

- (IBAction) toRelease {
	full_release *fullrelease = [[full_release alloc] init];
	fullrelease.delegate= self;
	[self presentModalViewController:fullrelease animated:YES];
	[fullrelease release];
}

- (void) full_releaseDidFinish {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) submit {
	NSString *updateURL= [NSString stringWithFormat:@"http://www.cornellhci.org/frontstage-iOS/update_terms.php"];
	NSURL *reqURL = [NSURL URLWithString:updateURL];
	ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"] forKey:@"session_id"];
	[httprequest setPostValue:([photo_record selectedSegmentIndex]==0)?@"1":@"0" forKey:@"photo_record"];
	[httprequest setPostValue:([over18_verify selectedSegmentIndex]==0)?@"1":@"0" forKey:@"over18_verify"];
	[httprequest setPostValue:name.text forKey:@"name"];
	[httprequest setPostValue:date.text forKey:@"date"];
	[httprequest setPostValue:email.text forKey:@"email"];
	[httprequest setPostValue:@"some_secret" forKey:@"secret"];
	[httprequest startSynchronous];
	if ([[httprequest responseString] isEqualToString:@"OK"]) {
		// go to main view with features
		//[self dismissModalViewControllerAnimated:YES];
		MainScreen *ms = [[MainScreen alloc] initWithNibName:@"MainScreen" bundle:nil];
        NSMutableArray *features= [[[NSMutableArray alloc] init] autorelease];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"wordcloud"] isEqualToString:@"1"]) {
            [features addObject:@"wordcloud"];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"clicker"] isEqualToString:@"1"]) {
            [features addObject:@"clicker"];
        }
        
		ms.features = features;
		[ms setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		[self presentModalViewController:ms animated:YES];
		[ms release];
		
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	
	animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if (textField == name) {
		[email becomeFirstResponder];
	} else if (textField == date) {
		[email becomeFirstResponder];
	} else {
		[email resignFirstResponder];
	}
	return YES;
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
