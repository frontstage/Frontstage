//
//  full_release.h
//  audience
//
//  Created by Andy Liang on 3/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol full_releaseDelegate;

@interface full_release : UIViewController {
	id <full_releaseDelegate> delegate;
}

@property (nonatomic,assign) id <full_releaseDelegate> delegate;

@end

@protocol full_releaseDelegate
- (void) full_releaseDidFinish;
@end
