//
//  AFFEventStatics.h
//  AFFEvent
//
//  Created by Jeremy Fuellert on 2/25/2014.
//  Copyright (c) 2014 AFApps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AFFEventType) {
    
    AFFEventTypeNone                    = 0,
    AFFEventTypeOneTime                 = 1 << 1,
    AFFEventTypeWillExecuteInBacground  = 1 << 2
};
