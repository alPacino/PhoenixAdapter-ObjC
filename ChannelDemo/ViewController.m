//
//  ViewController.m
//  ChannelDemo
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import "ViewController.h"
#import "PhoenixSocket.h"
#import "PhoenixChannel.h"

@interface ViewController () <PhoenixSocketDelegate> {
    PhoenixSocket *_socket;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - IBActions

- (IBAction)connectButton:(id)sender {
    NSLog(@"ConnectButton");
    if (_socket) {
        [_socket close];
        _socket = nil;
    }
    NSString *urlString = (NSString*)self.urlField.stringValue;
    if (urlString.length > 0) {
        _socket = [[PhoenixSocket alloc]initWithURL:[NSURL URLWithString:urlString]];
        _socket.delegate = self;
    } else {
        // TODO NSAlert empty url field
    }
    
}

- (IBAction)joinChannel:(id)sender {
    NSLog(@"Join Channel");
    NSString *channelString = self.channelField.stringValue;
    NSString *topicString = self.topicField.stringValue;
    if (channelString.length > 0 || topicString.length > 0) {
        NSString *channelMsgString = self.channelMsgField.stringValue;
        NSDictionary *channelMsgDict;
        if (channelMsgString.length > 0) {

            NSData *data = [channelMsgString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json isKindOfClass:[NSDictionary class]]) {
                channelMsgDict = json;
            }
        }
        [_socket joinChannel:channelString topic:topicString message:channelMsgDict callback:^(PhoenixChannel *chan) {
            [chan onEvent:@"join" callback:^(NSString *message) {
                NSLog(@"Join Message:%@",message);
            }];
        }];
    } else {
        // Empty Channel or Topic String
    }
}

#pragma mark PhoenixSocketDelegate

- (void)phoenixDidConnect {
    NSLog(@"Phoenix Connected");
}

- (void)phoenixDidDisconnect {
    NSLog(@"Phoenix Disconnected");
}

@end
