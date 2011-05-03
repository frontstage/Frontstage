//
//  SelectPhoto.h
//  frontstage
//
//  Created by andy on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectPhoto : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	NSArray *dataArray;
}

@property(nonatomic, retain) NSArray *dataArray;

-(IBAction) cancel;

@end
