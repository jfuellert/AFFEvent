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

@implementation AFFEventSystemHandler

CFMutableDictionaryRef __eventDictionary(void) {
    
    static dispatch_once_t eventDictionaryPred;
    static CFMutableDictionaryRef eventDictionary = nil;
    
    dispatch_once(&eventDictionaryPred, ^{
        eventDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    });

    return eventDictionary;
}

#pragma mark - AFFEventAPI retrieval
AFFEventAPI *__affEventForEventName(NSString *eventName, id sender) {
    
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", [(NSObject *)sender hash]];
    AFFEventAPI *apiObject = nil;
    
    //Create sender APIEvent object dictionary and / or objects if needed
    CFMutableDictionaryRef senderDictionary = (CFMutableDictionaryRef) CFDictionaryGetValue(__eventDictionary(), (void *)senderHashKey);

    if(!senderDictionary) {
        
        //Create a blank event
        apiObject = [[AFFEventAPI eventWithSender:sender name:eventName] retain];
        
        //Create sender dictionary with event if no sender dictionary is found
        CFMutableDictionaryRef newDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(newDictionary, (void *)eventName, apiObject);
        
        //Add sub dictionary to master dictionary
        CFDictionarySetValue(__eventDictionary(), (void *)senderHashKey, newDictionary);
        CFRelease(newDictionary);
    } else {
        apiObject = [(AFFEventAPI *) CFDictionaryGetValue(senderDictionary, (void *)eventName) retain];
        
        if(!apiObject) {
            
            //Create event object and add it to the sender dictionary if none already exists
            apiObject = [[AFFEventAPI eventWithSender:sender name:(void *)eventName] retain];
            
            CFDictionarySetValue(senderDictionary, (void *)eventName, apiObject);
        }
    }
    
    return [apiObject autorelease];
}

NSArray *__affEventsFromSenderHash(NSUInteger senderHash) {
    
    NSMutableArray *returnArray;
    
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", senderHash];
    CFDictionaryRef dictionary = (CFMutableDictionaryRef) CFDictionaryGetValue(__eventDictionary(), (void *)senderHashKey);
    
    if(dictionary) {
        returnArray = [[NSMutableArray alloc] initWithCapacity:CFDictionaryGetCount(dictionary)];
        
        for(AFFEventAPI *apiObject in [(NSDictionary *)dictionary allValues]) {
            [returnArray addObject:apiObject];
        }
        
        [returnArray autorelease];
    } else {
        returnArray = nil;
    }
    
    return returnArray;
}

#pragma mark - AFFEventAPI deletion
void __affRemoveEventNamed(NSString *eventName, NSUInteger senderHash) {
    
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", senderHash];
    CFMutableDictionaryRef dictionary = (CFMutableDictionaryRef) CFDictionaryGetValue(__eventDictionary(), (void *)senderHashKey);
    CFDictionaryRemoveValue(dictionary, eventName);
}

void __affRemoveAllEventsFromSenderHash(NSUInteger senderHash) {
    
    NSString *senderHashKey = [NSString stringWithFormat:@"%d", senderHash];
    
    if(CFDictionaryContainsKey(__eventDictionary(), (void *)senderHashKey))
        CFDictionaryRemoveValue(__eventDictionary(), (void *)senderHashKey);
}

#pragma mark -  AFFEvent name creation
NSString *__affCreateEventName(NSString *eventName, NSUInteger hash) {
    
    return [NSString stringWithFormat:@"%@%ud", eventName, hash];
}

@end