//
//  AFFEventCenter.h
//  AFFramework
//
//  Created by Jeremy Fuellert on 2013-04-10.
//  Copyright (c) 2013 AFFramework. All rights reserved.
//

#import "AFFEvent.h"
#import "AFFEventAPI.h"
#import "AFFEventSystemHandler.h"

#define AFFEventClass       +
#define AFFEventInstance    -

#define AFFEventCreate( $eventLevel, $eventName )                                                   \
$eventLevel (AFFEventAPI *)$eventName

#define AFFEventSynthesize( $eventLevel, $eventName )                                               \
$eventLevel (AFFEventAPI *)$eventName                                                               \
{                                                                                                   \
    return [[AFFEventSystemHandler eventSystem] eventForEventName:@#$eventName fromSender:self];    \
}

#define AFFRemoveAllEvents()                                                                        \
    [[AFFEventSystemHandler eventSystem] removeEventsFromSenderHash:[(NSObject *)self hash]]

#define AFFRemoveEvent( $eventName )                                                                \
    [[AFFEventSystemHandler eventSystem] removeEventNamed:@#$eventName fromSenderHash:[(NSObject *)self hash]];

#define AFFHandler( $selector )                                                                     \
    [AFFEventHandler handlerWithSender:nil andObserver:self                                         \
    andSelector:$selector andEventName:nil andArgs:nil]

#define AFFHandlerWithArgs( $selector, ... )                                                        \
    [AFFEventHandler handlerWithSender:nil andObserver:self                                         \
    andSelector:$selector andEventName:nil andArgs:                                                 \
    [NSArray arrayWithObjects:__VA_ARGS__,nil]]

#define AFFEvents()                                                                                 \
    [[AFFEventSystemHandler eventSystem] eventsFromSenderHash:[(NSObject *)self hash]]