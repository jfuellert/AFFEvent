//
//  AFFEventHandler.h
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

#import "AFFEventStatics.h"

@class AFFEvent;

/** AFFEventHandler is a class used for sending an event from one object to another. */
@interface AFFEventHandler : NSObject

/** The sender of the event. */
@property (nonatomic, assign) NSObject *sender;

/** The observer of the event. */
@property (nonatomic, assign) NSObject *observer;

/** The selector that the event will be sent to. */
@property (nonatomic, assign) SEL selector;

/** Arguments that are passed to the selector. */
@property (nonatomic, retain) NSMutableArray *args;

/** A bitewise mask of handler execution characteristics. */
@property (nonatomic, assign) AFFEventType type;

/** A BOOL determining if the block is locked. If |isLocked| is 'YES' then it will not execute it's handler. */
@property (nonatomic, assign, setter = setLocked:) BOOL isLocked;

/** The name of the event. */
@property (nonatomic, retain) NSString *eventNameWithHash;

/** Returns an AFFEventHandler. */
+ (AFFEventHandler *)eventHandlerWithSender:(id)sender observer:(id)observer selector:(SEL)selector name:(NSString *)name args:(NSArray *)args;

- (void)invokeWithEvent:(AFFEvent *)event;

@end