//
//  wordcloud.h
//  audience
//
//  Created by Andy Liang on 3/14/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface wordcloud : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
	CGFloat animatedDistance;
	IBOutlet UITableView *table;
	NSMutableArray *wordArray;
	IBOutlet UITextField *word;
}

@property (nonatomic,retain) NSMutableArray *wordArray;

- (IBAction) dismissModal;
- (IBAction) dismissKeyboard;

@end
