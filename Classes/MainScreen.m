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
#import "cameraModule.h"
#import "voiceRecordModule.h"


@implementation MainScreen

@synthesize features;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //[features addObject:@"camera"];
    //[features addObject:@"voicerecord"];
}
-(void)viewWillAppear:(BOOL)animated{
    [table reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [features count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"featureCell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.row < features.count) {
		
		if (cell == nil) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			[cell autorelease];
		}
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		cell.textLabel.text = [features objectAtIndex:indexPath.row];
		
	}
    return cell;
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
        
    } else if ([[features objectAtIndex:indexPath.row] isEqualToString:@"camera"]){
        cameraModule *c = [[cameraModule alloc]initWithNibName:@"cameraModule" bundle:nil];
        [c setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:c animated:YES];
        [c release];
    }else if([[features objectAtIndex:indexPath.row] isEqualToString:@"voicerecord"]){
        voiceRecordModule *v = [[voiceRecordModule alloc]initWithNibName:@"voiceRecordModule" bundle:nil];
        [v setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentModalViewController:v animated:YES];
        [v release];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    
    //WHICH IS BAD FOR NOW!!
    
    //[super didReceiveMemoryWarning];
    
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
