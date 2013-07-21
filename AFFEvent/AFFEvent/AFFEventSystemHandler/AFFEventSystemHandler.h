//
//  AFFEventSystemHandler.h
//  AFFramework
//
//  Created by Jeremy Fuellert on 2013-04-10.
//  Copyright (c) 2013 AFFramework. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFFEventAPI;

@interface AFFEventSystemHandler : NSObject
{
    @private
    NSMutableDictionary *eventDictionary;
}

+ (AFFEventSystemHandler *)eventSystem;

- (AFFEventAPI *)eventForEventName:(NSString *)eventName fromSender:(id)sender;
- (NSArray *)eventsFromSenderHash:(NSUInteger)senderHash;

- (void)removeEventNamed:(NSString *)eventName fromSenderHash:(NSUInteger)senderHash;
- (void)removeEventsFromSenderHash:(NSUInteger)senderHash;

NSString *createEventName (NSString *eventName, NSUInteger hash);

@end
