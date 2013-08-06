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

#import "AFFBlock.h"
#import "AFFEventAPI.h"

@interface AFFEventAPI ()
{
    NSMutableSet *_handlers;
    NSMutableSet *_blocks;
}

@end

@implementation AFFEventAPI

/*
 * Queue
 */
dispatch_queue_t affAPIDispatchQueue(void)
{
    static dispatch_once_t affAPIDispatchQueuePred;
    static dispatch_queue_t affAPIDispatchQueue = nil;
    
    dispatch_once(&affAPIDispatchQueuePred, ^{
        affAPIDispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    });
    
    return affAPIDispatchQueue;
}

/*
 * Constructor
 */
AFFEventAPI *affEventWithSender(id lsender, NSString *leventName)
{
    return [[[AFFEventAPI alloc] initWithSender:lsender andEventName:leventName] autorelease];
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
    if(!_handlers)
        _handlers = [NSMutableSet new];
    
    target = handler->observer;
    handler->sender = sender;
    handler.eventNameWithHash = affCreateEventName(eventName, [(NSObject *)sender hash]);
    [_handlers addObject:handler];

    return self;
}

- (id<AFFEventAPI>)addHandlerOneTime:(AFFEventHandler *)handler
{
    if(!_handlers)
        _handlers = [NSMutableSet new];
    
    target = handler->observer;
    handler.isOneTimeHandler = TRUE;
    handler->sender = sender;
    handler.eventNameWithHash = affCreateEventName(eventName, [(NSObject *)sender hash]);
    [_handlers addObject:handler];
    
    return self;
}

/*
 * Add block
 */
- (id<AFFEventAPI>)addBlock:(void (^)(AFFEvent *event))block withName:(NSString *)name
{
    if(!_blocks)
        _blocks = [NSMutableSet new];

    AFFBlock *newBlock = [AFFBlock new];
    newBlock.blockName = name;
    newBlock.block = block;
    
    [_blocks addObject:newBlock];
    
    [newBlock release];
    newBlock = nil;
    
    return self;
}

- (id<AFFEventAPI>)addBlockOneTime:(void (^)(AFFEvent *event))block withName:(NSString *)name
{
    if(!_blocks)
        _blocks = [NSMutableSet new];
    
    AFFBlock *newBlock = [AFFBlock new];
    newBlock.blockName = name;
    newBlock.block = block;
    newBlock.isOneTimeBlock = TRUE;
    
    [_blocks addObject:newBlock];
    
    [newBlock release];
    newBlock = nil;
    
    return self;
}

/*
 * Handler check methods
 */
- (BOOL)hasHandler:(AFFEventHandler *)handler
{
    for(AFFEventHandler *handlerInSet in _handlers)
    {
        if([NSStringFromSelector(handlerInSet->selector) isEqualToString:NSStringFromSelector(handler->selector)])
            return TRUE;
    }
    return FALSE;
}

- (NSSet *)handlers
{
    return _handlers;
}

- (NSSet *)handlersForObserver:(id)observer
{
    NSMutableSet *returnHandlers = [NSMutableSet new];
    for(AFFEventHandler *handlerInSet in _handlers)
    {
        if([handlerInSet->observer isEqual:observer])
            [returnHandlers addObject:handlerInSet];
    }
    return returnHandlers;
}

/*
 * Block check methods
 */
- (BOOL)hasBlock:(NSString *)blockName
{
    for(AFFBlock *block in _blocks)
    {
        if([block.blockName isEqualToString:blockName])
            return TRUE;
    }
    return FALSE;
}

/*
 * Handler lock methods
 */
- (void)lockHandler:(AFFEventHandler *)handler
{
    for(AFFEventHandler *handlerInSet in _handlers)
    {
        if([NSStringFromSelector(handlerInSet->selector) isEqualToString:NSStringFromSelector(handler->selector)])
        {
            handlerInSet.isLocked = TRUE;
            break;
        }
    }
}

- (void)unlockHandler:(AFFEventHandler *)handler
{
    for(AFFEventHandler *handlerInSet in _handlers)
    {
        if([NSStringFromSelector(handlerInSet->selector) isEqualToString:NSStringFromSelector(handler->selector)])
        {
            handlerInSet.isLocked = FALSE;
            break;
        }
    }
}

