//
//  voiceRecordModule.m
//  audience
//
//  Created by Cornell IDL on 9/28/11.
//  Copyright 2011 High Tech. All rights reserved.
//

#import "voiceRecordModule.h"


@implementation voiceRecordModule
@synthesize url;
@synthesize request;
@synthesize returnString;
@synthesize recordStartTime;
@synthesize timeLabel;
@synthesize myTicker;
@synthesize passed;
@synthesize recordingButton;
@synthesize taggedTime;
@synthesize tagString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    recordEncoding = ENC_PCM;
    myTicker = [[NSTimer alloc]init];
    self.recordStartTime = [[NSDate alloc]init];
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

BOOL isPlaying = FALSE;
-(IBAction)playBtnOnPress{
	if(!isPlaying){
		[self playRecording];
		isPlaying = TRUE;
	}else{
		[self stopPlaying];
		isPlaying = FALSE;
	}
}

BOOL isRecording = FALSE;
-(IBAction)recordBtnPressed{
	if(!isRecording){
		isRecording = TRUE;
		[recordingButton setTitle:@"Stop" forState:UIControlStateNormal];
		[self startRecording];
	}else{
		isRecording = FALSE;
		[recordingButton setTitle:@"Record" forState:UIControlStateNormal];
		[self stopRecording];
	}
}

-(void) startRecording{
	NSLog(@"startRecording");
	[self startTimer];
	[audioRecorder release];
	audioRecorder = nil;
	
	// Init audio with record capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
	
	NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:6];
	if(recordEncoding == ENC_PCM)
	{
        NSLog(@"PCM");
		[recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
		[recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		[recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
		[recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];   
	}
	else
	{
		NSNumber *formatObject;
		
		switch (recordEncoding) {
			case (ENC_AAC): 
				formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
				break;
			case (ENC_ALAC):
				formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
				break;
			case (ENC_IMA4):
				formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
				break;
			case (ENC_ILBC):
				formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
				break;
			case (ENC_ULAW):
				formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
				break;
			default:
				formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
		}
		
		[recordSettings setObject:formatObject forKey: AVFormatIDKey];
		[recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
		[recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
		[recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		[recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
	}
	
	//url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.pcm", [[NSBundle mainBundle] resourcePath]]];
    
    //Documents directory (var/mobile/Documents/recordTest.pcm)
	url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.pcm",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]];
	
	NSError *error = nil;
	audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
	
	if ([audioRecorder prepareToRecord] == YES){
		[audioRecorder record];
	}else {
		int errorCode = CFSwapInt32HostToBig ([error code]); 
		NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode); 
		
	}
}

-(void) stopRecording
{
	[self endTimer];
	[audioRecorder stop];
}

-(IBAction) playRecording{
	// Init audio with playback capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	
	//url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.pcm", [[NSBundle mainBundle] resourcePath]]];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
	[audioPlayer play];
}

-(IBAction) stopPlaying
{
	[audioPlayer stop];
}

-(void)updateTime{
	passed = 0-[self.recordStartTime timeIntervalSinceNow];
	int minutes = (int)floor(passed/60);
	passed = passed - minutes*60;
	NSString* myNewString = [NSString stringWithFormat:@"%.0f", passed];
	if(passed<9.5){
		myNewString = [@"0" stringByAppendingString:myNewString];
	}
	
	timeLabel.text = [NSString stringWithFormat:@"%i:%@",minutes,myNewString];
}

- (void)startTimer{
	NSLog(@"ToggleTimer!");
	self.recordStartTime = [[NSDate date]retain];
	//[myTicker invalidate];
	myTicker = [NSTimer scheduledTimerWithTimeInterval: 1.0
												target: self
											  selector: @selector(updateTime)
											  userInfo: nil
											   repeats: YES];
}
-(void)endTimer{
	[myTicker invalidate];
}


-(IBAction)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}


@end
