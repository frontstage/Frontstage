//
//  AsyncImageView.h
//  frontstage
//
//  Created by andy on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIImageView {
	NSString *thePath;
	UIActivityIndicatorView *indicator;
}

@property(nonatomic, retain) NSString *thePath;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)loadImageFromURL:(NSURL*)url forPath:(NSString*)path;

@end
