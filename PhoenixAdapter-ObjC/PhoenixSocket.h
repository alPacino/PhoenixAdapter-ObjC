//
//  PhoenixSocket.h
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

typedef enum {
    ConnectingState,
    OpenState,
    ClosingState,
    ClosedState
} ConnectionState;

@interface PhoenixSocket : NSObject

- (id)initWithURL:(NSURL*)url;
- (ConnectionState)connectionState;
- (BOOL)isConnected;
- (void)reconnect;
- (void)close;
- (void)join:(NSString*)channel topic:(NSString*)topic message:(NSDictionary*)message;

@end
