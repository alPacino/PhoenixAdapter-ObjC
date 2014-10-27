//
//  ViewController.m
//  ChannelDemo
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import "ViewController.h"
#import "PhoenixSocket.h"

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

#pragma mark PhoenixSocketDelegate

- (void)phoenixDidConnect {
    NSLog(@"Phoenix Connected");
}

- (void)phoenixDidDisconnect {
    NSLog(@"Phoenix Disconnected");
}

@end
