//
//  cameraModule.m
//  audience
//
//  Created by Cornell IDL on 9/28/11.
//  Copyright 2011 High Tech. All rights reserved.
//

#import "cameraModule.h"


@implementation cameraModule

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)backBtnPressed{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)launchCamera{
    theCamera = [[UIImagePickerController alloc]init];
    theCamera.allowsEditing = NO;
    theCamera.delegate = self;
    theCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:theCamera animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [picker dismissModalViewControllerAnimated:YES];
    thePicture.image = image;
    [thePicture setNeedsDisplay];
    
    /*
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"photoTest.png"];
    
    NSString *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/cameraTest.png",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]];
    
    //UIImage *editedImage = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
    NSData *webData = UIImagePNGRepresentation(image);
    [webData writeToFile:url atomically:YES];
    */
    UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    
    [picker release];
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    UIAlertView *alert;
    if(error){
        alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to save photo to album!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
}

@end
