//
//  cameraModule.h
//  audience
//
//  Created by Cornell IDL on 9/28/11.
//  Copyright 2011 High Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface cameraModule : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    IBOutlet UIImageView *thePicture;
    UIImagePickerController *theCamera;
}

-(IBAction)backBtnPressed;
-(IBAction)launchCamera;

@end
