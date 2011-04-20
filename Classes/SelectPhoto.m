//
//  SelectPhoto.m
//  frontstage
//
//  Created by andy on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectPhoto.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "PAMCell.h"
#import "ASINetworkQueue.h"


@implementation SelectPhoto

@synthesize dataArray;


- (void) viewDidAppear:(BOOL)animated {
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	
	if (NULL != [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]) {
		NSString *updateURL= [NSString stringWithFormat:@"http://api.cornellhci.org/pam/grids/instance.php"];
		NSURL *reqURL = [NSURL URLWithString:updateURL];
		ASIHTTPRequest *httprequest = [ASIHTTPRequest requestWithURL:reqURL];
		[httprequest setDelegate:self];
		[httprequest startAsynchronous];
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSData *response= [request responseData];
	NSError *error;
	CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	NSDictionary *resultsArray = [jsonDeserializer deserialize:response error:&error];
    if ([[resultsArray objectForKey:@"status"] isEqualToString:@"ok"]) {
        
        dataArray = [[NSMutableArray alloc] initWithArray:[resultsArray objectForKey:@"instance"]];
        [tableView reloadData];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"%@",error);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"PAMCell";
	
	PAMCell *cell = (PAMCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[PAMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell autorelease];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    // FOLLOWING CODE ASSUMES API OUTPUT CELL_ID IS IN ORDER!!!!!
    
	if (indexPath.row*4+0 < dataArray.count) {
		cell.imageView1.tag = 999;
		NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://resources.cornellhci.org/pam/images/%@",[[dataArray objectAtIndex:indexPath.row*4+0] objectForKey:@"url"]]];
		[cell.imageView1 loadImageFromURL:url1 forPath:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row*4+0] objectForKey:@"id"]]];
		cell.button1.tag = indexPath.row*4+1;
		[cell.button1 addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
	}
	if (indexPath.row*4+1 < dataArray.count) {
		cell.imageView2.tag = 999;
		NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://resources.cornellhci.org/pam/images/%@",[[dataArray objectAtIndex:indexPath.row*4+1] objectForKey:@"url"]]];
		[cell.imageView2 loadImageFromURL:url2 forPath:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row*4+1] objectForKey:@"id"]]];
		cell.button2.tag = indexPath.row*4+2;
		[cell.button2 addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
	}
	if (indexPath.row*4+2 < dataArray.count) {
		cell.imageView3.tag = 999;
		NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"http://resources.cornellhci.org/pam/images/%@",[[dataArray objectAtIndex:indexPath.row*4+2] objectForKey:@"url"]]];
		[cell.imageView3 loadImageFromURL:url3 forPath:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row*4+2] objectForKey:@"id"]]];
		cell.button3.tag = indexPath.row*4+3;
		[cell.button3 addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
	}
	if (indexPath.row*4+3 < dataArray.count) {
		cell.imageView4.tag = 999;
		NSURL *url4 = [NSURL URLWithString:[NSString stringWithFormat:@"http://resources.cornellhci.org/pam/images/%@",[[dataArray objectAtIndex:indexPath.row*4+3] objectForKey:@"url"]]];
		[cell.imageView4 loadImageFromURL:url4 forPath:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row*4+3] objectForKey:@"id"]]];
		cell.button4.tag = indexPath.row*4+4;
		[cell.button4 addTarget:self action:@selector(photoSelected:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return cell;
	
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if (dataArray.count%5 == 0) {
		return dataArray.count/5;
	} else {
		return dataArray.count/5+1;
	}
}

- (void) photoSelected:(id)sender {
	
    NSString *updateURL= [NSString stringWithFormat:@"http://api.cornellhci.org/pam/grids/instance.php"];
    NSURL *reqURL = [NSURL URLWithString:updateURL];
    ASIFormDataRequest *httprequest = [ASIFormDataRequest requestWithURL:reqURL];
    [httprequest cancel];
    
    updateURL= [NSString stringWithFormat:@"http://api.cornellhci.org/pam/statuses/add.php"];
	reqURL = [NSURL URLWithString:updateURL];
	httprequest = [ASIFormDataRequest requestWithURL:reqURL];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]forKey:@"user_id"];
    [httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"study_id"]forKey:@"study_id"];
	[httprequest setPostValue:[NSString stringWithFormat:@"%d",[sender tag]] forKey:@"image_id"];
	[httprequest setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_offset"] forKey:@"tz_offset"];
	[httprequest startSynchronous];
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSError *error;
	NSDictionary *resultsArray = [jsonDeserializer deserialize:[httprequest responseData] error:&error];
    if ([[resultsArray objectForKey:@"status"] isEqualToString:@"ok"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status Submitted!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        if (NULL != [resultsArray objectForKey:@"error"]) {
            NSString *error= [resultsArray objectForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:"
                                                            message:error
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dataArray release]; dataArray = nil;
	[tableView release]; tableView = nil;
    [super dealloc];
}


@end
