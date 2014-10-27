//
//  PhoenixChannel.h
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhoenixSocket;
@interface PhoenixChannel : NSObject

@property (nonatomic, retain) NSString* channel;
@property (nonatomic, retain) NSString* topic;
@property (nonatomic, retain) NSDictionary* message;
@property (nonatomic, retain) PhoenixSocket* socket;

- (id)initWithChannel:(NSString*)channel topic:(NSString*)topic message:(NSDictionary*)message;

- (void)sendEvent:(NSString*)event message:(NSString*)message;
- (void)reset;

@end