- (void)lockHandlers:(NSSet *)handlers
{
    for(AFFEventHandler *handler in _handlers)
    {
        for(AFFEventHandler *handlerInSet in handlers)
        {
            if([NSStringFromSelector(handler->selector) isEqualToString:NSStringFromSelector(handlerInSet->selector)])
            {
                handler.isLocked = TRUE;
            }
        }
    }
}

- (void)unlockHandlers:(NSSet *)handlers
{
    for(AFFEventHandler *handler in _handlers)
    {
        for(AFFEventHandler *handlerInSet in handlers)
        {
            if([NSStringFromSelector(handler->selector) isEqualToString:NSStringFromSelector(handlerInSet->selector)])
            {
                handler.isLocked = FALSE;
            }
        }
    }
}

- (void)lockHandlers
{
    for(AFFEventHandler *handler in _handlers)
        handler.isLocked = TRUE;
}

- (void)unlockHandlers
{
    for(AFFEventHandler *handler in _handlers)
        handler.isLocked = FALSE;
}

- (NSSet *)lockedHandlers
{
    NSMutableSet *lockedHandlers = [[NSMutableSet alloc] initWithCapacity:_handlers.count];
    
    for(AFFEventHandler *handler in _handlers)
    {
        if(handler.isLocked)
            [lockedHandlers addObject:handler];
    }
    return [lockedHandlers autorelease];
}

- (NSSet *)unlockedHandlers
{
    NSMutableSet *unlockedHandlers = [[NSMutableSet alloc] initWithCapacity:_handlers.count];
    
    for(AFFEventHandler *handler in _handlers)
    {
        if(!handler.isLocked)
            [unlockedHandlers addObject:handler];
    }
    return [unlockedHandlers autorelease];
}

- (BOOL)isHandlerLocked:(AFFEventHandler *)handler
{
    for(AFFEventHandler *handlerInSet in _handlers)
    {
        if([NSStringFromSelector(handlerInSet->selector) isEqualToString:NSStringFromSelector(handler->selector)])
            return handlerInSet.isLocked;
    }
    return FALSE;
}

/*
 * Block lock methods
 */
- (void)lockBlockByName:(NSString *)blockName
{
    for(AFFBlock *block in _blocks)
    {
        if([block.blockName isEqualToString:blockName])
        {
            block.isLocked = TRUE;
            break;
        }
    }
}

- (void)unlockBlockByName:(NSString *)blockName
{
    for(AFFBlock *block in _blocks)
    {
        if([block.blockName isEqualToString:blockName])
        {
            block.isLocked = FALSE;
            break;
        }
    }
}

- (void)lockBlocksByNames:(NSSet *)blockNames
{
    for(AFFBlock *block in _blocks)
    {
        for(NSString *blockNameInSet in blockNames)
        {
            if([block.blockName isEqualToString:blockNameInSet])
            {
                block.isLocked = TRUE;
            }
        }
    }
}

- (void)unlockBlocksByNames:(NSSet *)blockNames
{
    for(AFFBlock *block in _blocks)
    {
        for(NSString *blockNameInSet in blockNames)
        {
            if([block.blockName isEqualToString:blockNameInSet])
            {
                block.isLocked = FALSE;
            }
        }
    }
}

- (void)lockBlocks
{
    for(AFFBlock *block in _blocks)
        block.isLocked = TRUE;
}

- (void)unlockBlocks
{
    for(AFFBlock *block in _blocks)
        block.isLocked = FALSE;
}

- (NSSet *)lockedBlocks
{
    NSMutableSet *lockedBlocks = [[NSMutableSet alloc] initWithCapacity:_blocks.count];
    
    for(AFFBlock *block in _blocks)
    {
        if(block.isLocked)
            [lockedBlocks addObject:block];
    }
    return [lockedBlocks autorelease];
}

