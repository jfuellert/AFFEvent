//
//  AFFEventCenter.h
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
#import "AFFEventAPI.h"
#import "AFFEventSystemHandler.h"

#define AFFEventClass       +
#define AFFEventInstance    -

#define AFFEventCreate( $eventLevel, $eventName )                                                   \
$eventLevel (AFFEventAPI *)$eventName

#define AFFEventSynthesize( $eventLevel, $eventName )                                               \
$eventLevel (AFFEventAPI *)$eventName                                                               \
{                                                                                                   \
    return affEventForEventName(@#$eventName, self);                                                \
}

#define AFFRemoveAllEvents()                                                                        \
    affRemoveAllEventsFromSenderHash([(NSObject *)self hash])

#define AFFRemoveEvent( $eventName )                                                                \
    affRemoveEventNamed(@#$eventName, [(NSObject *)self hash])

#define AFFHandler( $selector )                                                                     \
    affCreateHandlerWithSender(nil, self, $selector, nil, nil)

#define AFFHandlerWithArgs( $selector, ... )                                                        \
    affCreateHandlerWithSender(nil, self, $selector, nil, [NSArray arrayWithObjects:__VA_ARGS__,nil])

#define AFFEvents()                                                                                 \
    affEventsFromSenderHash([(NSObject *)self hash])