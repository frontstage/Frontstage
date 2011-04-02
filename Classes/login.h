//
//  login.h
//  audience
//
//  Created by Andy Liang on 3/9/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface login : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel *username_text;
	IBOutlet UILabel *password_text;
	IBOutlet UILabel *session_id_text;
	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	IBOutlet UITextField *session_id;
	IBOutlet UIButton *go;

}

- (IBAction) loginTapped;

@end
