//
//  AFFEventSystemHandler.m
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
//  ****************************************************************
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
#import <objc/runtime.h>

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
- (AFFEventAPI *)eventForEventName:(const char *)eventName fromSender:(id)sender
{
    const char *senderHashKey = createEventName(eventName, [(NSObject *)sender hash]);
    
    AFFEventAPI *apiObject = nil;
    NSMutableDictionary *senderDictionary = nil;
    
    //Create sender APIEvent object dictionary and / or objects if needed
    senderDictionary = (NSMutableDictionary *)[eventDictionary objectForKey:[NSString stringWithUTF8String:eventName]];
    
    if(!senderDictionary)
    {
        //Create sender dictionary with event if no sender dictionary is found
        apiObject = [[AFFEventAPI alloc] initWithSender:sender andEventName:eventName];
        
        NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
        [newDictionary setObject:apiObject forKey:[NSString stringWithUTF8String:eventName]];
        
        [eventDictionary setObject:newDictionary forKey:[NSString stringWithUTF8String:eventName]];
        
    } else
    {
        apiObject = [(AFFEventAPI *)[senderDictionary objectForKey:[NSString stringWithUTF8String:eventName]] ah_retain];
        
        if(!apiObject)
        {
            //Create event object and add it to the sender dictionary if none already exists
            apiObject = [[AFFEventAPI alloc] initWithSender:sender andEventName:eventName];
            [senderDictionary setObject:apiObject forKey:[NSString stringWithUTF8String:eventName]];
        }
    }
    
//    AFFEventAPI *apiObject = objc_getAssociatedObject(sender, &senderHashKey);
//    
//    
//    if(!apiObject)
//    {
//        //Create event object and add it to the sender dictionary if none already exists
//        apiObject = [[AFFEventAPI alloc] initWithSender:sender andEventName:eventName];
//        
//        objc_setAssociatedObject(sender, &senderHashKey, apiObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        
//        [apiObject ah_release];
//    }
    
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
- (void)removeEventNamed:(const char *)eventName fromSenderHash:(NSUInteger)senderHash
{
//    void objc_removeAssociatedObjects(id object)
    
    
    
    
    
    
    
    
    
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[eventDictionary objectForKey:[NSString stringWithFormat:@"%d", senderHash]];
    [dictionary removeObjectForKey:[NSString stringWithUTF8String:eventName]];
}

- (void)removeEventsFromSenderHash:(NSUInteger)senderHash;
{
//    objc_removeAssociatedObjects(<#id object#>)
    [eventDictionary removeObjectForKey:[NSString stringWithFormat:@"%d", senderHash]];
}

/*
 * AFFEvent name creation
 */
const char *createEventName (const char *eventName, NSUInteger hash)
{    
    //Hash string
    char hashString [40];
    sprintf(hashString, "%d", hash);
    
    //Concat
    char *eventWithHash = malloc(strlen(eventName) + strlen(hashString));
    
    if(!eventWithHash)
        return NULL;
    
    strcpy(eventWithHash, eventName);
    strcat(eventWithHash, hashString);
    
    return eventWithHash;
}

@end
