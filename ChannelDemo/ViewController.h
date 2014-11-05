//
//  ViewController.h
//  ChannelDemo
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSButton *connectButton;
@property (nonatomic, retain) IBOutlet NSTextView *outputTextView;

@property (nonatomic, retain) IBOutlet NSTextField *channelField;
@property (nonatomic, retain) IBOutlet NSTextField *topicField;
@property (nonatomic, retain) IBOutlet NSTextField *channelMsgField;
@property (nonatomic, retain) IBOutlet NSButton *channelJoinButton;

@end

