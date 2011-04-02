//
//  terms.h
//  audience
//
//  Created by Andy Liang on 3/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "full_release.h"

@interface terms : UIViewController <full_releaseDelegate, UITextFieldDelegate> {
	CGFloat animatedDistance;
	
	IBOutlet UISegmentedControl *photo_record;
	IBOutlet UISegmentedControl *over18_verify;
	IBOutlet UITextField *name;
	IBOutlet UITextField *date;
	IBOutlet UITextField *email;
}

- (IBAction) toRelease;

@end
