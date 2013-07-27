//
//  AFFEventAPI.m
//  AF Apps
//
//  Created by Jeremy Fuellert on 2013-04-10.
//  Copyright (c) 2013 AF Apps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "AFFEventAPI.h"
#import "ARCHelper.h"

static const char *kAFFEventCleanupQueue = "AFFEventCleanupQueue";

@implementation AFFEventAPI

/*
 * Queue
 */
dispatch_queue_t affAPIDispatchQueue(void)
{
    static dispatch_once_t affAPIDispatchQueuePred;
    static dispatch_queue_t affAPIDispatchQueue = nil;
    
    dispatch_once(&affAPIDispatchQueuePred, ^{
        affAPIDispatchQueue = dispatch_queue_create(kAFFEventCleanupQueue, NULL);
    });
    
    return affAPIDispatchQueue;
}

/*
 * Constructor
 */
AFFEventAPI *affEventWithSender(id lsender, NSString *leventName)
{
    return [[[AFFEventAPI alloc] initWithSender:lsender andEventName:leventName] ah_autorelease];
}

- (AFFEventAPI *)initWithSender:(id)lsender andEventName:(NSString *)leventName
{
    self = [super init];
    if(self)
    {
        sender = lsender;
        eventName = leventName;
    }
    return self;
}

/*
 * Add handler
 */
- (id<AFFEventAPI>)addHandler:(AFFEventHandler *)handler
{
    if(!handlers)
        handlers = [NSMutableSet new];
    
    target = handler->observer;
    handler->sender = sender;
    handler.eventNameWithHash = affCreateEventName(eventName, [(NSObject *)sender hash]);
    [handlers addObject:handler];

    return self;
}

- (id<AFFEventAPI>)addHandlerOneTime:(AFFEventHandler *)handler
{
    if(!handlers)
        handlers = [NSMutableSet new];
    
    target = handler->observer;
    handler.isOneTimeHandler = TRUE;
    handler->sender = sender;
    handler.eventNameWithHash = affCreateEventName(eventName, [(NSObject *)sender hash]);
    [handlers addObject:handler];
    
    return self;
}

/*
 * Remove handlers
 */
- (void)removeHandlers:(NSMutableArray *)handlerSet
{
    dispatch_async(affAPIDispatchQueue(), ^{
        for(id handler in handlerSet)
            [handlers removeObject:handler];
    });
}

- (void)removeHandler:(AFFEventHandler *)handler
{
    [handlers removeObject:handler];
}

- (void)removeAllHandlers
{
    [handlers removeAllObjects];
}

- (void)removeAllHandlersForTarget:(id)observer
{    
    NSMutableSet *removeableHandlers = [NSMutableSet new];
    
    for(AFFEventHandler *handler in handlers)
    {
        if(handler->observer == observer)
            [removeableHandlers addObject:handler];
    }
    
    dispatch_async(affAPIDispatchQueue(), ^{
        for(id handler in removeableHandlers)
            [handlers removeObject:handler];
    });
        
    [removeableHandlers ah_release];
    removeableHandlers = nil;
}

/*
 * Send data
 */
- (void)send
{
    [self send:nil];
}

- (void)send:(id)data
{    
    AFFEvent *event = affEventObjectWithSender(sender, data, eventName);
    NSMutableSet *oneTimeHandlers = [NSMutableSet new];
    NSMutableSet *handlersCopy = [[NSMutableSet alloc] initWithSet:handlers];
        
    for(AFFEventHandler *handler in handlersCopy)
    {
        if([handler.eventNameWithHash isEqualToString:affCreateEventName(eventName, [(NSObject *)sender hash])])
        {
            [handler invokeWithEvent:event];
            if(handler.isOneTimeHandler)
                [oneTimeHandlers addObject:handler];
        }
    }
    
    dispatch_async(affAPIDispatchQueue(), ^{
        for(id object in oneTimeHandlers)
            [handlers removeObject:object];
    });
    
    [handlersCopy ah_release];
    handlersCopy = nil;

    [oneTimeHandlers ah_release];
    oneTimeHandlers = nil;
}

/*
 * Has handler
 */
- (BOOL)hasHandler:(AFFEventHandler *)handler
{
    for(AFFEventHandler *_handler in handlers)
    {
        if([NSStringFromSelector(_handler->selector) isEqualToString:NSStringFromSelector(handler->selector)])
            return TRUE;
    }
    return FALSE;
}

- (void)dealloc
{
    sender = nil;
    target = nil;
    eventName = nil;
    [handlers ah_release];
    handlers = nil;
    
    [super ah_dealloc];
}

@end
