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

#import "AFFEvent.h"
#import "AFFEventHandler.h"
#import "AFFEventSystemHandler.h"

@protocol AFFEventAPI

//Add handler handling
- (id<AFFEventAPI>)addHandler:(AFFEventHandler *)handler;
- (id<AFFEventAPI>)addHandlerOneTime:(AFFEventHandler *)handler;

//Handler methods
- (BOOL)hasHandler:(AFFEventHandler *)handler;
- (NSSet *)handlers;
- (NSSet *)handlersForObserver:(id)observer;

//Handler removal handling
- (void)removeHandler:(AFFEventHandler *)handler;
- (void)removeHandlers:(NSSet *)handlerSet;
- (void)removeAllHandlersForObserver:(id)observer;
- (void)removeAllHandlers;

//Sending event and data handling
- (void)send;
- (void)send:(id)data;

@end

@interface AFFEventAPI : NSObject<AFFEventAPI>
{
    @public
    id sender;
    id target;
    NSString *eventName;
}

//Creation
AFFEventAPI *affEventWithSender(id lsender, NSString *leventName);

@end
