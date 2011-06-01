//
//  MainScreen.m
//  audience
//
//  Created by Andy Liang on 3/14/11.
//  Copyright 2011 None. All rights reserved.
//

#import "MainScreen.h"
#import "wordcloud.h"
#import "SelectPhoto.h"


@implementation MainScreen

@synthesize features;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [features count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < features.count) {
		static NSString *cellIdentifier = @"featureCell";
		
		UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			[cell autorelease];
		}
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		cell.textLabel.text = [features objectAtIndex:indexPath.row];
		
		return cell;
	}
}	

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[features objectAtIndex:indexPath.row] isEqualToString:@"wordcloud"]) {
		wordcloud *wc = [[wordcloud alloc] initWithNibName:@"wordcloud" bundle:nil];
		[wc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[self presentModalViewController:wc animated:YES];
		[wc release];
	} else if ([[features objectAtIndex:indexPath.row] isEqualToString:@"photopicker"]) {
        SelectPhoto *sp = [[SelectPhoto alloc] initWithNibName:@"SelectPhoto" bundle:nil];
        [sp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:sp animated:YES];
        [sp release];
        
    }
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
	self.features = nil;
}


- (void)dealloc {
    [super dealloc];
	[features release]; features = nil;
}


@end
