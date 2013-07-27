//
//  AFFEvent.m
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
#import "ARCHelper.h"

@implementation AFFEvent
@synthesize sender = _sender;
@synthesize data = _data;
@synthesize eventName = _eventName;

id affEventObjectWithSender(id lsender, id ldata, NSString *leventName)
{
    return [[[AFFEvent alloc] initWithSender:lsender andData:ldata andEventName:leventName] ah_autorelease];
}

- (id)initWithSender:(id)lsender andData:(id)ldata andEventName:(NSString *)leventName
{
    self = [super init];
    if(self)
    {
        _sender = lsender;
        _data = ldata;
        _eventName = leventName;
    }
    return self;
}

@end
