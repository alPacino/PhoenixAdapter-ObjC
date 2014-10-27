//
//  PhoenixChannel.m
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import "PhoenixChannel.h"

@interface PhoenixChannel ()

@end

@implementation PhoenixChannel

- (id)initWithChannel:(NSString*)channel topic:(NSString*)topic message:(NSDictionary*)message {
    self = [super init];
    if (self) {
        self.channel = channel;
        self.topic = topic;
        self.message = message;
    }
    return self;
}


- (void)sendEvent:(NSString*)event message:(NSString*)message {
    
}

- (void)reset {
    
}

@end
