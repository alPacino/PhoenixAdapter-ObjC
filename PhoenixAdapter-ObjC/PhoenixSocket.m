//
//  PhoenixSocket.m
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import "PhoenixSocket.h"
#import "PhoenixChannel.h"

const int reconnectSeconds = 5;
const int flushEverySeconds = 0.5;

@interface PhoenixSocket () <SRWebSocketDelegate>

@property (nonatomic, retain) SRWebSocket *socket;
@property (nonatomic, retain) NSURL *URL;
@property (nonatomic) ConnectionState connectionState;

@property (nonatomic, retain) NSMutableArray *channels;
@property (nonatomic, retain) NSMutableArray *sendBuffer;

@property (nonatomic, retain) NSTimer *sendBufferTimer;
@property (nonatomic, retain) NSTimer *reconnectTimer;

@end

@implementation PhoenixSocket

- (id)initWithURL:(NSURL*)url {
    self = [super init];
    if (self) {
        self.URL = url;
        self.channels = [NSMutableArray new];
        self.sendBuffer = [NSMutableArray new];
        [self resetBufferTimer];
        [self reconnect];
    }
    return self;
}

- (ConnectionState)connectionState {
    switch (self.socket.readyState) {
        case 0:
            return ConnectingState;
            break;
        case 1:
            return OpenState;
            break;
        case 2:
            return ClosingState;
            break;
        case 3:
            return ClosedState;
            break;
        default:
            return ClosedState;
            break;
    }
}

- (BOOL)isConnected {
    return [self connectionState] == OpenState;
}

- (void)reconnect {
    [self close];
    self.socket = [[SRWebSocket alloc]initWithURL:self.URL];
    self.socket.delegate = self;
    [self.socket open];
}

- (void)close {
    if (self.socket) {
        self.socket.delegate = nil;
        [self.socket close];
        self.socket = nil;
    }
}

- (void)send:(NSDictionary*)data {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ([self isConnected]) {
            [self.socket send:jsonString];
        } else {
            [self.sendBuffer addObject:jsonString];
        }
    }
}



#pragma mark - PhoenixChannel

- (void)rejoinAll {
    for (PhoenixChannel *channel in self.channels) {
        [self rejoin:channel];
    }
}

- (void)rejoin:(PhoenixChannel*)pChannel {
    NSString *channel = pChannel.channel;
    NSString *topic = pChannel.topic;
    NSMutableDictionary *message = [NSMutableDictionary new];
    [message addEntriesFromDictionary:@{@"status":@"joining"}];
    [message addEntriesFromDictionary:pChannel.message];
    NSDictionary *payload = @{@"channel":channel, @"topic":topic, @"event":@"join", @"message":message};
    [self send:payload];
}

- (void)join:(NSString*)channel topic:(NSString*)topic message:(NSDictionary*)message {
    PhoenixChannel *pChannel = [[PhoenixChannel alloc]initWithChannel:channel topic:topic message:message];
    [self.channels addObject:pChannel];
    if ([self isConnected]) {
        [self rejoin:pChannel];
    }
}

- (void)resetBufferTimer {
    if (self.sendBufferTimer) {
        [self.sendBufferTimer invalidate];
        self.sendBufferTimer = nil;
    }
    self.sendBufferTimer = [NSTimer scheduledTimerWithTimeInterval:flushEverySeconds target:self selector:@selector(flushSendBuffer) userInfo:nil repeats:true];
}

- (void)flushSendBuffer {
    if ([self isConnected] && [self.sendBuffer count] > 0) {
        // Enum the buffer and send data
        for (NSString* jsonString in self.sendBuffer) {
            [self.socket send:jsonString];
        }
        // Empty the Array
        [self.sendBuffer removeAllObjects];
        [self resetBufferTimer];
    }
}

#pragma mark - SRWebSocket Delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket Opened");
    if (self.reconnectTimer) {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
    }
    [self rejoinAll];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Websocket Message:%@",(NSString*)message);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"WebSocket Failed with Error: %@", [error localizedDescription]);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebSocket Closed");
    if (self.reconnectTimer) {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
    }
    self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:reconnectSeconds target:self selector:@selector(reconnect) userInfo:nil repeats:YES];
}

@end
