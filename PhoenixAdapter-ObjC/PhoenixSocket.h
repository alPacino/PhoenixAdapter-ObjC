//
//  PhoenixSocket.h
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoenixChannel.h"

typedef enum {
    ConnectingState,
    OpenState,
    ClosingState,
    ClosedState
} ConnectionState;

@protocol PhoenixSocketDelegate <NSObject>

- (void)phoenixDidConnect;
- (void)phoenixDidDisconnect;

@end

@interface PhoenixSocket : NSObject

@property (nonatomic) id<PhoenixSocketDelegate> delegate;
@property (nonatomic, readwrite) BOOL reconnectOnError;

- (id)initWithURL:(NSURL*)url;
- (id)initWithURL:(NSURL*)url heartbeatInterval:(int)interval;

- (ConnectionState)connectionState;
- (BOOL)isConnected;
- (void)reconnect;
- (void)send:(NSDictionary*)payload;
- (void)close;

- (PhoenixChannel*)joinChannel:(NSString*)channel
       topic:(NSString*)topic
     message:(NSDictionary*)message
    callback:(ChannelCallback)callback;

- (void)leaveChannel:(NSString*)channel
               topic:(NSString*)topic
             message:(NSString*)message;

@end
