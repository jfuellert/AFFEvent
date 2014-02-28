//
//  AFFEventAPI.h
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

@class AFFEvent;
@class AFFEventHandler;

typedef void(^AFFBlockEvent)(AFFEvent *event);

@protocol AFFEventAPIDelegate

#pragma mark - Add handler handling
/** Attaches a handler to an event. */
- (id<AFFEventAPIDelegate>)addHandler:(AFFEventHandler *)handler;

/** Attaches a handler to an event that will only fire once. */
- (id<AFFEventAPIDelegate>)addHandlerOneTime:(AFFEventHandler *)handler;

/** Attaches a handler to an event that will run in a background thread. */
- (id<AFFEventAPIDelegate>)addHandlerInBackgroundThread:(AFFEventHandler *)handler;

/** Attaches a handler to an event that will only fire once and run in a background thread. */
- (id<AFFEventAPIDelegate>)addHandlerInBackgroundThreadOneTime:(AFFEventHandler *)handler;

#pragma mark - Add block handling
/** Attaches a block to an event. */
- (id<AFFEventAPIDelegate>)addBlock:(AFFBlockEvent)block name:(NSString *)name;

/** Attaches a block to an event that will only fire once. */
- (id<AFFEventAPIDelegate>)addBlockOneTime:(AFFBlockEvent)block name:(NSString *)name;

/** Attaches a block to an event that will run in a background thread. */
- (id<AFFEventAPIDelegate>)addBlockInBackgroundThread:(AFFBlockEvent)block name:(NSString *)name;

/** Attaches a block to an event that will only fire once and run in a background thread. */
- (id<AFFEventAPIDelegate>)addBlockInBackgroundThreadOneTime:(AFFBlockEvent)block name:(NSString *)name;

#pragma mark - Handler check methods
/** Returns a BOOL whether or not an event api contains a handler. */
- (BOOL)hasHandler:(AFFEventHandler *)handler;

/** Returns all of the handlers for the event api. */
- (NSSet *)handlers;

/** Returns all of the handlers for the event api for a specific observer. */
- (NSSet *)handlersForObserver:(id)observer;

#pragma mark - Block check methods
/** Returns a BOOL whether or not an event api contains a block. */
- (BOOL)hasBlock:(NSString *)blockName;

#pragma mark - Handler lock methods
/** Locks a handler. This prevents the handler from being fired when the event is triggered. */
- (void)lockHandler:(AFFEventHandler *)handler;

/** Unocks a handler. This allows the handler to be fired when the event is triggered. */
- (void)unlockHandler:(AFFEventHandler *)handler;

/** Locks a set of handlers. This prevents the selected handlers from being fired when the event is triggered. */
- (void)lockHandlers:(NSSet *)handlers;

/** Unlocks a set of handlers. This allows the selected handlers to be fired when the event is triggered. */
- (void)unlockHandlers:(NSSet *)handlers;

/** Locks all of the event api handlers. */
- (void)lockHandlers;

/** Unlocks all of the event api handlers. */
- (void)unlockHandlers;

/** Returns the locked handlers for the event api. */
- (NSSet *)lockedHandlers;

/** Returns the unlocked handlers for the event api. */
- (NSSet *)unlockedHandlers;

/** Returns a BOOL whether or not a handler is locked. */
- (BOOL)isHandlerLocked:(AFFEventHandler *)handler;

#pragma mark - Block lock methods
/** Locks a block. This prevents the block from being fired when the event is triggered. */
- (void)lockBlockByName:(NSString *)blockName;

/** Unocks a block. This allows the block to be fired when the event is triggered. */
- (void)unlockBlockByName:(NSString *)blockName;

/** Locks a set of blocks. This prevents the selected blocks from being fired when the event is triggered. */
- (void)lockBlocksByNames:(NSSet *)blockNames;

/** Unlocks a set of blocks. This allows the selected blocks to be fired when the event is triggered. */
- (void)unlockBlocksByNames:(NSSet *)blockNames;

/** Locks all of the event api blocks. */
- (void)lockBlocks;

/** Unlocks all of the event api blocks. */
- (void)unlockBlocks;

/** Returns the locked blocks for the event api. */
- (NSSet *)lockedBlocks;

/** Returns the unlocked blocks for the event api. */
- (NSSet *)unlockedBlocks;

/** Returns a BOOL whether or not a block is locked. */
- (BOOL)isBlockLocked:(NSString *)blockName;

#pragma mark - Handler removal handling
/** Removes a handler from the event api. */
- (void)removeHandler:(AFFEventHandler *)handler;

/** Removes a set of handlers from the event api. */
- (void)removeHandlers:(NSSet *)handlerSet;

/** Removes a set of handlers from the event api for a specific observer. */
- (void)removeHandlersForObserver:(id)observer;

/** Removes all handlers from the event api. */
- (void)removeHandlers;

#pragma mark - Block removal handling
/** Removes a block from the event api. */
- (void)removeBlockByName:(NSString *)blockName;

/** Removes a set of blocks from the event api. */
- (void)removeBlocksByName:(NSSet *)blockNames;

/** Removes all blocks from the event api. */
- (void)removeBlocks;

#pragma mark - Sending event and data handling
/** Sends an event. This will trigger any attached handlers or blocks if they are enabled. */
- (void)send;

/** Sends an event with data. This will trigger any attached handlers or blocks if they are enabled. */
- (void)send:(id)data;

@end

/** AFFEventAPI is an event object that allows objects to pass messages, with or without data, between eachother. */
@interface AFFEventAPI : NSObject<AFFEventAPIDelegate>

/** The object that is sending the event. */
@property (nonatomic, assign, readonly) id sender;

/** The object that is receiving the event. */
@property (nonatomic, assign, readonly) id target;

/** The name of the event. */
@property (nonatomic, assign, readonly) NSString *eventName;

/** Returns an AFFEventAPI object. */
+ (AFFEventAPI *)eventWithSender:(id)sender name:(NSString *)name;

@end