- (NSSet *)unlockedBlocks
{
    NSMutableSet *unlockedBlocks = [[NSMutableSet alloc] initWithCapacity:_blocks.count];
    
    for(AFFBlock *block in _blocks)
    {
        if(!block.isLocked)
            [unlockedBlocks addObject:block];
    }
    return [unlockedBlocks autorelease];
}

- (BOOL)isBlockLocked:(NSString *)blockName
{
    for(AFFBlock *block in _blocks)
    {
        if([block.blockName isEqualToString:blockName])
            return block.isLocked;
    }
    return FALSE;
}

/*
 * Remove handlers
 */
- (void)removeHandler:(AFFEventHandler *)handler
{
    for(AFFEventHandler *handlerInSet in _handlers)
    {
        if([handlerInSet->observer isEqual:handler->observer] && [NSStringFromSelector(handlerInSet->selector) isEqualToString:NSStringFromSelector(handler->selector)])
        {
            [_handlers removeObject:handlerInSet];
            break;
        }
    }
}

- (void)removeHandlers:(NSSet *)handlerSet
{
    dispatch_async(affAPIDispatchQueue(), ^{
        for(AFFEventHandler *handler in handlerSet)
            [self removeHandler:handler];
    });
}

- (void)removeHandlers
{
    [_handlers removeAllObjects];
}

- (void)removeHandlersForObserver:(id)observer
{    
    NSMutableSet *removeableHandlers = [NSMutableSet new];
    
    for(AFFEventHandler *handler in _handlers)
    {
        if(handler->observer == observer)
            [removeableHandlers addObject:handler];
    }
    
    dispatch_async(affAPIDispatchQueue(), ^{
        for(id handler in removeableHandlers)
            [_handlers removeObject:handler];
    });
    
    [removeableHandlers release];
    removeableHandlers = nil;
}

/*
 * Remove blocks
 */
- (void)removeBlockByName:(NSString *)blockName
{
    for(AFFBlock *block in _blocks)
    {
        if([block.blockName isEqualToString:blockName])
        {
            [_blocks removeObject:block];
            break;
        }
    }
}

- (void)removeBlocksByName:(NSSet *)blockNames
{
    dispatch_async(affAPIDispatchQueue(), ^{
        for(NSString *blockName in blockNames)
            [self removeBlockByName:blockName];
    });
}

- (void)removeBlocks
{
    [_blocks removeAllObjects];
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
    //Event
    AFFEvent *event = affEventObjectWithSender(sender, data, eventName);

    //Blocks
    NSMutableSet *oneTimeBlocks = [NSMutableSet new];
    NSMutableSet *blocksCopy = [[NSMutableSet alloc] initWithSet:[self unlockedBlocks]];
    for(AFFBlock *block in blocksCopy)
    {
        block.block(event);
        if(block.isOneTimeBlock)
            [oneTimeBlocks addObject:block];
    }
    
    //Handlers
    NSMutableSet *oneTimeHandlers = [NSMutableSet new];
    NSMutableSet *handlersCopy = [[NSMutableSet alloc] initWithSet:[self unlockedHandlers]];
    
    for(AFFEventHandler *handler in handlersCopy)
    {
        if([handler.eventNameWithHash isEqualToString:affCreateEventName(eventName, [(NSObject *)sender hash])])
        {
            [handler invokeWithEvent:event];
            if(handler.isOneTimeHandler)
                [oneTimeHandlers addObject:handler];
        }
    }
    
    //Cleanup
    dispatch_async(affAPIDispatchQueue(), ^{
        for(id object in oneTimeHandlers)
            [_handlers removeObject:object];
        
        for(id object in oneTimeBlocks)
            [_blocks removeObject:object];
    });
    
    [blocksCopy release];
    blocksCopy = nil;

    [oneTimeBlocks release];
    oneTimeBlocks = nil;
    
    [handlersCopy release];
    handlersCopy = nil;

    [oneTimeHandlers release];
    oneTimeHandlers = nil;
}

- (void)dealloc
{
    sender = nil;
    target = nil;
    eventName = nil;
    
    if(_handlers)
        [_handlers release];
    _handlers = nil;
    
    if(_blocks)
        [_blocks release];
    _blocks = nil;
    
    [super dealloc];
}

@end