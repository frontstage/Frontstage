//
//  MainScreen.h
//  audience
//
//  Created by Andy Liang on 3/14/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainScreen : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *features;
	IBOutlet UITableView *table;

}

@property (nonatomic, retain) NSMutableArray *features;

@end
