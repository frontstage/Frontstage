    //
//  AsyncImageView.m
//  frontstage
//
//  Created by andy on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation AsyncImageView

@synthesize thePath;
@synthesize indicator;

- (void)dealloc {
	[indicator release]; indicator = nil;
	[thePath release]; thePath = nil;
	[super dealloc];
}


- (void)loadImageFromURL:(NSURL*)url forPath:(NSString*)path{
	
	if (![path isEqualToString:self.thePath]) {
		// new image
		self.image = nil;
		self.thePath = path;
		// show indicator
		if (indicator == nil) {
			indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			indicator.frame = CGRectMake((self.bounds.size.width - 20) / 2, (self.bounds.size.height - 20) / 2, 20, 20); 
			[self addSubview: indicator];
			[indicator startAnimating];
		} else {
			[self addSubview:indicator];
			[indicator startAnimating];
		}
		
		
		// show stretched version first, then display fetched larger image
		NSString *surl = [url absoluteString];
		
		if ([surl rangeOfString:@"user-uploads/originals" options:NSCaseInsensitiveSearch].length > 0) {
			NSURL *path = [NSURL URLWithString:[surl stringByReplacingOccurrencesOfString:@"user-uploads/originals" withString:@"user-uploads"]];
			[self loadImageFromURL:path forPath:@""];
		} else if ([surl rangeOfString:@"medium" options:NSCaseInsensitiveSearch].length > 0) {
			NSURL *path = [NSURL URLWithString:[surl stringByReplacingOccurrencesOfString:@"medium" withString:@"emotions"]];
			[self loadImageFromURL:path forPath:@""];
		}
		
		
		// request with caching
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		
		[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
		[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
		[request setDelegate:self];
		[request setDownloadCache:[ASIDownloadCache sharedCache]];
		[request startAsynchronous];
	} else {
		// image is the same as old image, do nothing
	}
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	if ([[request responseString] rangeOfString:@"error" options:NSCaseInsensitiveSearch].length == 0) {
	self.image = [UIImage imageWithData:[request responseData]];
	[self setNeedsDisplay];
	[indicator stopAnimating];
	[indicator removeFromSuperview];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"%@",error);
}





@end