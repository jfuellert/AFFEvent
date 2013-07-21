//
//  AFFEventSystemHandler.m
//  AFFramework
//
//  Created by Jeremy Fuellert on 2013-04-10.
//  Copyright (c) 2013 AFFramework. All rights reserved.
//
//  The 'eventDictionary' object holds any custom events in the application.
//  The 'eventDictionary' object has two tiers of objects. The first tier contains a sender hash key.
//  The 'eventDictionary' object's sender key then contains a dictionary of AFFEventAPI objects with
//  associated event names for keys.
//
//  eventDictionary -> ('NSDictionary' for key 'senderHash')
//      dictionary -> ('AFFEventAPI' for key 'eventName')
//

#import "AFFEventAPI.h"
#import "AFFEventSystemHandler.h"
#import "ARCHelper.h"

@implementation AFFEventSystemHandler

+ (AFFEventSystemHandler *)eventSystem
{
    static dispatch_once_t pred;
    static AFFEventSystemHandler *_singletonInstance = nil;
    
    dispatch_once(&pred, ^{
        _singletonInstance = [AFFEventSystemHandler new];
    });
    
	return _singletonInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        eventDictionary = [NSMutableDictionary new];
    }
    return self;
}

/*
 * AFFEventAPI retrieval
 */
- (AFFEventAPI *)eventForEventName:(NSString *)eventName fromSender:(id)sender
{
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", [(NSObject *)sender hash]];
    NSMutableDictionary *senderDictionary = nil;
    AFFEventAPI *apiObject = nil;
    
    //Create sender APIEvent object dictionary and / or objects if needed
    senderDictionary = (NSMutableDictionary *)[eventDictionary objectForKey:senderHashKey];
    
    if(!senderDictionary)
    {
        //Create sender dictionary with event if no sender dictionary is found
        apiObject = [[AFFEventAPI alloc] initWithSender:sender andEventName:eventName];
        
        NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
        [newDictionary setObject:apiObject forKey:eventName];
        
        [eventDictionary setObject:newDictionary forKey:senderHashKey];
        
    } else
    {
        apiObject = [(AFFEventAPI *)[senderDictionary objectForKey:eventName] ah_retain];
        
        if(!apiObject)
        {
            //Create event object and add it to the sender dictionary if none already exists
            apiObject = [[AFFEventAPI alloc] initWithSender:sender andEventName:eventName];
            [senderDictionary setObject:apiObject forKey:eventName];
        }
    }
    
    return [apiObject ah_autorelease];
}

- (NSArray *)eventsFromSenderHash:(NSUInteger)senderHash
{
    NSMutableArray *returnArray = [NSMutableArray new];
    NSMutableDictionary *dictionary = nil;
    
    dictionary = (NSMutableDictionary *)[eventDictionary objectForKey:[NSString stringWithFormat:@"%d", senderHash]];
    
    for(AFFEventAPI *apiObject in [dictionary allValues])
        [returnArray addObject:apiObject];
    
    return [returnArray ah_autorelease];
}

/*
 * AFFEventAPI deletion
 */
- (void)removeEventNamed:(NSString *)eventName fromSenderHash:(NSUInteger)senderHash
{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[eventDictionary objectForKey:[NSString stringWithFormat:@"%d", senderHash]];
    [dictionary removeObjectForKey:eventName];
}

- (void)removeEventsFromSenderHash:(NSUInteger)senderHash;
{
    [eventDictionary removeObjectForKey:[NSString stringWithFormat:@"%d", senderHash]];
}

/*
 * AFFEvent name creation
 */
NSString *createEventName (NSString *eventName, NSUInteger hash)
{
    return [NSString stringWithFormat:@"%@_%ud", eventName, hash];
}

- (void)dealloc
{
    [eventDictionary ah_release];
    eventDictionary = nil;
    [super ah_dealloc];
}

@end
