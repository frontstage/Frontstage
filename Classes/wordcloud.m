//
//  wordcloud.m
//  audience
//
//  Created by Andy Liang on 3/14/11.
//  Copyright 2011 None. All rights reserved.
//

#import "wordcloud.h"


#import "wordcloud.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"


@implementation wordcloud

@synthesize wordArray;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.text.length != 0) {
		[textField resignFirstResponder];
		[wordArray release];
		NSString *updateURL= [NSString stringWithFormat:@"http://www.cornellhci.org/frontstage-iOS/wordcloud_post_word.php"];
		NSURL *reqURL = [NSURL URLWithString:updateURL];
		ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
		[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
		[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"] forKey:@"session_id"];
		[httprequest setPostValue:word.text forKey:@"word"];
		[httprequest setPostValue:@"some_secret" forKey:@"secret"];
		[httprequest startSynchronous];
		NSData *response= [httprequest responseData];
		NSError *error;
		CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
		NSArray *resultsArray = [jsonDeserializer deserialize:response error:&error];
		
		wordArray = [[NSMutableArray alloc] initWithArray:resultsArray];
		[table reloadData];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[wordArray count]-1 inSection:0];
		[table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		word.text= @"";
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"You can not submit an empty string."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    return YES;
}

- (IBAction) dismissModal {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
	// populate table
	NSString *updateURL= [NSString stringWithFormat:@"http://www.cornellhci.org/frontstage-iOS/wordcloud_get_user_words.php"];
	NSURL *reqURL = [NSURL URLWithString:updateURL];
	ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"] forKey:@"session_id"];
	[httprequest setPostValue:@"some_secret" forKey:@"secret"];
	[httprequest startSynchronous];
	NSData *response= [httprequest responseData];
	NSError *error;
	CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	NSArray *resultsArray = [jsonDeserializer deserialize:response error:&error];
	NSLog(@"%@",[httprequest responseString]);
	wordArray = [[NSMutableArray alloc] initWithArray:resultsArray];
	[table reloadData];
	if ([wordArray count] >= 1) {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[wordArray count]-1 inSection:0];
	[table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < wordArray.count) {
		static NSString *cellIdentifier = @"wordCell";
		
		UITableViewCell *cell = (UITableViewCell *) [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			[cell autorelease];
		}
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		cell.textLabel.text = [[wordArray objectAtIndex:indexPath.row] objectForKey:@"word"];
		
		return cell;
	}
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [wordArray count];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
    if([string isEqualToString:@""]){
        return YES;
    }else if([[textField text] length] - range.length + string.length > 140){
		
        return NO;
    }
	
    return YES;
}

- (IBAction) dismissKeyboard {
	[word resignFirstResponder];
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
