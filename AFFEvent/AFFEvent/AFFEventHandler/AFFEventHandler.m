//
//  AFFEventHandler.m
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

#import "AFFEventHandler.h"
#import "ARCHelper.h"
#include <objc/runtime.h>
#include <objc/message.h>

@implementation AFFEventHandler
@synthesize isOneTimeHandler;

+ (id)handlerWithSender:(id)lsender andObserver:(id)lobserver andSelector:(SEL)lselector andEventName:(const char *)leventName andArgs:(NSArray *)largs
{
    return [[[self alloc] initWithSender:lsender andObserver:lobserver andSelector:lselector andEventName:leventName andArgs:largs] ah_autorelease];
}

- (id)initWithSender:(NSObject *)lsender andObserver:(NSObject *)lobserver andSelector:(SEL)lselector andEventName:(const char *)leventName andArgs:(NSArray *)largs
{
    self = [super init];
    if(self)
    {
        sender = lsender;
        observer = lobserver;
        selector = lselector;
        args = [[NSMutableArray alloc] initWithArray:largs];
        self.isOneTimeHandler = FALSE;
    }
    return self;
}

- (void)invokeWithEvent:(AFFEvent *)event
{
    if(observer && selector)
    {
        if(![observer respondsToSelector:selector])
            @throw [NSException exceptionWithName:@"AFFEventInvalidSelectorException" reason:[NSString stringWithFormat:@"\nMethod '%@' was not recognized or does not exist in class '%@'.", NSStringFromSelector(selector), NSStringFromClass([observer class])] userInfo:nil];
        
        NSMethodSignature *signature = [observer methodSignatureForSelector:selector];
        if(!signature) return;
        
        int signatureCount = [signature numberOfArguments];
        int argumentCount = [args count];
        
        //Two arguments are hidden defaults. Check for correct number of arguments
        if(signatureCount - argumentCount < 2)
            @throw [NSException exceptionWithName:@"AFFEventHandlerInvalidArgumentCount" reason: [NSString stringWithFormat:@"\nMethod '%@' of class '%@' has an incorrect number of arguments. There was %d needed and %d was given.", NSStringFromSelector(selector), NSStringFromClass([observer class]), signatureCount - 2, argumentCount]  userInfo:nil];
        
        if([signature numberOfArguments] > 2)
            [self setEventObject:event];
        
        [self setupArgsWithMsgSend];
    }
}

- (void)setupArgsWithMsgSend
{
    if(!observer)
        @throw [NSException exceptionWithName:@"AFFEventInvalidObserverException" reason:[NSString stringWithFormat:@"\nMethod '%@' was sent to the deallocated observer class '%@'.", NSStringFromSelector(selector), NSStringFromClass([observer class])] userInfo:nil];
    
    switch (args.count)
    {
        case 0:
            objc_msgSend(observer, selector);
            break;
        case 1:
            objc_msgSend(observer, selector, [args objectAtIndex:0]);
            break;
        case 2:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1]);
            break;
        case 3:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2]);
            break;
        case 4:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3]);
            break;
        case 5:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4]);
            break;
        case 6:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5]);
            break;
        case 7:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6]);
            break;
        case 8:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7]);
            break;
        case 9:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8]);
            break;
        case 10:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9]);
            break;
        case 11:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10]);
            break;
        case 12:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11]);
            break;
        case 13:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12]);
            break;
        case 14:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13]);
            break;
        case 15:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13], [args objectAtIndex:14]);
            break;
        case 16:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13], [args objectAtIndex:14], [args objectAtIndex:15]);
            break;
        case 17:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13], [args objectAtIndex:14], [args objectAtIndex:15], [args objectAtIndex:16]);
            break;
        case 18:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13], [args objectAtIndex:14], [args objectAtIndex:15], [args objectAtIndex:16], [args objectAtIndex:17]);
            break;
        case 19:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13], [args objectAtIndex:14], [args objectAtIndex:15], [args objectAtIndex:16], [args objectAtIndex:17], [args objectAtIndex:18]);
            break;
        case 20:
            objc_msgSend(observer, selector, [args objectAtIndex:0], [args objectAtIndex:1], [args objectAtIndex:2], [args objectAtIndex:3], [args objectAtIndex:4], [args objectAtIndex:5], [args objectAtIndex:6], [args objectAtIndex:7], [args objectAtIndex:8], [args objectAtIndex:9], [args objectAtIndex:10], [args objectAtIndex:11], [args objectAtIndex:12], [args objectAtIndex:13], [args objectAtIndex:14], [args objectAtIndex:15], [args objectAtIndex:16], [args objectAtIndex:17], [args objectAtIndex:18], [args objectAtIndex:19]);
            break;
            
        default:
            break;
    }
}

- (void)setEventObject:(AFFEvent *)event
{
    if(args.count > 0)
    {
        if([[args objectAtIndex:0] isKindOfClass:[AFFEvent class]])
        {
            if([args objectAtIndex:0] != event)
            {
                [args removeObjectAtIndex:0];
                [args insertObject:event atIndex:0];
            }
        } else {
            [args insertObject:event atIndex:0];
        }
    } else {
        [args insertObject:event atIndex:0];
    }
}

- (void)dealloc
{
    sender = nil;
    observer = nil;
    selector = nil;
    eventNameWithHash = nil;
    [args ah_release];
    args = nil;
    
    [super ah_dealloc];
}

@end
