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

#import "AFFEventAPI.h"
#import "AFFEventSystemHandler.h"
#import "ARCHelper.h"

static const char *kAFFEventSystemHanderpQueue = "AFFEventCleanupQueue";

@implementation AFFEventSystemHandler

/*
 * Queue
 */
dispatch_queue_t affSystemDispatchQueue(void)
{
    static dispatch_once_t affSystemDispatchQueuePred;
    static dispatch_queue_t affSystemDispatchQueue = nil;
    
    dispatch_once(&affSystemDispatchQueuePred, ^{
        affSystemDispatchQueue = dispatch_queue_create(kAFFEventSystemHanderpQueue, NULL);
    });
    
    return affSystemDispatchQueue;
}

CFMutableDictionaryRef eventDictionary(void)
{    
    static dispatch_once_t eventDictionaryPred;
    static CFMutableDictionaryRef eventDictionary = nil;
    
    dispatch_once(&eventDictionaryPred, ^{
        eventDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    });
    
    return eventDictionary;
}

/*
 * AFFEventAPI retrieval
 */
AFFEventAPI *affEventForEventName(NSString *eventName, id sender)
{
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", [(NSObject *)sender hash]];
    AFFEventAPI *apiObject = nil;
    
    //Create sender APIEvent object dictionary and / or objects if needed
    CFMutableDictionaryRef senderDictionary = (CFMutableDictionaryRef) CFDictionaryGetValue(eventDictionary(), (__bridge void *)senderHashKey);
    
    if(!senderDictionary)
    {
        //Create a blank even
        apiObject = [affEventWithSender(sender, eventName) ah_retain];
        
        //Create sender dictionary with event if no sender dictionary is found
        CFMutableDictionaryRef newDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(newDictionary, (__bridge void *)eventName, (__bridge void *)apiObject);
        
        //Add sub dictionary to master dictionary
        CFDictionarySetValue(eventDictionary(), (__bridge void *)senderHashKey, (__bridge void *)newDictionary);
    } else
    {
        apiObject = [(AFFEventAPI *) CFDictionaryGetValue(senderDictionary, (__bridge void *)eventName) ah_retain];
        
        if(!apiObject)
        {
            //Create event object and add it to the sender dictionary if none already exists
            apiObject = [affEventWithSender(sender, eventName) ah_retain];
            
            CFDictionarySetValue(senderDictionary, (__bridge void *)eventName, (__bridge void *)apiObject);
        }
    }
    
    return [apiObject ah_autorelease];
}

NSArray *affEventsFromSenderHash(NSUInteger senderHash)
{
    NSMutableArray *returnArray;
    
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", senderHash];
    CFDictionaryRef dictionary = (CFMutableDictionaryRef) CFDictionaryGetValue(eventDictionary(), (__bridge void *)senderHashKey);
    
    if(dictionary)
    {
        returnArray = [[NSMutableArray alloc] initWithCapacity:CFDictionaryGetCount(dictionary)];
        
        for(AFFEventAPI *apiObject in [(__bridge NSDictionary *)dictionary allValues])
            [returnArray addObject:apiObject];
        
        [returnArray ah_autorelease];
    } else {
        returnArray = nil;
    }
    
    return returnArray;
}

/*
 * AFFEventAPI deletion
 */
void affRemoveEventNamed(NSString *eventName, NSUInteger senderHash)
{
    dispatch_async(affSystemDispatchQueue(), ^{
        NSString *senderHashKey = [NSString stringWithFormat:@"%d", senderHash];
        CFMutableDictionaryRef dictionary = (CFMutableDictionaryRef) CFDictionaryGetValue(eventDictionary(), (__bridge void *)senderHashKey);
        CFDictionaryRemoveValue(dictionary, (__bridge void *)eventName);
    });
}

void affRemoveAllEventsFromSenderHash(NSUInteger senderHash)
{
    dispatch_async(affSystemDispatchQueue(), ^{
        NSString *senderHashKey = [NSString stringWithFormat:@"%d", senderHash];
        CFDictionaryRemoveValue(eventDictionary(), (__bridge void *)senderHashKey);
    });
}

/*
 * AFFEvent name creation
 */
NSString *affCreateEventName(NSString *eventName, NSUInteger hash)
{
    return [NSString stringWithFormat:@"%@%ud", eventName, hash];
}

@end
