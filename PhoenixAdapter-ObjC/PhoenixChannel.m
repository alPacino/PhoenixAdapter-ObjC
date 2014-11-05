//
//  PhoenixChannel.m
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import "PhoenixChannel.h"
#import "PhoenixSocket.h"

@interface PhoenixChannel ()

@property (nonatomic, retain) NSMutableArray* bindings;

@end

@implementation PhoenixChannel

- (id)initWithChannel:(NSString*)channel topic:(NSString*)topic message:(NSDictionary*)message socket:(PhoenixSocket*)socket callback:(ChannelCallback)callback {
    self = [super init];
    if (self) {
        self.channel = channel;
        self.topic = topic;
        self.message = message;
        self.socket = socket;
        self.callback = callback;
        [self reset];
    }
    return self;
}


- (void)sendEvent:(NSString*)event message:(NSString*)message {
    NSDictionary *payload = @{@"channel":self.channel, @"topic":self.topic, @"event":event, @"message":message};
    if (self.socket) {
        [self.socket send:payload];
    }
}

- (void)onEvent:(NSString*)event callback:(Callback)callback {
    [self.bindings addObject:@{@"event":event, @"callback":callback}];
}

- (void)offEvent:(NSString*)event {
    
}

- (void)triggerEvent:(NSString*)event message:(NSString*)message {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary* binding, NSDictionary *bindings) {
        return [[binding valueForKey:@"event"] isEqualToString:event];
    }];
    NSArray *bindings = [self.bindings filteredArrayUsingPredicate:predicate];
    for (NSDictionary *binding in bindings) {
        Callback callback = [binding objectForKey:@"callback"];
        callback(message);
    }
}

- (void)leave:(NSString*)message {
    if (self.socket) {
        [self.socket leaveChannel:self.channel topic:self.topic message:message];
    }
    [self reset];
}

- (void)reset {
    if (self.bindings) {
        [self.bindings removeAllObjects];
        self.bindings = nil;
    }
    self.bindings = [NSMutableArray new];
}

@end
