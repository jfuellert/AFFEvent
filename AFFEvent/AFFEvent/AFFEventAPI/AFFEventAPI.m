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
#import "AFFEventSystemHandler.h"

@interface AFFEventAPI () {
    
    NSMutableSet *_handlers;
    NSMutableSet *_blocks;
}

@end

@implementation AFFEventAPI

#pragma mark - Queue
dispatch_queue_t affAPIDispatchQueue(void) {
    
    static dispatch_once_t affAPIDispatchQueuePred;
    static dispatch_queue_t affAPIDispatchQueue = nil;
    
    dispatch_once(&affAPIDispatchQueuePred, ^{
        affAPIDispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    
    return affAPIDispatchQueue;
}

#pragma mark - Init
+ (AFFEventAPI *)eventWithSender:(id)sender name:(NSString *)name {
    
    return [[[AFFEventAPI alloc] initWithSender:sender name:name] autorelease];
}

- (AFFEventAPI *)initWithSender:(id)sender name:(NSString *)name {
    
    self = [super init];
    if(self) {
        
        _sender      = sender;
        _eventName   = name;
    }
    return self;
}

#pragma mark - Add handler handling
- (id<AFFEventAPIDelegate>)addHandler:(AFFEventHandler *)handler {
    
    [self createHandler:handler type:AFFEventTypeNone];

    return self;
}

- (id<AFFEventAPIDelegate>)addHandlerOneTime:(AFFEventHandler *)handler {
    
    [self createHandler:handler type:AFFEventTypeOneTime];

    return self;
}

- (id<AFFEventAPIDelegate>)addHandlerInBackgroundThread:(AFFEventHandler *)handler {
    
    [self createHandler:handler type:AFFEventTypeWillExecuteInBacground];
    
    return self;
}

- (id<AFFEventAPIDelegate>)addHandlerInBackgroundThreadOneTime:(AFFEventHandler *)handler {
    
    [self createHandler:handler type:AFFEventTypeWillExecuteInBacground | AFFEventTypeOneTime];
    
    return self;
}

- (void)createHandler:(AFFEventHandler *)handler type:(AFFEventType)type {
    
    if(!_handlers) {
        _handlers = [[NSMutableSet alloc] init];
    }
    
    _target                   = handler.observer;
    handler.type              = type;
    handler.sender            = _sender;
    handler.eventNameWithHash = __affCreateEventName(_eventName, [(NSObject *)_sender hash]);
    [_handlers addObject:handler];
}

#pragma mark - Add block handling
- (id<AFFEventAPIDelegate>)addBlock:(AFFBlockEvent)block name:(NSString *)name {
    
    [self createBlock:block name:name type:AFFEventTypeNone];
    
    return self;
}

- (id<AFFEventAPIDelegate>)addBlockOneTime:(void (^)(AFFEvent *event))block name:(NSString *)name {
    
    [self createBlock:block name:name type:AFFEventTypeOneTime];
    
    return self;
}

- (id<AFFEventAPIDelegate>)addBlockInBackgroundThread:(void (^)(AFFEvent *))block name:(NSString *)name {
    
    [self createBlock:block name:name type:AFFEventTypeWillExecuteInBacground];
    
    return self;
}

- (id<AFFEventAPIDelegate>)addBlockInBackgroundThreadOneTime:(void (^)(AFFEvent *))block name:(NSString *)name {
    
    [self createBlock:block name:name type:AFFEventTypeOneTime | AFFEventTypeWillExecuteInBacground];
    
    return self;
}

- (void)createBlock:(AFFBlockEvent)block name:(NSString *)name type:(AFFEventType)type {
    
    if(!_blocks) {
        _blocks = [[NSMutableSet alloc] init];
    }
    
    AFFBlock *newBlock  = [[AFFBlock alloc] init];
    newBlock.blockName  = name;
    newBlock.block      = block;
    newBlock.type       = type;
    
    [_blocks addObject:newBlock];
    
    [newBlock release];
    newBlock = nil;
}

#pragma mark - Handler check methods
- (BOOL)hasHandler:(AFFEventHandler *)handler {
    
    for(AFFEventHandler *handlerInSet in _handlers) {
        if([NSStringFromSelector(handlerInSet.selector) isEqualToString:NSStringFromSelector(handler.selector)]) {
            return YES;
        }
    }
    return NO;
}

- (NSSet *)handlers {
    return _handlers;
}

- (NSSet *)handlersForObserver:(id)observer {
    
    NSMutableSet *returnHandlers = [[NSMutableSet alloc] initWithCapacity:_handlers.count];
    
    for(AFFEventHandler *handlerInSet in _handlers) {
        if([handlerInSet.observer isEqual:observer]) {
            [returnHandlers addObject:handlerInSet];
        }
    }
    return returnHandlers;
}

#pragma mark - Block check methods
- (BOOL)hasBlock:(NSString *)blockName {
    
    for(AFFBlock *block in _blocks) {
        if([block.blockName isEqualToString:blockName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Handler lock methods
- (void)lockHandler:(AFFEventHandler *)handler {
    
    for(AFFEventHandler *handlerInSet in _handlers) {
        if([NSStringFromSelector(handlerInSet.selector) isEqualToString:NSStringFromSelector(handler.selector)]) {
            handlerInSet.isLocked = YES;
            break;
        }
    }
}

- (void)unlockHandler:(AFFEventHandler *)handler {
    
    for(AFFEventHandler *handlerInSet in _handlers) {
        if([NSStringFromSelector(handlerInSet.selector) isEqualToString:NSStringFromSelector(handler.selector)]) {
            handlerInSet.isLocked = NO;
            break;
        }
    }
}

- (void)lockHandlers:(NSSet *)handlers {
    
    for(AFFEventHandler *handler in _handlers) {
        for(AFFEventHandler *handlerInSet in handlers) {
            if([NSStringFromSelector(handler.selector) isEqualToString:NSStringFromSelector(handlerInSet.selector)]) {
                handler.isLocked = YES;
            }
        }
    }
}

- (void)unlockHandlers:(NSSet *)handlers {
    
    for(AFFEventHandler *handler in _handlers) {
        for(AFFEventHandler *handlerInSet in handlers) {
            if([NSStringFromSelector(handler.selector) isEqualToString:NSStringFromSelector(handlerInSet.selector)]) {
                handler.isLocked = NO;
            }
        }
    }
}

- (void)lockHandlers {
    
    for(AFFEventHandler *handler in _handlers) {
        handler.isLocked = YES;
    }
}

- (void)unlockHandlers {
    
    for(AFFEventHandler *handler in _handlers) {
        handler.isLocked = NO;
    }
}

- (NSSet *)lockedHandlers {
    
    NSMutableSet *lockedHandlers = [[NSMutableSet alloc] initWithCapacity:_handlers.count];
    
    for(AFFEventHandler *handler in _handlers) {
        if(handler.isLocked) {
            [lockedHandlers addObject:handler];
        }
    }
    return [lockedHandlers autorelease];
}

- (NSSet *)unlockedHandlers {
    
    NSMutableSet *unlockedHandlers = [[NSMutableSet alloc] initWithCapacity:_handlers.count];
    
    for(AFFEventHandler *handler in _handlers) {
        if(!handler.isLocked) {
            [unlockedHandlers addObject:handler];
        }
    }
    return [unlockedHandlers autorelease];
}

- (BOOL)isHandlerLocked:(AFFEventHandler *)handler {
    
    for(AFFEventHandler *handlerInSet in _handlers) {
        if([NSStringFromSelector(handlerInSet.selector) isEqualToString:NSStringFromSelector(handler.selector)]) {
            return handlerInSet.isLocked;
        }
    }
    return NO;
}

#pragma mark - Block lock methods
- (void)lockBlockByName:(NSString *)blockName {
    
    for(AFFBlock *block in _blocks) {
        if([block.blockName isEqualToString:blockName]) {
            block.isLocked = YES;
            break;
        }
    }
}

- (void)unlockBlockByName:(NSString *)blockName {
    
    for(AFFBlock *block in _blocks) {
        if([block.blockName isEqualToString:blockName]) {
            block.isLocked = NO;
            break;
        }
    }
}

- (void)lockBlocksByNames:(NSSet *)blockNames {
    
    for(AFFBlock *block in _blocks) {
        for(NSString *blockNameInSet in blockNames) {
            if([block.blockName isEqualToString:blockNameInSet]) {
                block.isLocked = YES;
            }
        }
    }
}

- (void)unlockBlocksByNames:(NSSet *)blockNames
{
    for(AFFBlock *block in _blocks) {
        for(NSString *blockNameInSet in blockNames) {
            if([block.blockName isEqualToString:blockNameInSet]) {
                block.isLocked = NO;
            }
        }
    }
}

- (void)lockBlocks {
    for(AFFBlock *block in _blocks) {
        block.isLocked = YES;
    }
}

- (void)unlockBlocks {
    for(AFFBlock *block in _blocks) {
        block.isLocked = NO;
    }
}

- (NSSet *)lockedBlocks {
    
    NSMutableSet *lockedBlocks = [[NSMutableSet alloc] initWithCapacity:_blocks.count];
    
    for(AFFBlock *block in _blocks) {
        if(block.isLocked) {
            [lockedBlocks addObject:block];
        }
    }
    
    return [lockedBlocks autorelease];
}

- (NSSet *)unlockedBlocks {
    
    NSMutableSet *unlockedBlocks = [[NSMutableSet alloc] initWithCapacity:_blocks.count];
    
    for(AFFBlock *block in _blocks) {
        if(!block.isLocked) {
            [unlockedBlocks addObject:block];
        }
    }
    
    return [unlockedBlocks autorelease];
}

- (BOOL)isBlockLocked:(NSString *)blockName {
    
    for(AFFBlock *block in _blocks) {
        if([block.blockName isEqualToString:blockName]) {
            return block.isLocked;
        }
    }
    return NO;
}

#pragma mark - Handler removal handling
- (void)removeHandler:(AFFEventHandler *)handler {
    
    for(AFFEventHandler *handlerInSet in _handlers) {
        if([handlerInSet.observer isEqual:handler.observer] && [NSStringFromSelector(handlerInSet.selector) isEqualToString:NSStringFromSelector(handler.selector)]) {
            [_handlers removeObject:handlerInSet];
            break;
        }
    }
}

- (void)removeHandlers:(NSSet *)handlerSet {
    
    for(AFFEventHandler *handler in handlerSet) {
        [self removeHandler:handler];
    }
}

- (void)removeHandlers {
    
    [_handlers removeAllObjects];
}

- (void)removeHandlersForObserver:(id)observer {
    
    NSMutableSet *removeableHandlers = [[NSMutableSet alloc] initWithCapacity:_handlers.count];
    
    for(AFFEventHandler *handler in _handlers) {
        if(handler.observer == observer) {
            [removeableHandlers addObject:handler];
        }
    }
    
    for(id handler in removeableHandlers) {
        [_handlers removeObject:handler];
    }
    
    [removeableHandlers release];
    removeableHandlers = nil;
}

#pragma mark - Block removal handling
- (void)removeBlockByName:(NSString *)blockName {
    
    for(AFFBlock *block in _blocks) {
        if([block.blockName isEqualToString:blockName]) {
            [_blocks removeObject:block];
            break;
        }
    }
}

- (void)removeBlocksByName:(NSSet *)blockNames {
    
    for(NSString *blockName in blockNames) {
        [self removeBlockByName:blockName];
    }
}

- (void)removeBlocks {
    
    [_blocks removeAllObjects];
}

#pragma mark - Sending event and data handling
- (void)send {
    [self send:nil];
}

- (void)send:(id)data {
    
    //Event
    AFFEvent *event = [AFFEvent eventWithSender:_sender data:data name:_eventName];

    //Blocks
    NSSet *blocksCopy = [[NSSet alloc] initWithSet:[self unlockedBlocks]];
    NSMutableSet *oneTimeBlocks = [[NSMutableSet alloc] initWithCapacity:blocksCopy.count];
    
    for(AFFBlock *block in blocksCopy) {
        
        if((block.type & AFFEventTypeWillExecuteInBacground)) {
            dispatch_async(affAPIDispatchQueue(), ^{
                block.block(event);
            });
        } else {
            block.block(event);
        }
        
        if((block.type & AFFEventTypeOneTime)) {
            [oneTimeBlocks addObject:block];
        }
    }
    
    //Handlers
    NSSet *handlersCopy           = [[NSSet alloc] initWithSet:[self unlockedHandlers]];
    NSMutableSet *oneTimeHandlers = [[NSMutableSet alloc] initWithCapacity:handlersCopy.count];

    for(AFFEventHandler *handler in handlersCopy) {
        
        if([handler.eventNameWithHash isEqualToString:__affCreateEventName(_eventName, [(NSObject *)_sender hash])]) {
            if((handler.type & AFFEventTypeWillExecuteInBacground)) {
                dispatch_async(affAPIDispatchQueue(), ^{
                    [handler invokeWithEvent:event];
                });
            } else {
                [handler invokeWithEvent:event];
            }
            
            if((handler.type & AFFEventTypeOneTime)) {
                [oneTimeHandlers addObject:handler];
            }
        }
    }
    
    //Cleanup
    for(id object in oneTimeHandlers) {
        [_handlers removeObject:object];
    }
    
    for(id object in oneTimeBlocks) {
        [_blocks removeObject:object];
    }
    
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
    _sender = nil;
    _target = nil;
    _eventName = nil;
    
    if(_handlers) {
        [_handlers release];
    }
    _handlers = nil;
    
    if(_blocks) {
        [_blocks release];
    }
    _blocks = nil;
    
    [super dealloc];
}

@end