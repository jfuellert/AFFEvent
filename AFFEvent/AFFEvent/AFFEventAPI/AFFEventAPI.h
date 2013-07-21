//
//  AFFEventAPI.h
//  AFFramework
//
//  Created by Jeremy Fuellert on 2013-04-10.
//  Copyright (c) 2013 AFFramework. All rights reserved.
//

#import "AFFEvent.h"
#import "AFFEventHandler.h"
#import "AFFEventSystemHandler.h"

@protocol AFFEventAPI

//Add handler handling
- (id<AFFEventAPI>)addHandler:(AFFEventHandler *)handler;
- (id<AFFEventAPI>)addHandlerOneTime:(AFFEventHandler *)handler;

//Handler removal handling
- (void)removeHandler:(AFFEventHandler *)handler;
- (BOOL)hasHandler:(AFFEventHandler *)handler;
- (void)removeHandlers:(NSSet *)handlerSet;
- (void)removeAllHandlers:(id)observer;
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
    
    @private
    NSMutableArray *handlers;
}

//Creation
+ (AFFEventAPI *)eventWithSender:(id)lsender andEventName:(NSString *)leventName;
- (AFFEventAPI *)initWithSender:(id)lsender andEventName:(NSString *)leventName;

@end
