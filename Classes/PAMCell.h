//
//  PAMCell.h
//  vera
//
//  Created by Andy Liang on 1/27/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"


@interface PAMCell : UITableViewCell {
	AsyncImageView *imageView1;
	AsyncImageView *imageView2;
	AsyncImageView *imageView3;
	AsyncImageView *imageView4;
	UIButton *button1;
	UIButton *button2;
	UIButton *button3;
	UIButton *button4;
}

@property(nonatomic, retain) AsyncImageView *imageView1;
@property(nonatomic, retain) AsyncImageView *imageView2;
@property(nonatomic, retain) AsyncImageView *imageView3;
@property(nonatomic, retain) AsyncImageView *imageView4;
@property(nonatomic, retain) UIButton *button1;
@property(nonatomic, retain) UIButton *button2;
@property(nonatomic, retain) UIButton *button3;
@property(nonatomic, retain) UIButton *button4;

@end

