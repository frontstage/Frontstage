    //
//  PAMCell.m
//  vera
//
//  Created by Andy Liang on 1/27/11.
//  Copyright 2011 None. All rights reserved.
//

#import "PAMCell.h"


@implementation PAMCell

@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		CGRect frame = CGRectMake(0, 0, 80, 80);
		
		imageView1 = [[AsyncImageView alloc] initWithFrame:frame];
		button1 = [[UIButton alloc] initWithFrame:frame];
		[self.contentView addSubview:imageView1];
		[self.contentView addSubview:button1];
		
		frame.origin.x += 80;
		imageView2 = [[AsyncImageView alloc] initWithFrame:frame];
		button2 = [[UIButton alloc] initWithFrame:frame];
		[self.contentView addSubview:imageView2];
		[self.contentView addSubview:button2];
		
		frame.origin.x += 80;
		imageView3 = [[AsyncImageView alloc] initWithFrame:frame];
		button3 = [[UIButton alloc] initWithFrame:frame];
		[self.contentView addSubview:imageView3];
		[self.contentView addSubview:button3];
		
		frame.origin.x += 80;
		imageView4 = [[AsyncImageView alloc] initWithFrame:frame];
		button4 = [[UIButton alloc] initWithFrame:frame];
		[self.contentView addSubview:imageView4];
		[self.contentView addSubview:button4];
	}
	return self;
}

- (void)dealloc {
	[imageView1 release]; imageView1 = nil;
	[imageView2 release]; imageView2 = nil;
	[imageView3 release]; imageView3 = nil;
	[imageView4 release]; imageView4 = nil;
	[button1 release]; button1 = nil;
	[button2 release]; button2 = nil;
	[button3 release]; button3 = nil;
	[button4 release]; button4 = nil;
	
    [super dealloc];
}


@end


@end
