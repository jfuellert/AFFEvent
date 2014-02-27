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

#import "AFFEvent.h"
#import "AFFEventHandler.h"
#include <objc/message.h>

static const NSUInteger kAFFEventHandlerMethodHiddenArgsCount = 2;

@implementation AFFEventHandler

+ (AFFEventHandler *)eventHandlerWithSender:(id)sender observer:(id)observer selector:(SEL)selector name:(NSString *)name args:(NSArray *)args {

    return [[[AFFEventHandler alloc] initWithSender:sender observer:observer selector:selector name:name args:args] autorelease];
}

- (id)initWithSender:(id)sender observer:(id)observer selector:(SEL)selector name:(NSString *)name args:(NSArray *)args {
    
    self = [super init];
    if(self) {
        _sender     = sender;
        _observer   = observer;
        _selector   = selector;
        _args       = [[NSMutableArray alloc] initWithArray:args];
        _isLocked   = NO;
    }
    return self;
}

- (void)invokeWithEvent:(AFFEvent *)event {
    
    if(_observer && _selector) {
        
        if(![_observer respondsToSelector:_selector]) {
            
            NSString *exceptionName = [NSString localizedStringWithFormat:@"AFFEventInvalidSelectorException", nil];
            NSString *reason        = [NSString localizedStringWithFormat:@"\nMethod '%@' was not recognized or does not exist in class '%@'.", NSStringFromSelector(_selector), NSStringFromClass([_observer class])];
            
            throwException(exceptionName, reason);
        }
        
        NSMethodSignature *signature = [_observer methodSignatureForSelector:_selector];
        
        if(!signature) {
            return;
        }
        
        NSUInteger signatureCount = signature.numberOfArguments;
        NSUInteger argumentCount  = _args.count;
        
        //Two arguments are hidden defaults. Check for correct number of arguments
        if(signatureCount - argumentCount < kAFFEventHandlerMethodHiddenArgsCount) {
            
            NSString *exceptionName = [NSString localizedStringWithFormat:@"AFFEventHandlerInvalidArgumentCount", nil];
            NSString *reason        = [NSString localizedStringWithFormat:@"\nMethod '%@' of class '%@' has an incorrect number of arguments. There was %d needed and %d was given.", NSStringFromSelector(_selector), NSStringFromClass([_observer class]), signatureCount - kAFFEventHandlerMethodHiddenArgsCount, argumentCount];
            
            throwException(exceptionName, reason);
        }
        
        if(signature.numberOfArguments > kAFFEventHandlerMethodHiddenArgsCount) {
            [self setEventObject:event];
        }
        
        [self setupArgsWithMsgSend];
    }
}

- (void)setupArgsWithMsgSend {
    
    if(!_observer) {
        
        NSString *exceptionName = [NSString localizedStringWithFormat:@"AFFEventInvalidObserverException", nil];
        NSString *reason        = [NSString localizedStringWithFormat:@"\nMethod '%@' was sent to the deallocated observer class '%@'.", NSStringFromSelector(_selector), NSStringFromClass([_observer class])];
        
        throwException(exceptionName, reason);
    }
    
    switch(_args.count) {
        case 0:
            objc_msgSend(_observer, _selector);
            break;
        case 1:
            objc_msgSend(_observer, _selector, _args[0]);
            break;
        case 2:
            objc_msgSend(_observer, _selector, _args[0], _args[1]);
            break;
        case 3:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2]);
            break;
        case 4:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3]);
            break;
        case 5:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4]);
            break;
        case 6:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5]);
            break;
        case 7:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6]);
            break;
        case 8:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7]);
            break;
        case 9:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8]);
            break;
        case 10:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9]);
            break;
        case 11:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10]);
            break;
        case 12:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11]);
            break;
        case 13:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12]);
            break;
        case 14:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13]);
            break;
        case 15:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14]);
            break;
        case 16:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15]);
            break;
        case 17:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15], _args[16]);
            break;
        case 18:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15], _args[16], _args[17]);
            break;
        case 19:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15], _args[16], _args[17], _args[18]);
            break;
        case 20:
            objc_msgSend(_observer, _selector, _args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15], _args[16], _args[17], _args[18], _args[19]);
            break;
        default:
            break;
    }
}

- (void)setEventObject:(AFFEvent *)event {
    
    if(_args.count > 0) {
        
        if([[_args firstObject] isKindOfClass:[AFFEvent class]]) {
            
            if([_args firstObject] != event) {
                
                [_args removeObjectAtIndex:0];
                [_args insertObject:event atIndex:0];
            }
        } else {
            [_args insertObject:event atIndex:0];
        }
    } else {
        [_args insertObject:event atIndex:0];
    }
}

void throwException(NSString *name, NSString *reason) {
    
    @throw [NSException exceptionWithName:name reason:reason userInfo:nil];
}

- (void)dealloc {
    
    _sender = nil;
    _observer = nil;
    _selector = nil;
    [_eventNameWithHash release];
    _eventNameWithHash = nil;
    [_args release];
    _args = nil;
    
    [super dealloc];
}

@end