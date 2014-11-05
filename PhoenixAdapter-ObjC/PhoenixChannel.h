//
//  PhoenixChannel.h
//  SocketTest
//
//  Created by Justin Schneck on 10/27/14.
//  Copyright (c) 2014 LiveHelpNow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhoenixSocket;
@class PhoenixChannel;

typedef void (^Callback)(NSString* message);
typedef void (^ChannelCallback)(PhoenixChannel* chan);

@interface PhoenixChannel : NSObject

@property (nonatomic, retain) NSString* channel;
@property (nonatomic, retain) NSString* topic;
@property (nonatomic, retain) NSDictionary* message;
@property (nonatomic, copy) ChannelCallback callback;
@property (nonatomic, retain) PhoenixSocket* socket;

- (id)initWithChannel:(NSString*)channel
                topic:(NSString*)topic
              message:(NSDictionary*)message
               socket:(PhoenixSocket*)socket
             callback:(ChannelCallback)callback;

- (void)onEvent:(NSString*)event
       callback:(Callback)callback;

- (void)offEvent:(NSString*)event;
- (void)leave:(NSString*)message;

- (void)triggerEvent:(NSString*)event message:(NSString*)message;

- (void)sendEvent:(NSString*)event
          message:(NSString*)message;
- (void)reset;

@end
