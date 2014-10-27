//
//  PhoenixSocket.h
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (weak, nonatomic) id<PhoenixSocketDelegate> delegate;

- (id)initWithURL:(NSURL*)url;
- (ConnectionState)connectionState;
- (BOOL)isConnected;
- (void)reconnect;
- (void)close;
- (void)join:(NSString*)channel topic:(NSString*)topic message:(NSDictionary*)message;

@end
