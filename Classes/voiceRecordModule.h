//
//  voiceRecordModule.h
//  audience
//
//  Created by Cornell IDL on 9/28/11.
//  Copyright 2011 High Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface voiceRecordModule : UIViewController {
    AVAudioPlayer *audioPlayer;
	AVAudioRecorder *audioRecorder;
	int recordEncoding;
	enum
	{
		ENC_AAC = 1,
		ENC_ALAC = 2,
		ENC_IMA4 = 3,
		ENC_ILBC = 4,
		ENC_ULAW = 5,
		ENC_PCM = 6,
	} encodingTypes;
	NSURL *url;
	NSString *returnString;
	NSMutableURLRequest *request;
	NSDate *recordStartTime;
	IBOutlet UILabel *timeLabel;
	NSTimer *myTicker;
	NSTimeInterval passed;
	IBOutlet UIButton *recordingButton;
	NSTimeInterval taggedTime;
	UITextField *textField;
	NSString *tagString;
}

-(void)startRecording;
-(void)stopRecording;
-(void)playRecording;
-(void)stopPlaying;
-(void)startTimer;
-(void)endTimer;

-(IBAction)dismiss;

@property(nonatomic,retain)NSURL *url;
@property(nonatomic,retain)NSString *returnString;
@property(nonatomic,retain)NSMutableURLRequest *request;
@property(nonatomic,retain)NSDate *recordStartTime;
@property(nonatomic,retain)IBOutlet UILabel *timeLabel;
@property(nonatomic,retain)NSTimer *myTicker;
@property(nonatomic)NSTimeInterval passed;
@property(nonatomic,retain)IBOutlet UIButton *recordingButton;
@property(nonatomic)NSTimeInterval taggedTime;
@property(nonatomic,retain)NSString *tagString;
@end
